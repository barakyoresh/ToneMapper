// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Protocol wrapping an opengl frame buffer object.
@protocol TMGLBuffer <NSObject>

/// The size associated with this texture object.
@property (readonly, nonatomic) CGSize size;

/// Binds this framebuffer object in the opengl interface.
- (void)bind;

@end

NS_ASSUME_NONNULL_END