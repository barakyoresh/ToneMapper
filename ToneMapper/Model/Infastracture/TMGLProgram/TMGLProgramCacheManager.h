// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>

@class TMGLProgramParameters, TMGLProgram;

NS_ASSUME_NONNULL_BEGIN

/// Program cache manager, saves handle for compiled programs and returns them if
/// \c TMGLProgramParameters match a compiled handle and do not require recompiling.
@interface TMGLProgramCacheManager : NSObject

/// Returns the handle to a cached compiled program matching \c programParams or nil if no such
/// program exsists in the cache.
- (TMGLProgram *)programFromCache:(TMGLProgramParameters *)programParams;

/// Adds \c programParams to the cache along with \c program as their corresponding compiled version.
- (void)addToCache:(TMGLProgramParameters *)programParams program:(TMGLProgram *)program;

@end

NS_ASSUME_NONNULL_END
