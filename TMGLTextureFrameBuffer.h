// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLBuffer.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "TMGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

/// Wrapper to an opengl frame buffer object, including internal memory managment and
/// object creation within the opengl enviorment. This class conforms to the \c TMGLFrameBuffer
/// protocol.
@interface TMGLTextureFrameBuffer : NSObject <TMGLBuffer>

/// The Framebuffer's \c TMGLTexture object associated with it.
@property (nonatomic, readonly) TMGLTexture *texture;

/// Initializer for a framebuffer, creates an empty framebuffer of size \c size in the opengl
/// enviorment. The framebuffer writes to the internal \c texture object
- (instancetype)initWithSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
