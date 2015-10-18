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
@property (nonatomic, strong) TMGLProgramParameters *workspaceInspectorProgram;

/// External frame buffer used as output in the draw cycle.
@property (nonatomic, strong) id <TMGLBuffer> outputBuffer;

/// Size of last bound view according to usage of the viewCreatedOfSize:(CGSize)size method.
@property (nonatomic, readonly) CGSize outputSize;

/// Texture object associated with the current workspace state input state.
@property (nonatomic, strong) TMGLTexture *inputTexture;

/// Texture object assoiciated with the current workspace output state.
@property (nonatomic, strong) TMGLTexture *outputTexture;

/// Internal \c TMGLDrawer object to enable panning, zooming and displaying of the output texture.
@property (nonatomic, strong) TMGLDrawer *displayRenderer;

/// Internal \c TMGLFilter object to enable copying of textures once a feature filter result is
/// satisfactory to the user and needs to be set as the current workspace.
@property (nonatomic, strong) TMGLIdentityFilter *identityProccess;

/// Image renderer for extracting \c UIImage from a \c TMGLTexture object
@property (nonatomic, strong) TMGLImageRenderer *imageRenderer;

@end

@implementation TMGLEngine

- (instancetype)initWithProgramCompiler:(id<TMGLProgramCompiler> __nonnull)programCompiler {
  if (self = [super init]) {
    self.displayRenderer = [[TMGLDrawer alloc] initWithProgramCompiler:programCompiler];
    self.identityProccess = [[TMGLIdentityFilter alloc] initWithProgramCompiler:programCompiler];
    self.imageRenderer = [[TMGLImageRenderer alloc] initWithProgramCompiler:programCompiler];
    self.workspaceInspectorProgram = [TMGLProgramParametersBuilder identityProgramParameters];
  }
  return self;
}

#pragma mark -
#pragma mark Drawing
#pragma mark -

- (void)draw {
  [self.displayRenderer drawTexture:self.outputTexture toFrameBuffer:self.outputBuffer
              WithProgramParameters:self.workspaceInspectorProgram];
}

- (void)useFilter:(id<TMGLFilter> __nonnull)filter {
  self.outputTexture = [filter applyOnTexture:self.inputTexture];
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


- (void)outputBuffer:(id<TMGLBuffer> __nonnull)outputBuffer {
  self.outputBuffer = outputBuffer;
}

- (CGSize)outputSize {
  if (self.outputBuffer) {
    return self.outputBuffer.size;
  } else {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width * [[UIScreen mainScreen] scale],
                      [UIScreen mainScreen].bounds.size.height * [[UIScreen mainScreen] scale]);
  }
}

- (void)panOffset:(CGPoint)offset andZoomScale:(float)scale{
  GLKMatrix4 MVP = [self aspectRatioTransformationMatrix];
  MVP = GLKMatrix4Multiply(GLKMatrix4MakeScale(scale, scale, 1), MVP);
  MVP = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(offset.x, offset.y, 0), MVP);
  
  [self updateWorkspaceInspectorMVPMatrix:MVP];
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
    aspectRatioMatrix = GLKMatrix4MakeScale(1, 1 / targetAspectRatio, 1);
  } else {
    //clip to height
    aspectRatioMatrix = GLKMatrix4MakeScale(1 * targetAspectRatio, 1, 1);
  }

  return aspectRatioMatrix;
}

@end

NS_ASSUME_NONNULL_END
