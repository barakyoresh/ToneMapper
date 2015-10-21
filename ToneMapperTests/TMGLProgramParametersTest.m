// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"
#import "TMGLProgramUniform.h"

@import Quick;
@import Nimble;

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

QuickSpecBegin(ProgramParametersSpec)

describe(@"Program Parameters", ^{
  __block TMGLProgramParameters *programParameters;
  __block NSArray *attributes;
  __block NSArray *uniforms;
  __block id<TMGLProgramUniform> uniform;
  
  beforeEach(^{
    attributes = [[NSArray alloc] init];
    uniform = MKTMockProtocol(@protocol(TMGLProgramUniform));
    [MKTGiven([uniform name]) willReturn:@"unif1"];
    uniforms = @[uniform];
    programParameters = [[TMGLProgramParameters alloc] initWithVertexShaderName:@"vShader"
                                                             fragmentShaderName:@"fShader"
                                                                     attributes:attributes
                                                                       unifroms:uniforms
                                                                  drawingMethod:GL_TRIANGLES
                                                                 andVertexCount:1];
  });
  
  
  context(@"parameters", ^{
    
    it(@"Should retain its vertexShaderName value", ^{
      expect([programParameters vertexShaderName]).to(equal(@"vShader"));
    });
    
    it(@"Should retain its fragmentShaderName value", ^{
      expect([programParameters fragmentShaderName]).to(equal(@"fShader"));
    });
    
    it(@"Should retain its attributes value", ^{
      expect([programParameters attributes]).to(equal(attributes));
    });
    
    it(@"Should retain its uniforms value", ^{
      expect([((id<TMGLProgramUniform>)[[programParameters uniforms] firstObject]) name]).to(equal([((id<TMGLProgramUniform>)[uniforms firstObject]) name]));
    });
    
    it(@"Should retain its drawingMethod value", ^{
      expect(@([programParameters drawingMethod])).to(equal(@(GL_TRIANGLES)));
    });
    
    it(@"Should retain its vertexCount value", ^{
      expect(@([programParameters vertexCount])).to(equal(@(1)));
    });
    
  });
  
  context(@"methods", ^{
    
    it(@"Should be able to replace uniforms", ^{
      NSArray *uniforms2 = [[NSArray alloc] init];
      TMGLProgramParameters *programParameters2 = [programParameters parametersWithReplacedUniforms:uniforms2];
      expect([programParameters2 uniforms]).to(equal(uniforms2));
    });
    
    it(@"Should be able to replace a single uniform", ^{
      id<TMGLProgramUniform> uniform2 = MKTMockProtocol(@protocol(TMGLProgramUniform));
      [MKTGiven([uniform2 name]) willReturn:@"unif1"];
      TMGLProgramParameters *programParameters2 = [programParameters parametersWithReplacedUniform:uniform2];
      expect([[programParameters2 uniforms] firstObject]).to(equal(uniform2));
    });
    
  });

});

QuickSpecEnd
