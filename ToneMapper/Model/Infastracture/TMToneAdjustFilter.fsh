// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

varying lowp vec2 textureCoordinates;
uniform sampler2D texture;
uniform sampler2D smoothTexture;
uniform sampler2D smootherTexture;
uniform lowp float mediumContrast;
uniform lowp float fineContrast;
uniform lowp mat4 adjustmentMatrix;

void main() {
  lowp vec4 preGlobalAdjustmentColor =
      (1.0 + mediumContrast + fineContrast) * texture2D(texture, textureCoordinates) -
      fineContrast * texture2D(smoothTexture, textureCoordinates) -
      mediumContrast * texture2D(smootherTexture, textureCoordinates);
  gl_FragColor = adjustmentMatrix * preGlobalAdjustmentColor;
}
