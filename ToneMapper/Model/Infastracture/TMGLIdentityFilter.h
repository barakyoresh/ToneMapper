// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLFilter.h"
#import "TMGLProgramCompiler.h"

NS_ASSUME_NONNULL_BEGIN

/// Identity image filter, conforming to the \c TMGLProcess protocol and copying the texture as is
/// to a different texture object.
@interface TMGLIdentityFilter : NSObject <TMGLFilter>

/// Initializer method for \c TMGLIdentityFilter object, with \c compiler as its internal program
/// compiler.
- (instancetype)initWithProgramCompiler:(id<TMGLProgramCompiler>)programCompiler
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
