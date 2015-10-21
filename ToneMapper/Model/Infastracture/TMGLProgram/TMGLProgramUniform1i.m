// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform1i.h"
#import "TMGLProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramUniform1i()

/// This uniform's Integer value saved as a \c GLint.
@property (readonly, nonatomic) GLint value;

@end

@implementation TMGLProgramUniform1i

- (instancetype)initWithName:(NSString *)name andValue:(GLint)value {
  if (self = [super init]) {
    _name = name;
    _value = value;
  }
  return self;
}

- (void)sendAtLocation:(GLuint)location {
  glUniform1i(location, self.value);
}

@end

NS_ASSUME_NONNULL_END
