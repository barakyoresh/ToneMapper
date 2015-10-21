// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMGLProgramAttribute

- (instancetype)initWithName:(const char*)name valuePointer:(const GLvoid *)valuePointer
                        size:(GLint)size type:(GLenum)type andStride:(GLsizei)stride {
  if (self = [super init]) {
    _name = name;
    _stride = stride;
    _size = size;
    _type = type;
    _valuePointer = valuePointer;
  }
  return self;
}


@end

NS_ASSUME_NONNULL_END
