// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMShaderProvider <NSObject>

/// Supplies an allocated Vertex Shader pointer that needs to be freed by the protocol user.
- (GLuint)vertexShader;

/// Supplies an allocated Fragment Shader pointer that needs to be freed by the protocol user.
- (GLuint)fragmentShader;

@end

NS_ASSUME_NONNULL_END
