// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

/// Value class containing necessary information for an opengl attribute.
@interface TMGLProgramAttribute : NSObject

/// Initializes \c TMGLProgramAttribute with \c name, \c valuePointer, \c size, \c type and
/// \c stride.
- (instancetype)initWithName:(const char*)name valuePointer:(const GLvoid *)valuePointer
                        size:(GLint)size type:(GLenum)type andStride:(GLsizei)stride
NS_DESIGNATED_INITIALIZER;

/// Name of the attribute.
@property (readonly, nonatomic) const char *name;

/// Pointer to the attribute value array.
@property (readonly, nonatomic) const GLvoid *valuePointer;

/// Size of each attribute entry.
@property (readonly, nonatomic) GLint size;

/// Type of each attribute entry's coordinates.
@property (readonly, nonatomic) GLenum type;

/// Distance between attribute entries.
@property (readonly, nonatomic) GLsizei stride;

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
