// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgram.h"

#import "TMGLProgramUniform.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgram ()

/// Opengl handle to the compiled program.
@property (readonly, nonatomic) GLuint handle;

@end

@implementation TMGLProgram

- (instancetype)initWithHandle:(GLuint)handle {
  if (self = [super init]) {
    _handle = handle;
  }
  return self;
}

- (void)use {
  glUseProgram(self.handle);
}

- (void)sendUniform:(id<TMGLProgramUniform>)uniform {
  [uniform sendAtLocation:glGetUniformLocation(self.handle,
      [uniform.name cStringUsingEncoding:NSUTF8StringEncoding])];
}

- (void)dealloc {
  glDeleteProgram(self.handle);
}

@end



NS_ASSUME_NONNULL_END
