// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgram.h"

NS_ASSUME_NONNULL_BEGIN

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

- (void)dealloc {
  glDeleteProgram(self.handle);
}

@end

NS_ASSUME_NONNULL_END
