// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform2f.h"

NS_ASSUME_NONNULL_BEGIN


@interface TMGLProgramUniform2f()

/// This uniform's 2 float vector value pointer.
@property (nonatomic) GLfloat *valuePointer;

@end

@implementation TMGLProgramUniform2f

- (instancetype)initWithName:(NSString *)name andValuePointer:(GLfloat *)valuePointer {
  if (self = [super init]) {
    _name = name;
    _valuePointer = malloc(sizeof(GLKVector2));
    memcpy(_valuePointer, valuePointer, sizeof(GLKVector2));
  }
  return self;
}

- (void)sendAtLocation:(GLuint)location {
  glUniform2fv(location, 1, self.valuePointer);
}

- (void)dealloc {
  free(self.valuePointer);
}

- (NSString *)name {
  return _name;
}

@end

NS_ASSUME_NONNULL_END
