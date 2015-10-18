// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLTextureFrameBuffer.h"

#import <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMGLTextureFrameBuffer()

/// Handle to the framebuffer.
@property (nonatomic, readwrite) GLuint handle;

/// Framebuffer's texture object.
@property (nonatomic, strong) TMGLTexture *texture;

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
  
  self.texture = [[TMGLTexture alloc] initWithSize:size];
  [self.texture attachToFrameBuffer];
  
  // FBO status check
  GLenum status;
  status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
  switch(status) {
    case GL_FRAMEBUFFER_COMPLETE:
      NSLog(@"fbo complete");
      glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
      return YES;
      
    case GL_FRAMEBUFFER_UNSUPPORTED:
      NSLog(@"fbo unsupported");
      glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
      return NO;
      
    default:
      /* programming error; will fail on all hardware */
      NSLog(@"Framebuffer Error");
      glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
      return NO;
  }
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
