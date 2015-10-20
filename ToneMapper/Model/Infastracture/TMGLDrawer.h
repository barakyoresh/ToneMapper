// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import "TMGLBuffer.h"
#import "TMGLTexture.h"
#import "TMGLProgramCompiler.h"

NS_ASSUME_NONNULL_BEGIN

/// Basic draw cycle building block - a single draw cycle, with every call to the \c draw method,
/// this \c TMGLRenderer draws \c inputBuffer to \c outputFrameBuffer using used
/// \c TMGLProgramParameters or a basic runthrough if no such program was supplied.
@interface TMGLDrawer : NSObject

/// Initializer method for \c TMGLRenderer object, with \c compiler as it's internal program
/// compiler.
- (instancetype)initWithProgramCompiler:(id<TMGLProgramCompiler>)programCompiler
    NS_DESIGNATED_INITIALIZER;

/// Draws \c texture to \c outputFrameBuffer using compiled \c parameters compiled with
/// \c compiler.
- (void)drawTexture:(TMGLTexture *)texture toFrameBuffer:(id<TMGLBuffer>)frameBuffer
WithProgramParameters:(TMGLProgramParameters *)parameters;

@end

NS_ASSUME_NONNULL_END
