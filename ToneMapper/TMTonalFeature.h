// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMFeature.h"

@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

/// Tonal feature enabling tone adjustments such as brightness, contrast, saturation, tint and hue.
@interface TMTonalFeature : NSObject <TMFeature>

/// Setting super initializers as unavailable.
- (instancetype)init NS_UNAVAILABLE;

/// Designated initializer, requiring \c TMGLDrawer object to use for drawing and image processing.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
