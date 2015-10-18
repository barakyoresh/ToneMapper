// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.


#import "TMGLProgramParametersBuilder.h"

@import Quick;
@import Nimble;

QuickSpecBegin(ProgramParametersBuilderSpec)

describe(@"A Program parameters builder", ^{
  __block TMGLProgramParametersBuilder *builder;
  __block TMGLProgramParameters *params;
  
  beforeEach(^{
    builder = [[TMGLProgramParametersBuilder alloc] init];
    params = nil;
  });
  
  context(@"Attributes", ^{
    
    it(@"Should be able to add an attribute", ^{
      GLfloat attrib[] = {1};
      [builder addAttribute:@"attr" valuePointer:attrib size:1 type:GL_FLOAT andStride:1];
      params = [builder build];
      expect(@((int)[[params.attributes firstObject] valuePointer])).to(equal(@((int)attrib)));
    });
    
    it(@"Should be able to add an several attributes", ^{
      GLfloat attrib[] = {1};
      [builder addAttribute:@"attr1" valuePointer:attrib size:1 type:GL_FLOAT andStride:1];
      [builder addAttribute:@"attr2" valuePointer:attrib size:1 type:GL_FLOAT andStride:1];
      params = [builder build];
      expect(@([params.attributes count])).to(equal(@2));
    });
    
    it(@"Shouldn't be able to add an several attributes with the same name", ^{
      GLfloat attrib[] = {1};
      [builder addAttribute:@"attr" valuePointer:attrib size:1 type:GL_FLOAT andStride:1];
      [builder addAttribute:@"attr" valuePointer:attrib size:1 type:GL_FLOAT andStride:1];
      params = [builder build];
      expect(@([params.attributes count])).to(equal(@1));
    });
    
  });
  
  context(@"Unifroms", ^{
    GLfloat unif = 1;
    
    it(@"Should be able to add a uniform", ^{
      [builder addUniform:@"unif" valuePointer:&unif andType:TMGLUniformInt];
      params = [builder build];
      expect(@([params.uniforms count])).to(equal(@1));
    });
    
    it(@"Shouldn't be able to add an invalid uniform type", ^{
      [builder addUniform:@"unif" valuePointer:&unif andType:GL_FLOAT];
      params = [builder build];
      expect(@([params.uniforms count])).to(equal(@0));
    });
    
    it(@"Should be able to add several uniforms", ^{
      [builder addUniform:@"unif1" valuePointer:&unif andType:TMGLUniformInt];
      [builder addUniform:@"unif2" valuePointer:&unif andType:TMGLUniformInt];
      params = [builder build];
      expect(@([params.uniforms count])).to(equal(@2));
    });
    
    it(@"Shouldn't be able to add several uniforms with the same name", ^{
      [builder addUniform:@"unif" valuePointer:&unif andType:TMGLUniformInt];
      [builder addUniform:@"unif" valuePointer:&unif andType:TMGLUniformInt];
      params = [builder build];
      expect(@([params.uniforms count])).to(equal(@1));
    });

  });
  
  context(@"Shaders", ^{
    
    it(@"Should be able to set a vertex shader name", ^{
      [builder setVertexShader:@"vertex"];
      params = [builder build];
      expect(params.vertexShaderName).to(equal(@"vertex"));
    });
    
    it(@"Should be able to change a vertex shader name", ^{
      [builder setVertexShader:@"vertex"];
      [builder setVertexShader:@"vertex2"];
      params = [builder build];
      expect(params.vertexShaderName).toNot(equal(@"vertex"));
    });
    
    it(@"Should be able to set a fragment shader name", ^{
      [builder setVertexShader:@"fragment"];
      params = [builder build];
      expect(params.vertexShaderName).to(equal(@"fragment"));
    });
    
    it(@"Should be able to change a fragment shader name", ^{
      [builder setVertexShader:@"fragment"];
      [builder setVertexShader:@"fragment2"];
      params = [builder build];
      expect(params.vertexShaderName).toNot(equal(@"fragment"));
    });
    
  });
  
  context(@"Drawing Method", ^{
    
    beforeEach(^{
      [builder setDrawingMethod:GL_TRIANGLES andVertexCount:1];
      params = [builder build];
    });
    
    it(@"Should be able to set a drawing method", ^{
      expect(@(params.drawingMethod)).to(equal(@(GL_TRIANGLES)));
    });
    
    it(@"Should be able to set a vertex count", ^{
      expect(@(params.vertexCount)).to(equal(@1));
    });
    
  });
 
  
});

QuickSpecEnd