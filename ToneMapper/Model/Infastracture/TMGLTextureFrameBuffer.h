// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLBuffer.h"

#import <UIKit/UIKit.h>

@class TMGLTexture;

NS_ASSUME_NONNULL_BEGIN

/// Wrapper to an opengl frame buffer object, including internal memory managment and
/// object creation within the opengl enviorment. This class conforms to the \c TMGLFrameBuffer
/// protocol.
@interface TMGLTextureFrameBuffer : NSObject <TMGLBuffer>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer for a framebuffer, creates an empty framebuffer of size \c size in the opengl
/// enviorment. The framebuffer writes to the internal \c texture object
- (instancetype)initWithSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

/// The Framebuffer's \c TMGLTexture object associated with it.
@property (readonly, readonly, nonatomic) TMGLTexture *texture;

@end

NS_ASSUME_NONNULL_END
