// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import "TMGLFilter.h"

@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

/// Identity image filter, conforming to the \c TMGLProcess protocol and copying the texture as is
/// to a different texture object.
@interface TMGLIdentityFilter : NSObject <TMGLFilter>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer method for \c TMGLIdentityFilter object, with \c compiler as its internal program
/// compiler.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
