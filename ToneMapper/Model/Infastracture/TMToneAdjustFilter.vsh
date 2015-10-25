// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

attribute vec3 position;
attribute vec2 texCoords;
varying vec2 textureCoordinates;

void main() {
  gl_Position = vec4(position.x, -position.y, position.z, 1.0);
  textureCoordinates = texCoords;
}
