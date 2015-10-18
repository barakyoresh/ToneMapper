// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLCachedProgramCompiler.h"
#import "TMGLDefaultShaderCompiler.h"
#import "TMGLProgramParametersBuilder.h"

@import Quick;
@import Nimble;

QuickSpecBegin(CachedProgramCompilerSpec)

describe(@"A Cached Program Compiler", ^{
  TMGLCachedProgramCompiler *programCompiler =
    [[TMGLCachedProgramCompiler alloc] initWithShaderCompiler:[[TMGLDefaultShaderCompiler alloc]
                                                               init]];
  __block TMGLProgramParametersBuilder *builder;
  __block TMGLProgramParameters *params;
  __block GLuint program1;
  
  beforeEach(^{
    GLuint unif = 1;
    builder = [[TMGLProgramParametersBuilder alloc] init];
    [[[[[[[builder
           addAttribute:@"attr1" valuePointer:(GLvoid *)1 size:1 type:GL_FLOAT andStride:1]
          addAttribute:@"attr2" valuePointer:(GLvoid *)1 size:1 type:GL_FLOAT andStride:1]
         addUniform:@"unif1" valuePointer:&unif andType:TMGLUniformInt]
        addUniform:@"unif2" valuePointer:&unif andType:TMGLUniformInt]
       setVertexShader:@"TMGLIdentityProgram"]
      setFragmentShader:@"TMGLIdentityProgram"]
     setDrawingMethod:GL_TRIANGLE_STRIP andVertexCount:4];
    params = [builder build];
    program1 = [programCompiler createProgramFromProgramParams:params];
  });
  
  it(@"Return the same handle for the same program parameters", ^{
    GLuint program2 = [programCompiler createProgramFromProgramParams:params];
    expect(@(program1)).to(equal(@(program2)));
  });
  
  it(@"Return the same handle for the same program parameters with an altered uniforms", ^{
    GLuint program1 = [programCompiler createProgramFromProgramParams:params];
    params = [params parametersWithReplacedUniforms:[[NSArray alloc] init]];
    GLuint program2 = [programCompiler createProgramFromProgramParams:params];
    expect(@(program1)).to(equal(@(program2)));
  });
  
  it(@"Return the same handle for the same program parameters with an altered drawing method", ^{
    GLuint program1 = [programCompiler createProgramFromProgramParams:params];
    [builder setDrawingMethod:GL_TRIANGLE_FAN andVertexCount:1];
    params = [builder build];
    GLuint program2 = [programCompiler createProgramFromProgramParams:params];
    expect(@(program1)).to(equal(@(program2)));
  });
  
  it(@"Return a different handle for the same program parameters with altered attributes", ^{
    GLuint program1 = [programCompiler createProgramFromProgramParams:params];
    [builder addAttribute:@"attr3" valuePointer:(GLuint *)1 size:1 type:GL_FLOAT andStride:1];
    params = [builder build];
    GLuint program2 = [programCompiler createProgramFromProgramParams:params];
    expect(@(program1)).toNot(equal(@(program2)));
  });
  
});

QuickSpecEnd