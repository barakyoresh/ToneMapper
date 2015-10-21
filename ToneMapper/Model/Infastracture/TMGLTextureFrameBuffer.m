// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLTextureFrameBuffer.h"

#import <OpenGLES/ES2/gl.h>

#import "TMGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLTextureFrameBuffer()

/// Handle to the framebuffer.
@property (readonly, nonatomic) GLuint handle;

@end

@implementation TMGLTextureFrameBuffer

- (instancetype)initWithSize:(CGSize)size {
  if (self = [super init]) {
    BOOL success = [self frameBufferOfSize:size handle:(GLint *)&_handle];
    if (!success) {
      return nil;
    }
  }
  return self;
}

- (BOOL)frameBufferOfSize:(CGSize)size handle:(GLint *)handle{
  GLint currentFrameBuffer;
  glGetIntegerv(GL_FRAMEBUFFER_BINDING, &currentFrameBuffer);
  
  glGenFramebuffers(1, (GLuint *)handle);
  glBindFramebuffer(GL_FRAMEBUFFER, *handle);
  
  _texture = [[TMGLTexture alloc] initWithSize:size];
  [self.texture attachToFrameBuffer];
  
  // FBO status check
  GLenum status;
  BOOL success = NO;
  status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
  if (status == GL_FRAMEBUFFER_COMPLETE) {
    NSLog(@"fbo complete");
    success = YES;
  } else {
    NSLog(@"Framebuffer Error, status:%d", status);
  }
  glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
  return success;
}

- (CGSize)size {
  return self.texture.size;
}

- (void)bind {
  glBindFramebuffer(GL_FRAMEBUFFER, self.handle);
}

- (void)dealloc {
  glDeleteFramebuffers(1, &_handle);
}

@end

NS_ASSUME_NONNULL_END
