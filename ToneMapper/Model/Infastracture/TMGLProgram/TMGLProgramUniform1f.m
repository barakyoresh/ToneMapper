// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform1f.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramUniform1f()

/// This uniform's Integer value saved as a \c GLint.
@property (readonly, nonatomic) GLfloat value;

@end

@implementation TMGLProgramUniform1f

- (instancetype)initWithName:(NSString *)name andValue:(GLfloat)value {
  if (self = [super init]) {
    _name = name;
    _value = value;
  }
  return self;
}

- (void)sendAtLocation:(GLuint)location {
  glUniform1f(location, self.value);
}


@end

NS_ASSUME_NONNULL_END
