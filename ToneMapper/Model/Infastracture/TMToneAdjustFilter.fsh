// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

varying lowp vec2 textureCoordinates;
uniform sampler2D texture;
uniform lowp mat4 adjustmentMatrix;
uniform lowp float contrast;

void main() {
  gl_FragColor = adjustmentMatrix * texture2D(texture, textureCoordinates);
}
