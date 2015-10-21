// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

@class TMGLProgramParameters, TMGLProgram;

NS_ASSUME_NONNULL_BEGIN

/// Protocol for Factory class used to compile an opengl program with the contents of a
/// \c TMGLProgramParameters object.
@protocol TMGLProgramCompiler <NSObject>

/// Compiles an opengl program from a given set of parametes wrapped in a \c TMGLProgramParameters
/// object and returns an opengl handle to it or 0 if unsuccessful
- (TMGLProgram *)createProgramFromProgramParams:(TMGLProgramParameters *)programParams;

@end

NS_ASSUME_NONNULL_END
