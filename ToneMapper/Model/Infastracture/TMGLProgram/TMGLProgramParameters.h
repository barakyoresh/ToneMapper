// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>

@class TMGLProgramParameters;
@protocol TMGLProgramUniform;

NS_ASSUME_NONNULL_BEGIN

/// Value class containing all necessary parameters for the compilation of an opengl program.
@interface TMGLProgramParameters : NSObject <NSCopying>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initialize \c TMGLProgramParameters with \c vertexShaderName, \c fragmentShaderName,
/// \c attributes, \c uniforms, \c drawingMethod and \c vertexCount.
- (instancetype)initWithVertexShaderName:(NSString *)vertexShaderName
                      fragmentShaderName:(NSString *)fragmentShaderName
                              attributes:(NSArray *)attributes unifroms:(NSArray *)uniforms
                           drawingMethod:(GLenum)drawingMethod andVertexCount:(GLuint)vertexCount
NS_DESIGNATED_INITIALIZER;

/// Returns a copy of this with its uniforms replaced with \c uniforms.
- (TMGLProgramParameters *)parametersWithReplacedUniforms:(NSArray *)uniforms;

/// Returns a copy of this with a uniform matching \c uniform's \c name replaced by \c uniform.
- (TMGLProgramParameters *)parametersWithReplacedUniform:(id<TMGLProgramUniform>)uniform;

/// Name of a vertex shader file with \c .vsh extension.
@property (strong, readonly, nonatomic) NSString *vertexShaderName;

/// Name of a fragment shader file with \c .fsh extension.
@property (strong, readonly, nonatomic) NSString *fragmentShaderName;

/// Array of \c TMGLProgramAttribute objects.
@property (strong, readonly, nonatomic) NSArray *attributes;

/// Array of objects conforming to the \c <TMGLProgramUnifrom> protocol.
@property (strong, readonly, nonatomic) NSArray *uniforms;

/// Drawing method to be used when drawing using \c glDrawArrays method. must be one of
/// \c GL_TRIANGLES, \c GL_TRIANGLE_STRIP or \c GL_TRIANGLE_FAN.
@property (readonly, nonatomic) GLenum drawingMethod;

/// Ammount of vertecies to be drawn when using \c glDrawArrays method.
@property (readonly, nonatomic) GLuint vertexCount;

@end

NS_ASSUME_NONNULL_END
