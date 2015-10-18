// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform1i.h"
#import "TMGLProgramUniformMatrix4f.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLProgramAttribute.h"
#import "TMGLGeometry.h"

static NSString * const kModelViewProjectionMatrixUniform = @"MVP";
static NSString * const kInternalProgramTextureCoordinatesAttribute = @"texCoords";
static NSString * const kInternalProgramPositionAttribute = @"position";
static NSString * const kInternalProgramTextureSamplerUniform = @"texture";
static NSString * const kInternalProgramShaderName = @"TMGLIdentityProgram";

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramParametersBuilder()

/// Array of passed attributes.
@property (nonatomic, strong) NSMutableArray *attributes;

/// Array of passed uniforms.
@property (nonatomic, strong) NSMutableArray *uniforms;

/// Name of the Vertex Shader file
@property (nonatomic, strong) NSString *vertexShaderName;

/// Name of the Fragment Shader file
@property (nonatomic, strong) NSString *fragmentShaderName;

/// Chosen drawing method.
@property (nonatomic) GLenum drawingMethod;

/// Count of vertices to be drawn according to this program parameters.
@property (nonatomic) NSInteger vertexCount;

@end

@implementation TMGLProgramParametersBuilder

- (instancetype)init {
  if (self = [super init]) {
    self.attributes = [[NSMutableArray alloc] init];
    self.uniforms = [[NSMutableArray alloc] init];
    self.vertexShaderName = @"";
    self.fragmentShaderName = @"";
    self.drawingMethod = GL_TRIANGLES;
  }
  return self;
}

- (TMGLProgramParametersBuilder *)addAttribute:(NSString *)name
                                  valuePointer:(const GLvoid *)valuePointer size:(GLint)size
                                          type:(GLenum)type andStride:(GLsizei)stride {
  TMGLProgramAttribute *attr = [[TMGLProgramAttribute alloc]
                                initWithName:[name cStringUsingEncoding:NSUTF8StringEncoding]
                                valuePointer:valuePointer size:size type:type andStride:stride];
  
  for (TMGLProgramAttribute *existingAttribute in self.attributes) {
    if (!strcmp([existingAttribute name], [attr name])) {
      [self.attributes removeObject:existingAttribute];
    }
  }
  
  [self.attributes addObject:attr];
  return self;
}

- (TMGLProgramParametersBuilder *)addUniform:(NSString *)name
                                valuePointer:(const GLvoid *)valuePointer
                                     andType:(TMGLUniformType)type {
  id<TMGLProgramUniform> uniform;
  switch (type) {
    case TMGLUniformInt:
      uniform = [[TMGLProgramUniform1i alloc] initWithName:name andValue:*(GLint *)valuePointer];
      break;
    case TMGLUniformFloatMatrix4:
      uniform = [[TMGLProgramUniformMatrix4f alloc] initWithName:name
                                                 andValuePointer:(GLfloat *)valuePointer];
      break;
    default:
      break;
  }
  
  if (uniform) {
    for (id<TMGLProgramUniform> existingUniform in self.uniforms) {
      if ([[existingUniform name] isEqualToString:[uniform name]]) {
        [self.uniforms removeObject:existingUniform];
      }
    }
    [self.uniforms addObject:uniform];
  }
  
  return self;
}

- (TMGLProgramParametersBuilder *)setVertexShader:(NSString *)name {
  self.vertexShaderName = name;
  return self;
}

- (TMGLProgramParametersBuilder *)setFragmentShader:(NSString *)name {
  self.fragmentShaderName = name;
  return self;
}

- (TMGLProgramParametersBuilder *)setDrawingMethod:(GLenum)method andVertexCount:(NSUInteger)count {
  self.drawingMethod = (method == GL_TRIANGLES || method == GL_TRIANGLE_STRIP ||
                        method == GL_TRIANGLE_FAN) ? method : GL_TRIANGLES;
  self.vertexCount = count;
  return self;
}


- (TMGLProgramParameters *)build {
  return [[TMGLProgramParameters alloc] initWithVertexShaderName:self.vertexShaderName
                                              FragmentShaderName:self.fragmentShaderName
                                                      attributes:[self.attributes copy]
                                                        unifroms:[self.uniforms copy]
                                                   drawingMethod:self.drawingMethod
                                                  andVertexCount:(GLint)self.vertexCount];
}


#pragma mark -
#pragma mark Identity program parameters
#pragma mark -

+ (TMGLProgramParameters *)identityProgramParameters {
  TMGLProgramParametersBuilder *builder = [[TMGLProgramParametersBuilder alloc] init];
  GLint textureValue = 0;
  GLKMatrix4 MVP = GLKMatrix4MakeScale(1, -1, 1);
  
  [[[[[[[builder
         addAttribute:kInternalProgramTextureCoordinatesAttribute
         valuePointer:[TMGLGeometry quadTextureCoordinates]
         size:[TMGLGeometry quadTextureCoordinatesSize]
         type:[TMGLGeometry quadTextureCoordinatesType]
         andStride:[TMGLGeometry quadTextureCoordinatesStride]]
        addAttribute:kInternalProgramPositionAttribute valuePointer:[TMGLGeometry quadPositions]
        size:[TMGLGeometry quadPositionsSize] type:[TMGLGeometry quadPositionsType]
        andStride:[TMGLGeometry quadPositionsStride]]
       addUniform:kInternalProgramTextureSamplerUniform valuePointer:&textureValue
       andType:TMGLUniformInt]
      addUniform:kModelViewProjectionMatrixUniform valuePointer:&MVP
      andType:TMGLUniformFloatMatrix4]
     setVertexShader:kInternalProgramShaderName]
    setFragmentShader:kInternalProgramShaderName]
   setDrawingMethod:GL_TRIANGLE_STRIP andVertexCount:4];
  
  return [builder build];
}

@end

NS_ASSUME_NONNULL_END
