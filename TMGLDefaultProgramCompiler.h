// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"

#import <OpenGLES/ES2/gl.h>
#import <Foundation/Foundation.h>

#import "TMGLProgramCompiler.h"
#import "TMGLShaderCompiler.h"

NS_ASSUME_NONNULL_BEGIN

/// Factory class used to compile an opengl program with the contents of a \c TMGLProgramParameters
/// object.
@interface TMGLDefaultProgramCompiler : NSObject <TMGLProgramCompiler>

/// Designated intializer with \c TMGLShaderCompiler object injected via \c shaderCompiler
/// parameter.
- (instancetype)initWithShaderCompiler:(id <TMGLShaderCompiler>)shaderCompiler
NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
