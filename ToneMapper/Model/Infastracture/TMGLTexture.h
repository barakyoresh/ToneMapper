// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Wrapper to opengl Texture object, includes internal memory management and texture properites.
@interface TMGLTexture : NSObject

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer for \c TMGLTexture as an image texture, using \c image as the texture, internal
/// \c size property in inferred from image.
- (instancetype)initWithImage:(UIImage *)image NS_DESIGNATED_INITIALIZER;

/// Initializer for \c TMGLTexture as an empty texture of size \c size.
- (instancetype)initWithSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

/// Attaches this texture as the logical buffer of currently bound framebuffer object
- (void)attachToFrameBuffer;

/// Binds the texture to the current context to be used in subsequent draws.
/// This is equivalant to \c bindToLocation:0.
- (void)bind;

/// Binds the texture to the current cotnext as the texture in active texture described by
/// \c location.
- (void)bindToLocation:(GLuint)location;

/// The Size associated with this texture object.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
