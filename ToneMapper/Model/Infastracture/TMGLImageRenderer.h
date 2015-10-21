// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

#import "TMGLTexture.h"
#import "TMTypes.h"

@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

/// Manages \c TMGLTexture to \c UIImage transformations. Using the same ]c TMGLImageRenderer object
/// for multiple textures of the same size will perform performance enhancements and a single
/// internal texture.
@interface TMGLImageRenderer : NSObject

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer method for \c TMGLImageRenderer object, with \c compiler as its internal program
/// compiler.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer
    NS_DESIGNATED_INITIALIZER;

/// Creates a \c UIImage from \c texture. Upon completion \c completionHandler will be called with
/// \c image as the texture image or nil upon error. Incase of an error \c error will be filled with
/// an appropriate error value.
- (void)imageFromTexture:(TMGLTexture *)texture
       completionHandler:(TMImageErrorBlock)completionHandler;

/// Creates a \c TMGLTexture from \c image. Upon completion \c completionHandler will be called with
/// \c image as the texture image or nil upon error. Incase of an error \c error will be filled with
/// an appropriate error value.
- (void)textureFromImage:(UIImage *)image completionHandler:(TMTextureErrorBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
