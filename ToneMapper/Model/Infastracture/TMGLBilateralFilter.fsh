// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

uniform sampler2D texture;

varying lowp vec2 textureCoordinates1;
varying lowp vec2 textureCoordinates2;
varying lowp vec2 textureCoordinates3;
varying lowp vec2 textureCoordinates;
varying lowp vec2 textureCoordinates5;
varying lowp vec2 textureCoordinates6;
varying lowp vec2 textureCoordinates7;

highp float colorDistanceWeight(highp vec4 left, highp vec4 right);

void main() {
  lowp vec4 sum = vec4(0);
  lowp float weight;
  lowp float weightSum = 0.0;
  
  lowp vec4 textureValue1 = texture2D(texture, textureCoordinates1);
  lowp vec4 textureValue2 = texture2D(texture, textureCoordinates2);
  lowp vec4 textureValue3 = texture2D(texture, textureCoordinates3);
  lowp vec4 textureValue = texture2D(texture, textureCoordinates);
  lowp vec4 textureValue5 = texture2D(texture, textureCoordinates5);
  lowp vec4 textureValue6 = texture2D(texture, textureCoordinates6);
  lowp vec4 textureValue7 = texture2D(texture, textureCoordinates7);
  
  weight = 0.015625 * colorDistanceWeight(textureValue, textureValue1);
  sum += textureValue1 * weight;
  weightSum += weight;
  weight = 0.09375 * colorDistanceWeight(textureValue, textureValue2);
  sum += textureValue2 * weight;
  weightSum += weight;
  weight = 0.234375 * colorDistanceWeight(textureValue, textureValue3);
  sum += textureValue3 * weight;
  weightSum += weight;
  weight = 0.3125 * colorDistanceWeight(textureValue, textureValue);
  sum += textureValue * weight;
  weightSum += weight;
  weight = 0.234375 * colorDistanceWeight(textureValue, textureValue5);
  sum += textureValue5 * weight;
  weightSum += weight;
  weight = 0.09375 * colorDistanceWeight(textureValue, textureValue6);
  sum += textureValue6 * weight;
  weightSum += weight;
  weight = 0.015625 * colorDistanceWeight(textureValue, textureValue7);
  sum += textureValue7 * weight;
  weightSum += weight;
  
  gl_FragColor = sum / weightSum;
}

highp float colorDistanceWeight(highp vec4 left, highp vec4 right) {
  lowp float sigma = 0.2;
  return (1.0 / (sigma * 2.506628)) * exp(-(length(left - right) / (sigma * sigma * 2.0)));
}
