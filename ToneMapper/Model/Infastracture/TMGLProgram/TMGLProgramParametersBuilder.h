// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>

@class TMGLProgramParameters;

NS_ASSUME_NONNULL_BEGIN

/// Factory for \c TMGLProgramParameters using the Builder design pattern.
@interface TMGLProgramParametersBuilder : NSObject

/// Types of unifroms that can be added as program parameters.
typedef NS_ENUM(NSInteger, TMGLUniformType) {
  TMGLUniformInt,
  TMGLUniformFloat,
  TMGLUniformFloat2,
  TMGLUniformFloatMatrix4
};

/// Add an attribute to the program parameters. the attribute's name \c name must correlate to the
/// name used in the matching shader. \c valuePointer must be set to an array of type \c type.
/// \c size specifies the size of each element in the array, and \c stride indicates the distance
/// between each following value.
- (TMGLProgramParametersBuilder *)addAttribute:(NSString *)name
                                  valuePointer:(const GLvoid *)valuePointer size:(GLint)size
                                          type:(GLenum)type andStride:(GLsizei)stride;

/// Add a uniform to the program parameters. the uniform's name \c must correlate to the name used
/// in the matching shader. \c valuePointer must be set to a pointer to the correct type of value
/// as in \c type.
- (TMGLProgramParametersBuilder *)addUniform:(NSString *)name
                                valuePointer:(const GLvoid *)valuePointer
                                     andType:(TMGLUniformType)type;

/// Sets the vertex shader of the program parameters, \c name must match the shader's file name and
/// the shader's extension must be \c .vsh
- (TMGLProgramParametersBuilder *)setVertexShader:(NSString *)name;

/// Sets the fragment shader of the program parameters, \c name must match the shader's file name and
/// the shader's extension must be \c .fsh
- (TMGLProgramParametersBuilder *)setFragmentShader:(NSString *)name;

/// Sets the drawing method and vertex count of the program parameters. The vertex count \c count
/// must match the number of vertices used in the program's attributes.
/// \c method must be one of \c GL_TRIANGLES, \c GL_TRIANGLE_STRIP or \c GL_TRIANGLE_FAN. if an
/// invalid method is passed, the drawing method will be set to GL_TRIANGLES.
- (TMGLProgramParametersBuilder *)setDrawingMethod:(GLenum)method andVertexCount:(NSUInteger)count;

/// Create and return the \c TMGLProgramParameters matching this builder's internal attributes.
- (TMGLProgramParameters *)build;

+ (TMGLProgramParameters *)identityProgramParameters;

@end

NS_ASSUME_NONNULL_END
