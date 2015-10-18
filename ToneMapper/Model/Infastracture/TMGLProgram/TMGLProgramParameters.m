// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"
#import "TMGLProgramAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramParameters()

/// Name of a vertex shader file with \c .vsh extension.
@property (nonatomic, strong, readwrite) NSString *vertexShaderName;

/// Name of a fragment shader file with \c .fsh extension.
@property (nonatomic, strong, readwrite) NSString *fragmentShaderName;

/// Array of \c TMGLProgramAttribute objects.
@property (nonatomic, strong, readwrite) NSArray *attributes;

/// Array of objects conforming to the \c <TMGLProgramUnifrom> protocol.
@property (nonatomic, strong, readwrite) NSArray *uniforms;

/// Drawing method to be used when drawing using \c glDrawArrays method. must be one of
/// \c GL_TRIANGLES, \c GL_TRIANGLE_STRIP, \c GL_TRIANGLE_FAN or \c GL_TRIANGLE_ARRAY
@property (nonatomic, readwrite) GLenum drawingMethod;

/// Ammount of vertecies to be drawn when using \c glDrawArrays method.
@property (nonatomic, readwrite) GLuint vertexCount;

@end

@implementation TMGLProgramParameters

- (instancetype)initWithVertexShaderName:(NSString *)vertexShaderName
                      FragmentShaderName:(NSString *)fragmentShaderName
                              attributes:(NSArray *)attributes unifroms:(NSArray *)uniforms
                           drawingMethod:(GLenum)drawingMethod andVertexCount:(GLuint)vertexCount {
  if (self = [super init]) {
    _vertexShaderName = vertexShaderName;
    _fragmentShaderName = fragmentShaderName;
    _attributes = attributes;
    _uniforms = uniforms;
    _drawingMethod = drawingMethod;
    _vertexCount = vertexCount;
  }
  return self;
}

- (TMGLProgramParameters *)parametersWithReplacedUniforms:(NSArray *)uniforms {
  return [[TMGLProgramParameters alloc] initWithVertexShaderName:self.vertexShaderName
                                              FragmentShaderName:self.fragmentShaderName
                                                      attributes:self.attributes unifroms:uniforms
                                                   drawingMethod:self.drawingMethod
                                                  andVertexCount:self.vertexCount];
}

- (TMGLProgramParameters *)parametersWithReplacedUniform:(id<TMGLProgramUniform>)uniform {
  NSMutableArray *uniforms = [self.uniforms mutableCopy];
  for (id<TMGLProgramUniform> existingUniform in self.uniforms) {
    if ([[uniform name] isEqualToString:[existingUniform name]]) {
      [uniforms removeObject:existingUniform];
      [uniforms addObject:uniform];
    }
  }
  return [self parametersWithReplacedUniforms:[uniforms copy]];
}

@end

NS_ASSUME_NONNULL_END
