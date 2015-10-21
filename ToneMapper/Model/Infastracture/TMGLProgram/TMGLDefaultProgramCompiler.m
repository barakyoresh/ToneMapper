// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <OpenGLES/ES2/gl.h>

#import "TMGLDefaultShaderCompiler.h"
#import "TMGLDefaultProgramCompiler.h"
#import "TMGLProgramAttribute.h"
#import "TMGLProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLDefaultProgramCompiler()

/// Dependancy injected \c TMGLShaderCompiler object to compile passed in shaders in
/// subsequent \c TMGLProgramParameters
@property (strong, readonly, nonatomic) id<TMGLShaderCompiler> shaderCompiler;

@end

@implementation TMGLDefaultProgramCompiler

static NSString * const kVertexShaderFileExtension = @"vsh";
static NSString * const kFragmentShaderFileExtension = @"fsh";

- (instancetype)initWithShaderCompiler:(id<TMGLShaderCompiler> __nonnull)shaderCompiler {
  if (!shaderCompiler) {
    return nil;
  }
  if (self = [super init]) {
    _shaderCompiler = shaderCompiler;
  }
  return self;
}

- (TMGLProgram *)createProgramFromProgramParams:(TMGLProgramParameters *)programParams {
  GLuint vertexShader = [self.shaderCompiler createShaderType:GL_VERTEX_SHADER
                                                     fromPath:[programParams vertexShaderName]
                                                 withFileType:kVertexShaderFileExtension];
  GLuint fragmentShader = [self.shaderCompiler createShaderType:GL_FRAGMENT_SHADER
                                                       fromPath:[programParams fragmentShaderName]
                                                   withFileType:kFragmentShaderFileExtension];
  
  if (vertexShader == 0 || fragmentShader == 0) {
    return 0;
  }
  
  GLuint program = [self createProgramWithShaders:@[@(fragmentShader), @(vertexShader)]];
  
  for (TMGLProgramAttribute *attr in [programParams attributes]) {
    int attributeLocation = glGetAttribLocation(program, attr.name);
    glEnableVertexAttribArray(attributeLocation);
    glVertexAttribPointer(attributeLocation, attr.size, attr.type, FALSE, attr.stride,
                          attr.valuePointer);
  }
  
  return [[TMGLProgram alloc] initWithHandle:program];
}

- (GLuint)createProgramWithShaders:(NSArray *)shaders {
  GLuint program = glCreateProgram();
  
  [self attachShaders:shaders toProgram:program];
  [self linkProgram:program];
  [self deleteShaders:shaders];
  
  return program;
}

- (void)attachShaders:(NSArray *)shaders toProgram:(GLuint)program {
  for (id shader in shaders) {
    GLuint shaderGLPointer = (GLuint) [shader unsignedIntegerValue];
    glAttachShader(program, shaderGLPointer);
  }
}

- (void)linkProgram:(GLuint)program {
  glLinkProgram(program);
  GLint status;
  glGetProgramiv(program, GL_LINK_STATUS, &status);
  if (status == 0) {
    NSLog(@"program link failure");
    [self printProgramCompilationInfoLog:program];
  }
}

- (void)deleteShaders:(NSArray * __nonnull)shaders {
  for (id shader in shaders) {
    GLuint shaderGLPointer = (GLuint) [shader unsignedIntegerValue];
    glDeleteShader(shaderGLPointer);
  }
}

- (void)printProgramCompilationInfoLog:(GLuint)program {
  GLint logLength;
  
  glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
  
  GLchar *infoLog = (GLchar *) malloc(logLength);
  glGetProgramInfoLog(program, logLength, NULL, infoLog);
  
  NSLog(@"program info log for shader %d: %@", program, [NSString stringWithUTF8String:infoLog]);
  
  free(infoLog);
}

@end

NS_ASSUME_NONNULL_END
