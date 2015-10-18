// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <OpenGLES/ES2/gl.h>

#import "TMGLGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMGLGeometry

const float quadVertexArray[] = {
  -1.0, 1.0, 0.0,
  1.0, 1.0, 0.0,
  -1.0, -1.0, 0.0,
  1.0, -1.0, 0.0};

const float quadTexCoordsArray[] = {
  0.0, 0.0,
  1.0, 0.0,
  0.0, 1.0,
  1.0, 1.0,
};

+ (const float*)quadPositions {
  return quadVertexArray;
}

+ (const GLint)quadPositionsSize {
  return 3;
}

+ (const GLenum)quadPositionsType {
  return GL_FLOAT;
}

+ (const GLenum)quadPositionsStride {
  return sizeof(float) * 3;
}

+ (const float*)quadTextureCoordinates {
  return quadTexCoordsArray;
}

+ (const GLint)quadTextureCoordinatesSize {
  return 2;
}

+ (const GLenum)quadTextureCoordinatesType {
  return GL_FLOAT;
}

+ (const GLenum)quadTextureCoordinatesStride {
  return sizeof(float) * 2;
}



@end

NS_ASSUME_NONNULL_END
