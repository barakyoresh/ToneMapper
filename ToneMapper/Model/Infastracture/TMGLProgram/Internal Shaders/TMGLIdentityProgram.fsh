// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

varying highp vec2 textureCoordinates;
uniform sampler2D texture;

void main() {
  gl_FragColor = texture2D(texture, textureCoordinates);
}
