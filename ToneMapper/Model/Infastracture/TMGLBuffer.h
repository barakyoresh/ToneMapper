// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Protocol wrapping an opengl frame buffer object.
@protocol TMGLBuffer <NSObject>

/// Binds this framebuffer object in the opengl interface.
- (void)bind;

/// The size associated with this texture object.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
