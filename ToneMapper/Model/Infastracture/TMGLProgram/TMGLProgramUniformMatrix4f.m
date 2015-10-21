// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniformMatrix4f.h"

#import <GLKit/GLKit.h>

#import "TMGLProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramUniformMatrix4f()

/// This uniform's 4-by-4 float matrix value pointer.
@property (nonatomic) GLfloat *valuePointer;

@end

@implementation TMGLProgramUniformMatrix4f

- (instancetype)initWithName:(NSString *)name andValuePointer:(GLfloat *)valuePointer {
  if (self = [super init]) {
    _name = name;
    _valuePointer = malloc(sizeof(GLKMatrix4));
    memcpy(_valuePointer, valuePointer, sizeof(GLKMatrix4));
  }
  return self;
}

- (void)sendAtLocation:(GLuint)location {
  glUniformMatrix4fv(location, 1, FALSE, self.valuePointer);
}

- (void)dealloc {
  free(self.valuePointer);
}

- (NSString *)name {
  return _name;
}

@end


NS_ASSUME_NONNULL_END
