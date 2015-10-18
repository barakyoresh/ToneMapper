// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

@import Quick;
@import Nimble;

#import "TMGLDefaultShaderCompiler.h"
#import <OpenGLES/ES2/gl.h>

QuickSpecBegin(DefaultShaderCompilerSpec)

describe(@"a default shader compiler", ^{
  TMGLDefaultShaderCompiler *shaderCompiler = [[TMGLDefaultShaderCompiler alloc] init];
  
  it(@"should return 0 for illeagle shader types", ^{
    expect(@([shaderCompiler createShaderType:GL_ZERO
                                       FromPath:@"non_existing_path"
                                   withFileType:@"vsh"])).to(equal(@0));
  });
  
  it(@"should return non-zero for leagle shader types", ^{
    expect(@([shaderCompiler createShaderType:GL_VERTEX_SHADER
                                       FromPath:@"TMGLEngine"
                                   withFileType:@"vsh"])).toNot(equal(@0));
  });
  
  it(@"should return 0 for bad file paths", ^{
    expect(@([shaderCompiler createShaderType:GL_VERTEX_SHADER
                               FromPath:@"non_existing_path"
                           withFileType:@"vsh"])).to(equal(@0));
  });
  
  it(@"should return non-zero for good file paths", ^{
    expect(@([shaderCompiler createShaderType:GL_VERTEX_SHADER
                                       FromPath:@"TMGLEngine"
                                   withFileType:@"vsh"])).toNot(equal(@0));
  });
  
  
  it(@"should return 0 for bad file path extensions", ^{
    expect(@([shaderCompiler createShaderType:GL_VERTEX_SHADER
                                       FromPath:@"non_existing_path"
                                   withFileType:@"exe"])).to(equal(@0));
  });
  
  it(@"should return non-zero for good file path extensions", ^{
    expect(@([shaderCompiler createShaderType:GL_VERTEX_SHADER
                                       FromPath:@"TMGLEngine"
                                   withFileType:@"vsh"])).toNot(equal(@0));
  });
  
  it(@"should return 0 for bad file path extension and type combinations", ^{
    expect(@([shaderCompiler createShaderType:GL_VERTEX_SHADER
                                       FromPath:@"TMGLEngine"
                                   withFileType:@"fsh"])).to(equal(@0));
  });

});

QuickSpecEnd
