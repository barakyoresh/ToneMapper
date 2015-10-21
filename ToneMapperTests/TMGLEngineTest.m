// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLEngine.h"
#import "TMTypes.h"
#import "TMGLDefaultProgramCompiler.h"
#import "TMGLBuffer.h"
#import "TMGLDrawer.h"
#import "TMGLDefaultShaderCompiler.h"

@import Quick;
@import Nimble;

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

QuickSpecBegin(EngineSpec)

describe(@"Engine Parameters", ^{
  __block TMGLEngine *engine;
  
  beforeEach(^{
    engine = [[TMGLEngine alloc] initWithDrawer:[[TMGLDrawer alloc] initWithProgramCompiler:[[TMGLDefaultProgramCompiler alloc] initWithShaderCompiler:[[TMGLDefaultShaderCompiler alloc] init]]]];
  });

  context(@"I/O", ^{

    it(@"should return an error when loading invalid images", ^{
      __block NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
      UIImage *image = nil;
      [engine loadImage:image completionHandler:^(NSError *err){
        error = err;
      }];
      expect(error).toEventuallyNot(beNil());
    });

    
    it(@"should not return an error when loading valid images", ^{
      __block NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
      UIImage *image = [UIImage imageNamed:@"texture"];
      [engine loadImage:image completionHandler:^(NSError *err){
        error = err;
      }];
      expect(error).toEventually(beNil());
    });
    
    it(@"should return an error when requesting an empty workspace", ^{
      __block NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
      [engine imageFromWorkspaceWithCompletionHandler:^(UIImage *image, NSError *err){
        error = err;
      }];
      expect(error).toEventuallyNot(beNil());
    });
    
    it(@"should return an error when requesting an existing workspace without output an buffer", ^{
      __block NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
      UIImage *image = [UIImage imageNamed:@"texture"];
      [engine loadImage:image completionHandler:^(NSError *err){}];
      [engine imageFromWorkspaceWithCompletionHandler:^(UIImage *image, NSError *err) {
        error = err;
      }];
      expect(error).toEventuallyNot(beNil());
    });
    
    it(@"should not return an error when requesting an existing workspace with an output buffer", ^{
      __block NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
      UIImage *image = [UIImage imageNamed:@"texture"];
      
      id<TMGLBuffer> outputBuffer = MKTMockProtocol(@protocol(TMGLBuffer));
      CGSize bufferSize = CGSizeMake(10, 10);
      [MKTGiven([outputBuffer size]) willReturnStruct:&bufferSize objCType:@encode(CGSize)];

      engine.outputBuffer = outputBuffer;
      [engine loadImage:image completionHandler:^(NSError *err){
        [engine imageFromWorkspaceWithCompletionHandler:^(UIImage *image, NSError *err) {
          error = err;
        }];
      }];
      
      expect(error).toEventually(beNil());
    });
    
  });
  
  
  
});

QuickSpecEnd
