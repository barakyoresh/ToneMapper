// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramAttribute()

/// Name of the attribute.
@property (nonatomic, readwrite) const char *name;

/// Pointer to the attribute value array.
@property (nonatomic, readwrite) const GLvoid *valuePointer;

/// Size of each attribute entry.
@property (nonatomic, readwrite) GLint size;

/// Type of each attribute entry's coordinates.
@property (nonatomic, readwrite) GLenum type;

/// Distance between attribute entries.
@property (nonatomic, readwrite) GLsizei stride;

@end

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
