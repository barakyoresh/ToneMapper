// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"
#import "TMGLProgramAttribute.h"
#import "TMGLProgramUniform.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMGLProgramAttribute(CahceCompare)

/// Cached equals created to check if this \c TMGLProgramAttribute is equal as far as the cache
/// is concerned to \c other.
- (BOOL)cachedEquals:(TMGLProgramAttribute *)other {
  return (self == other);
}

@end

@implementation TMGLProgramParameters

- (instancetype)initWithVertexShaderName:(NSString *)vertexShaderName
                      fragmentShaderName:(NSString *)fragmentShaderName
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
                                              fragmentShaderName:self.fragmentShaderName
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

#pragma mark -
#pragma mark Copying
#pragma mark -

- (id)copyWithZone:(NSZone *)zone {
  return [[TMGLProgramParameters allocWithZone:zone] initWithVertexShaderName:_vertexShaderName
                                                           fragmentShaderName:_fragmentShaderName
                                                                   attributes:_attributes
                                                                     unifroms:_uniforms
                                                                drawingMethod:_drawingMethod
                                                               andVertexCount:_vertexCount];
}

#pragma mark -
#pragma mark Equality
#pragma mark -

/// Override isEqual to check only re-compile worthy changes to this \c TMGLProgramParameters.
/// This is implemented in order to make comparing \c TMGLProgramParameters will result in
/// inequality only if a corresponding compiled \c TMGLProgram will result in a different program.
- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  
  if (![object isKindOfClass:[TMGLProgramParameters class]]) {
    return NO;
  }
  
  TMGLProgramParameters *other = (TMGLProgramParameters *)object;
  
  if (![self.vertexShaderName isEqualToString:other.vertexShaderName] ||
      ![self.fragmentShaderName isEqualToString:other.fragmentShaderName] ||
      [self.attributes count] != [other.attributes count]) {
    return NO;
  }
  
  for (TMGLProgramAttribute *selfAttr in self.attributes) {
    BOOL arrayDifference = YES;
    for (TMGLProgramAttribute *otherAttr in other.attributes) {
      if ([selfAttr cachedEquals:otherAttr]) {
        arrayDifference = NO;
      }
    }
    if (arrayDifference) {
      return NO;
    }
  }
  
  return YES;
}

- (NSUInteger)hash {
  uint hash = 7;
  hash *= [self.vertexShaderName hash] * 7;
  hash *= [self.fragmentShaderName hash] * 7;
  hash *= self.drawingMethod * 7;
  hash *= self.vertexCount * 7;
  return (NSUInteger)hash;
}

@end

NS_ASSUME_NONNULL_END
