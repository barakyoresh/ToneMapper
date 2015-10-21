// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramCacheManager.h"
#import "TMGLProgramParameters.h"
#import "TMGLProgramAttribute.h"
#import "TMGLProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLProgramCacheManager ()

/// Internal cache for <\c TMGLProgramParameters, \c TMGLProgram> representing compied program
/// parameters and their corresponding handles/
@property (strong, readonly, nonatomic) NSMutableDictionary *programCache;

@end

@implementation TMGLProgramCacheManager

- (instancetype)init {
  if (self = [super init]) {
    _programCache = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (TMGLProgram *)programFromCache:(TMGLProgramParameters *)programParams {
  return self.programCache[programParams];
}

- (void)addToCache:(TMGLProgramParameters *)programParams program:(TMGLProgram *)program {
  self.programCache[programParams] = program;
}

@end

NS_ASSUME_NONNULL_END
