// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import "TMGLProgramCompiler.h"
#import "TMGLShaderCompiler.h"

NS_ASSUME_NONNULL_BEGIN

/// A program compiler with internal cahcing for performance enhancement. When a set of
/// \c TMGLProgramParameters is passed that was already compiled and can be reused it will be.
@interface TMGLCachedProgramCompiler : NSObject <TMGLProgramCompiler>

/// Designated intializer with \c TMGLShaderCompiler object injected via \c shaderCompiler
/// parameter.
- (instancetype)initWithShaderCompiler:(id <TMGLShaderCompiler>)shaderCompiler
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
