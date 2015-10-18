// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLCachedProgramCompiler.h"
#import "TMGLDefaultProgramCompiler.h"
#import "TMGLProgramAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMGLProgramAttribute(CahceCompare)

/// Cached equals created to check if this \c TMGLProgramAttribute is equal as far as the cache
/// is concerned to \c other.
- (BOOL)cachedEquals:(TMGLProgramAttribute *)other {
  return (self == other);
}

@end

@implementation TMGLProgramParameters(CahceCompare)

/// Cached equals created to check if this  \c TMGLProgramParameters is equal as far as the cache
/// is concerned to \c other.
- (BOOL)cachedEquals:(TMGLProgramParameters *)other {
  if (![self.vertexShaderName isEqualToString:other.vertexShaderName]) {
    return NO;
  }
  
  if (![self.fragmentShaderName isEqualToString:other.fragmentShaderName]) {
    return NO;
  }
  
  if ([self.attributes count] != [other.attributes count]) {
    return NO;
  }
  
  for (TMGLProgramAttribute *selfAttr in self.attributes) {
    BOOL arrayDifference = YES;
    for (TMGLProgramAttribute *otherAttr in other.attributes) {
      if ([selfAttr cachedEquals:otherAttr]) {
        arrayDifference = NO;
      }
    }
    if (arrayDifference) {
      return NO;
    }
  }
  
  return YES;
}

@end

@interface TMGLCachedProgramCompiler()

/// Internal \c TMGLDefaultProgramCompiler for when compiling of the program parameters is required.
@property (nonatomic, strong) TMGLDefaultProgramCompiler *compiler;

/// Internal cache for <\c GLuint , \c TMGLProgramParameters> representing compied program
/// parameters and their corresponding handles/
@property (nonatomic, strong) NSMutableDictionary *programCache;

@end

@implementation TMGLCachedProgramCompiler

- (instancetype)initWithShaderCompiler:(id <TMGLShaderCompiler>)shaderCompiler {
  if (self = [super init]) {
    _compiler = [[TMGLDefaultProgramCompiler alloc] initWithShaderCompiler:shaderCompiler];
    _programCache = [[NSMutableDictionary alloc] init];
  }
  return _compiler ? self : nil;
}

- (GLuint)createProgramFromProgramParams:(TMGLProgramParameters *)programParams {
  if (!programParams) {
    return 0;
  }
  
  GLuint program;
  if ([self programExistsInCache:programParams]) {
    program = [self programFromCache:programParams];
  } else {
    program = [self.compiler createProgramFromProgramParams:programParams];
    NSLog(@"Program not in cache - creating %d, cache size %lu", program,
          [self.programCache count] + 1);
  }
  self.programCache[[NSNumber numberWithUnsignedInt:program]] = programParams;
  
  return program;
}

- (BOOL)programExistsInCache:(TMGLProgramParameters *)programParams {
  if (![self.programCache count]) {
    return NO;
  }
  for (NSNumber *cachedProgramName in [self.programCache allKeys]) {
    if ([self.programCache[cachedProgramName] cachedEquals:programParams]) {
      return TRUE;
    }
  }
  return NO;
}

- (GLuint)programFromCache:(TMGLProgramParameters *)programParams {
  for (NSNumber *cachedProgramName in [self.programCache allKeys]) {
    if ([self.programCache[cachedProgramName] cachedEquals:programParams]) {
      return (GLuint)[cachedProgramName unsignedIntegerValue];
    }
  }
  return 0;
}


@end

NS_ASSUME_NONNULL_END
