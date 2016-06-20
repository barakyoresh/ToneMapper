// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMFeature.h"

@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

/// Tonal feature enabling tone adjustments such as brightness, contrast, saturation, tint and hue.
/// Tonal feature performs blocking preprocessing and must be creating in a seperate queue.
@interface TMTonalFeature : NSObject <TMFeature>

/// Setting super initializers as unavailable.
- (instancetype)init NS_UNAVAILABLE;

/// Designated initializer, requiring \c TMGLDrawer object to use for drawing and image processing.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer andInputTexture:(TMGLTexture *)inputTexture
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
