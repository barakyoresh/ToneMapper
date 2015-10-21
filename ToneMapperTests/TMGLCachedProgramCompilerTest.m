// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLCachedProgramCompiler.h"
#import "TMGLDefaultShaderCompiler.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLProgramParameters.h"
#import "TMGLProgram.h"

@import Quick;
@import Nimble;

QuickSpecBegin(CachedProgramCompilerSpec)

describe(@"A Cached Program Compiler", ^{
  TMGLCachedProgramCompiler *programCompiler =
    [[TMGLCachedProgramCompiler alloc] initWithShaderCompiler:[[TMGLDefaultShaderCompiler alloc]
                                                               init]];
  __block TMGLProgramParametersBuilder *builder;
  __block TMGLProgramParameters *params;
  __block TMGLProgram *program1;
  
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
  
  it(@"Should return the same handle for the same program parameters", ^{
    TMGLProgram *program2 = [programCompiler createProgramFromProgramParams:params];
    expect(program1).to(equal(program2));
  });
  
  it(@"Should return the same handle for the same program parameters with an altered uniforms", ^{
    TMGLProgram *program1 = [programCompiler createProgramFromProgramParams:params];
    params = [params parametersWithReplacedUniforms:[[NSArray alloc] init]];
    TMGLProgram *program2 = [programCompiler createProgramFromProgramParams:params];
    expect(program1).to(equal(program2));
  });
  
  it(@"Should return the same handle for the same program parameters with an altered drawing method", ^{
    TMGLProgram *program1 = [programCompiler createProgramFromProgramParams:params];
    [builder setDrawingMethod:GL_TRIANGLE_FAN andVertexCount:1];
    params = [builder build];
    TMGLProgram *program2 = [programCompiler createProgramFromProgramParams:params];
    expect(program1).to(equal(program2));
  });
  
  it(@"Should return a different handle for the same program parameters with altered attributes", ^{
    TMGLProgram *program1 = [programCompiler createProgramFromProgramParams:params];
    [builder addAttribute:@"attr3" valuePointer:(GLuint *)1 size:1 type:GL_FLOAT andStride:1];
    params = [builder build];
    TMGLProgram *program2 = [programCompiler createProgramFromProgramParams:params];
    expect(program1).toNot(equal(program2));
  });
  
});

QuickSpecEnd
