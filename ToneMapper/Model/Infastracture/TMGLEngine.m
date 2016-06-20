// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLEngine.h"

#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>

#import "TMGLProgramParametersBuilder.h"
#import "TMGLGeometry.h"
#import "TMGLProgramUniformMatrix4f.h"
#import "TMGLProgramUniform1i.h"
#import "TMGLTextureFrameBuffer.h"
#import "TMGLDefaultProgramCompiler.h"
#import "TMGLDrawer.h"
#import "TMGLIdentityFilter.h"
#import "TMGLImageRenderer.h"

static NSString * const kModelViewProjectionMatrixUniform = @"MVP";

NS_ASSUME_NONNULL_BEGIN

@interface TMGLEngine()

/// Parameters of the internal workspace inspection program.
@property (strong, nonatomic) TMGLProgramParameters *workspaceInspectorProgram;

/// Size of last bound view according to usage of the viewCreatedOfSize:(CGSize)size method.
@property (readonly, nonatomic) CGSize outputSize;

/// Texture object associated with the current workspace state input state.
@property (strong, nonatomic) TMGLTexture *inputTexture;

/// Texture object assoiciated with the current workspace output state.
@property (strong, nonatomic) TMGLTexture *outputTexture;

/// Internal \c TMGLDrawer object to enable panning, zooming and displaying of the output texture.
@property (strong, readonly, nonatomic) TMGLDrawer *drawer;

/// Internal \c TMGLFilter object to enable copying of textures once a feature filter result is
/// satisfactory to the user and needs to be set as the current workspace.
@property (strong, readonly, nonatomic) TMGLIdentityFilter *identityProccess;

/// Image renderer for extracting \c UIImage from a \c TMGLTexture object
@property (strong, readonly, nonatomic) TMGLImageRenderer *imageRenderer;

/// Translation and scale offset of the output texture compared to workspace display stored a matrix.
@property (nonatomic) GLKMatrix4 translationScale;

@end

@implementation TMGLEngine

- (instancetype)initWithDrawer:(TMGLDrawer *)drawer {
  if (!drawer) {
    return nil;
  }
  
  if (self = [super init]) {
    _drawer = drawer;
    _identityProccess = [[TMGLIdentityFilter alloc] initWithDrawer:self.drawer];
    _imageRenderer = [[TMGLImageRenderer alloc] initWithDrawer:self.drawer];
    self.workspaceInspectorProgram = [TMGLProgramParametersBuilder identityProgramParameters];
    [self resetTranslationScale];
  }
  return self;
}

- (TMGLTexture *)workspaceTexture {
  return self.inputTexture;
}

#pragma mark -
#pragma mark Drawing
#pragma mark -

- (void)draw {
  [self.drawer drawTexture:self.outputTexture toFrameBuffer:self.outputBuffer
              withProgramParameters:self.workspaceInspectorProgram];
}

- (void)applyFilter:(id<TMGLFilter>)filter {
  self.outputTexture = [filter applyOnTexture:self.inputTexture];
}

- (void)cancelFilter {
  self.outputTexture = self.inputTexture;
}

- (void)acceptFilter {
  self.inputTexture = [self.identityProccess applyOnTexture:self.outputTexture];
  [self cancelFilter];
}

#pragma mark -
#pragma mark Image importing and exporting
#pragma mark -

- (void)loadImage:(UIImage *)image completionHandler:(TMErrorBlock)completionHandler {
  [self.imageRenderer textureFromImage:image completionHandler:^
  (TMGLTexture * __nullable texture, NSError * __nullable error) {
    if (texture) {
      self.inputTexture = texture;
      self.outputTexture = texture;
      [self resetTranslationScale];
      [self updateWorkspaceInspectorMVPMatrix:[self aspectRatioTransformationMatrix]];
      completionHandler(nil);
    } else {
      completionHandler(error);
    }
  }];
  return;
}

- (void)imageFromWorkspaceWithCompletionHandler:(TMImageErrorBlock)completionHandler {
  [self.imageRenderer imageFromTexture:self.inputTexture completionHandler:completionHandler];
}

#pragma mark -
#pragma mark Workspace Inspector Program
#pragma mark -

- (void)updateWorkspaceInspectorMVPMatrix:(GLKMatrix4)MVP {
  self.workspaceInspectorProgram =
    [self.workspaceInspectorProgram parametersWithReplacedUniform:
     [[TMGLProgramUniformMatrix4f alloc] initWithName:kModelViewProjectionMatrixUniform
                                      andValuePointer:(GLfloat *)&MVP]];
}

#pragma mark -
#pragma mark Display
#pragma mark -

- (void)resetTranslationScale {
  self.translationScale = GLKMatrix4Identity;
}

- (void)panOffset:(CGPoint)offset ended:(BOOL)ended {
  GLKMatrix4 translationScale = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(offset.x, offset.y, 0),
                                                   self.translationScale);
  
  [self updateWorkspaceInspectorMVPMatrix:
    GLKMatrix4Multiply(translationScale, [self aspectRatioTransformationMatrix])];
  if (ended) {
    self.translationScale = translationScale;
  }
}

- (void)zoomScaleOffset:(CGFloat)offset focalPoint:(CGPoint)focalPoint ended:(BOOL)ended {
  GLKMatrix4 translationScale =
    GLKMatrix4Multiply(GLKMatrix4MakeTranslation(-focalPoint.x, -focalPoint.y, 0),
                       self.translationScale);
  translationScale = GLKMatrix4Multiply(GLKMatrix4MakeScale(1 + offset, 1 + offset, 1),
                                        translationScale);
  translationScale = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(focalPoint.x, focalPoint.y, 0),
                                        translationScale);
  [self updateWorkspaceInspectorMVPMatrix:GLKMatrix4Multiply(translationScale,
                                                          [self aspectRatioTransformationMatrix])];
  if (ended) {
    self.translationScale = translationScale;
  }
}

- (void)setOutputBuffer:(id<TMGLBuffer>)outputBuffer {
  _outputBuffer = outputBuffer;
  [self updateWorkspaceInspectorMVPMatrix:GLKMatrix4Multiply(self.translationScale,
      [self aspectRatioTransformationMatrix])];
}

- (CGSize)outputSize {
  if (self.outputBuffer) {
    return self.outputBuffer.size;
  } else {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width * [[UIScreen mainScreen] scale],
                      [UIScreen mainScreen].bounds.size.height * [[UIScreen mainScreen] scale]);
  }
}

- (GLKMatrix4)aspectRatioTransformationMatrix {
  GLKMatrix4 aspectRatioMatrix = GLKMatrix4Identity;

  float imageAspectRatio =
    (self.inputTexture.size.width / self.inputTexture.size.height);
  float viewAspectRatio = (self.outputSize.width / self.outputSize.height);
  float targetAspectRatio = imageAspectRatio / viewAspectRatio;
  
  if (isnan(targetAspectRatio)) {
    return aspectRatioMatrix;
  }
  
  if (targetAspectRatio > 1) {
    //clip to width
    aspectRatioMatrix = GLKMatrix4MakeScale(1, -(1 / targetAspectRatio), 1);
  } else {
    //clip to height
    aspectRatioMatrix = GLKMatrix4MakeScale(1 * targetAspectRatio, -1, 1);
  }

  return aspectRatioMatrix;
}

@end

NS_ASSUME_NONNULL_END
