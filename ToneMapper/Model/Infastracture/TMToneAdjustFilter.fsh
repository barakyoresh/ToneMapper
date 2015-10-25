// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

varying lowp vec2 textureCoordinates;
uniform sampler2D texture;
uniform lowp mat4 adjustmentMatrixUniform;

void main() {
  gl_FragColor = adjustmentMatrixUniform * texture2D(texture, textureCoordinates);
}
