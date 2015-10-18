// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform1i.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramUniform1i()

/// This uniform's Integer value saved as a \c GLint.
@property (nonatomic) GLint value;

// This unifrom's name corresponding to a shader file's uniform variable.
@property (nonatomic, strong) NSString *name;

@end

@implementation TMGLProgramUniform1i

- (instancetype)initWithName:(NSString *)name andValue:(GLint)value {
  if (self = [super init]) {
    _name = name;
    _value = value;
  }
  return self;
}

- (void)sendUnifrom:(GLuint)program {
  glUniform1i(glGetUniformLocation(program, [self.name cStringUsingEncoding:NSUTF8StringEncoding]),
              self.value);
}

- (NSString *)name {
  return _name;
}

@end

NS_ASSUME_NONNULL_END
