// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "TMGLBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLScreenRenderBuffer : NSObject <TMGLBuffer>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializes this \c TMGLScreenFrameBuffer without creating one in the opengl enviorment but
/// rather using the internal framebuffer created by te supplies \c GLKView.
- (instancetype)initWithGLKView:(GLKView *)glkView NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
