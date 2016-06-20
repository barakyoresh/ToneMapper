// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

#import "TMGLProgramUniform.h"

NS_ASSUME_NONNULL_BEGIN

/// A single 2 float vector uniform variable to an opengl program, conforming to the
/// \c <TMGLProgramUnifrom> protocol.
@interface TMGLProgramUniform2f : NSObject <TMGLProgramUniform>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer of this uniform varible with \c name as its name and \c value as a pointer to a
/// 2 float vector.
/// This copies the data stored in \c valuePointer so it can be released after initializing this.
- (instancetype)initWithName:(NSString *)name andValuePointer:(GLfloat *)valuePointer
    NS_DESIGNATED_INITIALIZER;

// This unifrom's name corresponding to a shader file's uniform variable.
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END