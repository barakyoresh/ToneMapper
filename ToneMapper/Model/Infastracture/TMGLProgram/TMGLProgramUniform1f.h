// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramUniform.h"

#import <OpenGLES/ES2/gl.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A single integer uniform variable to an opengl program, conforming to the
/// \c <TMGLProgramUnifrom> protocol.
@interface TMGLProgramUniform1f : NSObject <TMGLProgramUniform>

// This unifrom's name corresponding to a shader file's uniform variable.
@property (strong, readonly, nonatomic) NSString *name;

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer of this uniform varible with \c name as its name and \c value as its integer value.
- (instancetype)initWithName:(NSString *)name andValue:(GLfloat)value NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
