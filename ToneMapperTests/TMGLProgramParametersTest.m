// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"

@import Quick;
@import Nimble;

//#define HC_SHORTHAND
//#import <OCHamcrest/OCHamcrest.h>
//
//#define MOCKITO_SHORTHAND
//#import <OCMockito/OCMockito.h>

QuickSpecBegin(ProgramParametersSpec)

describe(@"Program Parameters", ^{
  NSArray *attributes = [[NSArray alloc] init];
  //id<TMGLProgramUniform> uniform = MKTMockProtocol(@protocol(TMGLProgramUniform));
  //[MKTGiven([uniform name]) willReturn:@"uinf1"];
  NSArray *uniforms = [[NSArray alloc] init];
  //NSLog(@"uniform: %@", uniform);

  TMGLProgramParameters *programParameters =
  [[TMGLProgramParameters alloc] initWithVertexShaderName:@"vShader" fragmentShaderName:@"fShader"
                                               attributes:attributes unifroms:uniforms
                                            drawingMethod:GL_TRIANGLES andVertexCount:1];
  
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
      expect([programParameters uniforms]).to(equal(uniforms));
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
//      id<TMGLProgramUniform> unifrom2 = MKTMockProtocol(@protocol(TMGLProgramUniform));
//      [MKTGiven([uniform name]) willReturn:@"uinf1"];
//      TMGLProgramParameters *programParameters2 = [programParameters parametersWithReplacedUniform:unifrom2];
//      expect([[programParameters2 uniforms] firstObject]).to(equal(unifrom2));
    });
    
  });

});

QuickSpecEnd