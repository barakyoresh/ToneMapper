// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLScreenRenderBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLScreenRenderBuffer()

/// \c GLKView object from which to infer relevant framebuffer data.
@property (strong, readonly, nonatomic) GLKView *glkView;

@end

@implementation TMGLScreenRenderBuffer

- (instancetype)initWithGLKView:(GLKView *)glkView {
  if (self = [super init]) {
    _glkView = glkView;
  }
  return self;
}

- (void)bind {
  [self.glkView bindDrawable];
}

- (CGSize)size {
  return CGSizeMake(self.glkView.frame.size.width * [[UIScreen mainScreen] scale],
                    self.glkView.frame.size.height * [[UIScreen mainScreen] scale]);
}

@end

NS_ASSUME_NONNULL_END
