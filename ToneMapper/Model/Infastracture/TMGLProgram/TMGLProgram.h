// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>

@protocol TMGLProgramUniform;

NS_ASSUME_NONNULL_BEGIN

/// Wrapper to an opengl program handle, enabling encapsulated usage. A \c TMGLProgram should be
/// compiled by a \c TMGLProgramCompiler and not created by itself.
/// Also manages memory managment and dealloc's the program in the opengl enviorment when no
/// references to this object remain.
@interface TMGLProgram : NSObject

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer with a compiled open gl \c handle.
- (instancetype)initWithHandle:(GLuint)handle NS_DESIGNATED_INITIALIZER;

/// Uses this program, setting it to the currently used program in the opengl enviorment.
- (void)use;

/// Sends \c unifrom to the currently used program with at the location of \c uniform in this
/// program.
- (void)sendUniform:(id<TMGLProgramUniform>)uniform;

@end

NS_ASSUME_NONNULL_END
