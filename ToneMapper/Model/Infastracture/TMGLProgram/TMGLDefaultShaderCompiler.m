// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLDefaultShaderCompiler.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMGLDefaultShaderCompiler

- (GLuint)createShaderType:(GLenum)shaderType fromPath:(NSString *)path
              withFileType:(NSString *)fileType {
  NSString *shaderPathName = [[NSBundle mainBundle] pathForResource:path ofType:fileType];
  GLuint shader = glCreateShader(shaderType);
  
  const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:shaderPathName
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil] UTF8String];
  if (!source)
  {
    NSLog(@"shader source file error");
    return 0;
  }
  
  GLint sourceLen = (GLint) strlen(source);
  glShaderSource(shader, 1, &source, &sourceLen);
  glCompileShader(shader);
  
  if (![self compiledSuccessfully:shader]) {
    [self printShaderCompilationInfoLog:shader];
    glDeleteShader(shader);
    return 0;
  }
  
  return shader;
}

- (BOOL)compiledSuccessfully:(GLuint)shader {
  GLint compileSuccessful;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccessful);
  return (compileSuccessful == GL_TRUE);
}

- (void)printShaderCompilationInfoLog:(GLuint)shader {
  GLint logLength;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
  GLchar *infoLog = (GLchar *) malloc(logLength);
  glGetShaderInfoLog(shader, logLength, NULL, infoLog);
  
  NSLog(@"shader info log for shader %d: %@", shader, [NSString stringWithUTF8String:infoLog]);
  
  free(infoLog);
}

@end

NS_ASSUME_NONNULL_END
