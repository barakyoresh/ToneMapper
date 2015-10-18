// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLDrawer.h"

NS_ASSUME_NONNULL_BEGIN

static const float kRed = 0.30f, kGreen = 0.30f, kBlue = 0.30f, kAlpha = 1.0f;

@interface TMGLDrawer()

/// \c TMGLProgramCompiler to compile with when drawing.
@property (nonatomic, strong) id<TMGLProgramCompiler> programCompiler;

@end

@implementation TMGLDrawer

- (instancetype)initWithProgramCompiler:(id<TMGLProgramCompiler>)programCompiler {
  if (self = [super init]) {
    _programCompiler = programCompiler;
  }
  return self;
}

- (void)drawTexture:(TMGLTexture *)texture toFrameBuffer:(id<TMGLBuffer>)frameBuffer
WithProgramParameters:(TMGLProgramParameters *)parameters {
  glViewport(0, 0, texture.size.width, texture.size.height);
  
  [frameBuffer bind];
  
  glClearColor(kRed, kGreen, kBlue, kAlpha);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  if (!parameters) {
    return;
  }
  
  GLuint program =
  [self.programCompiler createProgramFromProgramParams:parameters];
  glUseProgram(program);
  
  [texture bind];
  
  for (id<TMGLProgramUniform> uniform in parameters.uniforms) {
    [uniform sendUnifrom:program];
  }
  
  if (texture) {
    glDrawArrays(parameters.drawingMethod, 0, parameters.vertexCount);
  }
}

@end

NS_ASSUME_NONNULL_END
