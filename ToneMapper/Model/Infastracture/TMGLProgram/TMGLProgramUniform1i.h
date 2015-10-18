// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform.h"

#import <OpenGLES/ES2/gl.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A single integer uniform variable to an opengl program, conforming to the
/// \c <TMGLProgramUnifrom> protocol.
@interface TMGLProgramUniform1i : NSObject <TMGLProgramUniform>

/// Initializer of this uniform varible with \c name as its name and \c value as its integer value.
- (instancetype)initWithName:(NSString *)name andValue:(GLint)value NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
