// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform.h"

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

/// A single 4-by-4 float matrix uniform variable to an opengl program, conforming to the
/// \c <TMGLProgramUnifrom> protocol.
@interface TMGLProgramUniformMatrix4f : NSObject <TMGLProgramUniform>

/// Initializer of this uniform varible with \c name as its name and \c value as a pointer to a
/// 4-by-4 float matrix.
/// This copies the data stored in \c valuePointer so it can be released after initializing this.
- (instancetype)initWithName:(NSString *)name andValuePointer:(GLfloat *)valuePointer
NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
