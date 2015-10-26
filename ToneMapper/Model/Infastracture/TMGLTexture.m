// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLTexture.h"

#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMGLTexture()

/// Handle to this texture for opengl operations.
@property (readonly, nonatomic) GLuint handle;

@end

@implementation TMGLTexture

- (instancetype)initWithImage:(UIImage *)image {
  if (!image) {
    return nil;
  }
  
  if (self = [super init]) {
    glGetError(); // handles glktextureloader bug.
    
    NSError *textureLoaderError = nil;
    
    NSLog(@"UIImage: %@", image);
    NSLog(@"CGImage: %@", [image CGImage]);
    
    GLKTextureInfo *texture =
        [GLKTextureLoader textureWithCGImage:[image CGImage] options:0 error:&textureLoaderError];
    if (textureLoaderError) {
      NSLog(@"createTexture error: %@", textureLoaderError);
      return nil;
    }
    
    _handle = [texture name];
    _size = image.size;
  }
  return self;
}

- (instancetype)initWithSize:(CGSize)size {
  if (self = [super init]) {
    glGenTextures(1, &_handle);
    if (!_handle) {
      NSLog(@"createTexture error: glGenTexture failure");
      return nil;
    }
    _size = size;
    glBindTexture(GL_TEXTURE_2D, self.handle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  }
  
  return self;
}

- (void)attachToFrameBuffer {
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.handle, 0);
}

- (void)bind {
  glBindTexture(GL_TEXTURE_2D, self.handle);
}

- (void)dealloc {
  glDeleteTextures(1, &_handle);
}

@end

NS_ASSUME_NONNULL_END
