// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLIdentityFilter.h"

#import "TMGLTextureFrameBuffer.h"
#import "TMGLDrawer.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLIdentityFilter()

/// Internal \c TMGLDrawer to use when drawing the input texture to the output.
@property (nonatomic, strong) TMGLDrawer *drawer;

/// Internal \c TMGLTextureFrameBuffer object to be drawn on.
@property (nonatomic, strong) TMGLTextureFrameBuffer *frameBuffer;

/// Internal \c TMGLProgramParameters to be used for drawing.
@property (nonatomic, strong) TMGLProgramParameters *identityProgramParameters;

@end

@implementation TMGLIdentityFilter

- (instancetype)initWithProgramCompiler:(id<TMGLProgramCompiler>)programCompiler {
  if (self = [super init]) {
    _drawer = [[TMGLDrawer alloc] initWithProgramCompiler:programCompiler];
    _identityProgramParameters = [TMGLProgramParametersBuilder identityProgramParameters];
  }
  return self;
}

- (TMGLTexture *)applyOnTexture:(TMGLTexture * __nonnull)inputTexture {
  if (!self.frameBuffer || CGSizeEqualToSize(self.frameBuffer.size, inputTexture.size)) {
    self.frameBuffer = [[TMGLTextureFrameBuffer alloc] initWithSize:inputTexture.size];
  }
  [self.drawer drawTexture:inputTexture toFrameBuffer:self.frameBuffer
     WithProgramParameters:self.identityProgramParameters];
  return self.frameBuffer.texture;
}

@end

NS_ASSUME_NONNULL_END
