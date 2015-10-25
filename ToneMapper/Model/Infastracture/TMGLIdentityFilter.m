// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLIdentityFilter.h"

#import "TMGLTextureFrameBuffer.h"
#import "TMGLDrawer.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLGeometry.h"
#import "TMGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLIdentityFilter()

/// Internal \c TMGLDrawer to use when drawing the input texture to the output.
@property (strong, readonly, nonatomic) TMGLDrawer *drawer;

/// Internal \c TMGLTextureFrameBuffer object to be drawn on.
@property (strong, nonatomic) TMGLTextureFrameBuffer *frameBuffer;

/// Internal \c TMGLProgramParameters to be used for drawing.
@property (strong, readonly, nonatomic) TMGLProgramParameters *identityProgramParameters;

@end

@implementation TMGLIdentityFilter

- (instancetype)initWithDrawer:(TMGLDrawer *)drawer {
  if (!drawer) {
    return nil;
  }
  
  if (self = [super init]) {
    _drawer = drawer;
    _identityProgramParameters = [TMGLProgramParametersBuilder identityProgramParameters];
  }
  return self;
}

- (TMGLTexture *)applyOnTexture:(TMGLTexture * __nonnull)inputTexture {
  if (!self.frameBuffer || !CGSizeEqualToSize(self.frameBuffer.size, inputTexture.size)) {
    self.frameBuffer = [[TMGLTextureFrameBuffer alloc] initWithSize:inputTexture.size];
  }
  [self.drawer drawTexture:inputTexture toFrameBuffer:self.frameBuffer
     withProgramParameters:self.identityProgramParameters];
  return self.frameBuffer.texture;
}

@end

NS_ASSUME_NONNULL_END
