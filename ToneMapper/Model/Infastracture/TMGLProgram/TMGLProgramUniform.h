// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>

@class TMGLProgram;

NS_ASSUME_NONNULL_BEGIN

/// Protocol that all opengl uniforms must conform to.
@protocol TMGLProgramUniform <NSObject>

/// Sends this uniform to \c program using the appropriate \c glUniform method.
- (void)sendUnifrom:(TMGLProgram *)program;

/// This uniform's name, matching the name in the shader file.
- (NSString *)name;

@end

NS_ASSUME_NONNULL_END
