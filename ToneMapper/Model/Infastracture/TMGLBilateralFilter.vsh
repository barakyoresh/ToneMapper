// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

attribute vec3 position;
attribute vec2 texCoords;
uniform vec2 direction;
uniform vec2 stepSize;

varying vec2 textureCoordinates1;
varying vec2 textureCoordinates2;
varying vec2 textureCoordinates3;
varying vec2 textureCoordinates;
varying vec2 textureCoordinates5;
varying vec2 textureCoordinates6;
varying vec2 textureCoordinates7;

void main() {
  gl_Position = vec4(position.x, -position.y, position.z, 1.0);
  
  textureCoordinates1 = texCoords - (3.0 * stepSize * direction);
  textureCoordinates2 = texCoords - (2.0 * stepSize * direction);
  textureCoordinates3 = texCoords - (1.0 * stepSize * direction);
  textureCoordinates = texCoords;
  textureCoordinates5 = texCoords + (1.0 * stepSize * direction);
  textureCoordinates6 = texCoords + (2.0 * stepSize * direction);
  textureCoordinates7 = texCoords + (3.0 * stepSize * direction);
}
