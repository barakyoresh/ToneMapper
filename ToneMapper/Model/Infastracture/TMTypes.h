// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMVoidBlock)();
typedef void(^TMErrorBlock)(NSError * __nullable error);
typedef void(^TMImageErrorBlock)(UIImage * __nullable image, NSError * __nullable error);
typedef void(^TMTextureErrorBlock)(TMGLTexture * __nullable image, NSError * __nullable error);

NS_ASSUME_NONNULL_END
