// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

/// A single image filter block protocol, applying an editing effect to a \c TMGLTexture
@protocol TMGLFilter <NSObject>

/// Applies this process on \c inputTexture, outputting the result as a \c TMGLTexture object.
/// Output texture must be a different object from input texture.
- (TMGLTexture *)applyOnTexture:(TMGLTexture *)inputTexture;

@end

NS_ASSUME_NONNULL_END
