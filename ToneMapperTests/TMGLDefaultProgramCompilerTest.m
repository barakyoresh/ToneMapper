// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLDefaultProgramCompiler.h"
#import "TMGLDefaultShaderCompiler.h"
#import "TMGLProgramParametersBuilder.h"

@import Quick;
@import Nimble;

QuickSpecBegin(DefaultProgramCompilerSpec)

describe(@"A default Program Compiler", ^{
  TMGLDefaultProgramCompiler *programCompiler =
    [[TMGLDefaultProgramCompiler alloc] initWithShaderCompiler:[[TMGLDefaultShaderCompiler alloc]
                                                                init]];
  
  it(@"Should return non-zero for valid program parameters", ^{
    TMGLProgramParameters *params = [TMGLProgramParametersBuilder identityProgramParameters];
    expect(@([programCompiler createProgramFromProgramParams:params])).toNot(equal(@0));
  });
  
  it(@"Should return zero for invalid program parameters", ^{
    TMGLProgramParameters *params = [[TMGLProgramParameters alloc]
                                     initWithVertexShaderName:@"invalid shader"
                                     FragmentShaderName:@"invalid shader"
                                     attributes:[[NSArray alloc] init]
                                     unifroms:[[NSArray alloc] init] drawingMethod:0
                                     andVertexCount:0];
    expect(@([programCompiler createProgramFromProgramParams:params])).to(equal(@0));
  });
  
});

QuickSpecEnd