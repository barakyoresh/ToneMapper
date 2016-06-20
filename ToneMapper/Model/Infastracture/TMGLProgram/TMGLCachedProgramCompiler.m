// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLCachedProgramCompiler.h"
#import "TMGLDefaultProgramCompiler.h"
#import "TMGLProgramAttribute.h"
#import "TMGLProgramCacheManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLCachedProgramCompiler()

/// Internal \c TMGLDefaultProgramCompiler for when compiling of the program parameters is required.
@property (strong, readonly, nonatomic) TMGLDefaultProgramCompiler *compiler;

/// Cache manager to manage cahced compiled versions of \c TMGLProgramParameters.
@property (strong, readonly, nonatomic) TMGLProgramCacheManager *cache;

@end

@implementation TMGLCachedProgramCompiler

- (instancetype)initWithShaderCompiler:(id <TMGLShaderCompiler>)shaderCompiler {
  if (!shaderCompiler) {
    return nil;
  }
  
  if (self = [super init]) {
    _compiler = [[TMGLDefaultProgramCompiler alloc] initWithShaderCompiler:shaderCompiler];
    _cache = [[TMGLProgramCacheManager alloc] init];
  }
  return self;
}

- (TMGLProgram *)createProgramFromProgramParams:(TMGLProgramParameters *)programParams {
  if (!programParams) {
    return nil;
  }
  
  TMGLProgram *program = [self.cache programFromCache:programParams];
  
  if (!program) {
    program = [self.compiler createProgramFromProgramParams:programParams];
    if (program) {
      [self.cache addToCache:programParams program:program];
    }
  }
  return program;
}

@end

NS_ASSUME_NONNULL_END
