// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

#import "TMGLShaderCompiler.h"

NS_ASSUME_NONNULL_BEGIN

/// Factory class used to compile opengl shader objects given a specific type, file extension and
/// path.
@interface TMGLDefaultShaderCompiler : NSObject <TMGLShaderCompiler>

@end

NS_ASSUME_NONNULL_END
