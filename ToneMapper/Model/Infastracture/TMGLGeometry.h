// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Static class containing simple geometry entities.
@interface TMGLGeometry : NSObject

/// An array of floating points containing 4 3-member vectors corresponding default locations of
/// a single quad as a triangle strip.
+ (const float*)quadPositions;

/// Size of each entry in the \c quadPositions array.
+ (const GLint)quadPositionsSize;

/// Type of each entry's coordinate in the \c quadPositions array.
+ (const GLenum)quadPositionsType;

/// Distance between entries of the \c quadPositions array.
+ (const GLenum)quadPositionsStride;

/// An array of floating points containing 4 2-member vectors corresponding default texture
/// locations of a textured strechd over a single quad as a triangle strip.
+ (const float*)quadTextureCoordinates;

/// Size of each entry in the \c quadTextureCoordinates array.
+ (const GLint)quadTextureCoordinatesSize;

/// Type of each entry's coordinate in the \c quadTextureCoordinates array.
+ (const GLenum)quadTextureCoordinatesType;

/// Distance between entries of the \c quadTextureCoordinates array.
+ (const GLenum)quadTextureCoordinatesStride;

@end

NS_ASSUME_NONNULL_END
