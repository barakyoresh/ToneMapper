// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <OpenGLES/ES2/gl.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Value class containing necessary information for an opengl attribute.
@interface TMGLProgramAttribute : NSObject

/// Name of the attribute.
@property (nonatomic, readonly) const char *name;

/// Pointer to the attribute value array.
@property (nonatomic, readonly) const GLvoid *valuePointer;

/// Size of each attribute entry.
@property (nonatomic, readonly) GLint size;

/// Type of each attribute entry's coordinates.
@property (nonatomic, readonly) GLenum type;

/// Distance between attribute entries.
@property (nonatomic, readonly) GLsizei stride;

/// Initializes \c TMGLProgramAttribute with \c name, \c valuePointer, \c size, \c type and
/// \c stride.
- (instancetype)initWithName:(const char*)name valuePointer:(const GLvoid *)valuePointer
                        size:(GLint)size type:(GLenum)type andStride:(GLsizei)stride;

@end

NS_ASSUME_NONNULL_END
