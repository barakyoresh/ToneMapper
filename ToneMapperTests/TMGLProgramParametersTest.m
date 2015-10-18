// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLProgramUniform1i.h"


@import Quick;
@import Nimble;

QuickSpecBegin(ProgramParametersSpec)

describe(@"A TMGLProgramParameters object", ^{
  __block TMGLProgramParameters *programParameters;
  
  beforeEach(^{
    TMGLProgramParametersBuilder *builder = [[TMGLProgramParametersBuilder alloc] init];
    GLint unif1 = 1, unif2 = 2;
    [[[[[[[builder setVertexShader:@"vShader"]
          setFragmentShader:@"fShader"]
         addAttribute:@"attr1" valuePointer:(void *)1 size:1 type:GL_FLOAT andStride:1]
        addAttribute:@"attr2" valuePointer:(void *)2 size:1 type:GL_FLOAT andStride:1]
       addUniform:@"unif1" valuePointer:&unif1 andType:TMGLUniformInt]
      addUniform:@"unif2" valuePointer:&unif2 andType:TMGLUniformInt]
     setDrawingMethod:GL_TRIANGLE_STRIP andVertexCount:1];
    
    programParameters = [builder build];
  });
  
  context(@"Replacing a single unfiorms", ^{
    
    beforeEach(^{
      TMGLProgramUniform1i *unif2 = [[TMGLProgramUniform1i alloc] initWithName:@"unif2" andValue:3];
      programParameters = [programParameters parametersWithReplacedUniform:unif2];
    });
    
    it(@"Should leave untouched uniforms as they were", ^{
      for (id <TMGLProgramUniform> unif in programParameters.uniforms) {
        if ([[unif name] isEqualToString:@"unif1"]) {
          // somehow check its still valued 1
        }
      }
    });
  });

  
  
});

QuickSpecEnd
