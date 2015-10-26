// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLGeometry.h"
#import "TMGLTextureFrameBuffer.h"
#import "TMGLTexture.h"
#import "TMGLDrawer.h"
#import "TMGLProgramUniformMatrix4f.h"

#import <GLKit/GLKit.h>

#import "TMGLToneAdjustFilter.h"

#define capped(X) MAX(0, MIN(1, X))

NS_ASSUME_NONNULL_BEGIN

static NSString * const kAdjustmentMatrixUniform = @"adjustmentMatrix";
static NSString * const kTonalProgramTextureCoordinatesAttribute = @"texCoords";
static NSString * const kTonalProgramPositionAttribute = @"position";
static NSString * const kTonalProgramTextureSamplerUniform = @"texture";
static NSString * const kTonalProgramShaderName = @"TMToneAdjustFilter";
static const float kDefaultBrightness = 0.5f;
static const float kDefaultGlobalContrast = 0.25f;
static const float kDefaultSaturation = 0.25f;
static const float kDefaultTint = 0.5f;
static const float kDefaultTemprature = 0.5f;
static const float kChromaDampenWeight = 0.25f;
static const GLKMatrix4 kRGBAtoYUVA = {0.299, -0.14713,  0.615,   0,
                                       0.587, -0.28886, -0.51499, 0,
                                       0.114,  0.436,   -0.10001, 0,
                                       0,      0,        0,       1};
static const GLKMatrix4 kYUVAtoRGBA = {1,        1,       1,       0,
                                       0,       -0.39465, 2.03211, 0,
                                       1.13983, -0.5806,  0,       0,
                                       0,        0,       0,       1};

@interface TMGLToneAdjustFilter()

/// Internal \c TMGLDrawer object for processing textures.
@property (strong, readonly, nonatomic) TMGLDrawer *drawer;

/// Internal open gl program parameters to create the desired tone adjustment effect.
@property (strong, nonatomic) TMGLProgramParameters *programParams;

/// Internal \c TMGLTextureFrameBuffer object to be drawn on.
@property (strong, nonatomic) TMGLTextureFrameBuffer *frameBuffer;

@end

@implementation TMGLToneAdjustFilter

- (instancetype)initWithDrawer:(TMGLDrawer * )drawer {
  if (!drawer) {
    return nil;
  }
  
  if (self = [super init]) {
    _drawer = drawer;
    self.programParams = [self setupProgramParameters];
    self.brightness = kDefaultBrightness;
    self.saturation = kDefaultSaturation;
    self.temprature = kDefaultTemprature;
    self.tint = kDefaultTint;
    self.globalContrast = kDefaultGlobalContrast;
  }
  return self;
}

- (TMGLProgramParameters *)setupProgramParameters {
  TMGLProgramParametersBuilder *builder = [[TMGLProgramParametersBuilder alloc] init];
  GLuint textureValue = 0;
  GLKMatrix4 adjustmentMatrix = GLKMatrix4Identity;
  
  [[[[[[[builder addAttribute:kTonalProgramTextureCoordinatesAttribute
     valuePointer:[TMGLGeometry quadTextureCoordinates]
     size:[TMGLGeometry quadTextureCoordinatesSize]
     type:[TMGLGeometry quadTextureCoordinatesType]
     andStride:[TMGLGeometry quadTextureCoordinatesStride]]
     addAttribute:kTonalProgramPositionAttribute valuePointer:[TMGLGeometry quadPositions]
     size:[TMGLGeometry quadPositionsSize] type:[TMGLGeometry quadPositionsType]
     andStride:[TMGLGeometry quadPositionsStride]]
     addUniform:kTonalProgramTextureSamplerUniform valuePointer:&textureValue
     andType:TMGLUniformInt]
     addUniform:kAdjustmentMatrixUniform valuePointer:&adjustmentMatrix
     andType:TMGLUniformFloatMatrix4]
     setVertexShader:kTonalProgramShaderName]
     setFragmentShader:kTonalProgramShaderName]
     setDrawingMethod:GL_TRIANGLE_STRIP andVertexCount:4];
  
  return [builder build];
}

- (TMGLTexture *)applyOnTexture:(TMGLTexture *)inputTexture {
  GLKMatrix4 adjustmentMatrix = [self makeAdjustmentMatrix];
  self.programParams =
      [self.programParams parametersWithReplacedUniform:[[TMGLProgramUniformMatrix4f alloc]
      initWithName:kAdjustmentMatrixUniform andValuePointer:(GLfloat *)&adjustmentMatrix]];
  
  if (!self.frameBuffer || !CGSizeEqualToSize(self.frameBuffer.size, inputTexture.size)) {
    self.frameBuffer = [[TMGLTextureFrameBuffer alloc] initWithSize:inputTexture.size];
  }
  
  [self.drawer drawTexture:inputTexture toFrameBuffer:self.frameBuffer
     withProgramParameters:self.programParams];
  return self.frameBuffer.texture;
}

- (GLKMatrix4)makeAdjustmentMatrix {
  return GLKMatrix4Multiply([self makeTintMatrix],
         GLKMatrix4Multiply([self makeGlobalContrastMatrix],
         GLKMatrix4Multiply([self makeTempratureMatrix],
         GLKMatrix4Multiply([self makeBrightnessMatrix], [self makeSaturationMatrix]))));
}

#pragma mark -
#pragma mark Brightness
#pragma mark -

- (void)setBrightness:(float)brightness {
  _brightness = capped(brightness);
}

- (GLKMatrix4)makeBrightnessMatrix {
  float brightness = (self.brightness * 2) - 1;
  return GLKMatrix4Multiply(kYUVAtoRGBA,
         GLKMatrix4Multiply(GLKMatrix4MakeTranslation(brightness, 0, 0), kRGBAtoYUVA));
}

#pragma mark -
#pragma mark Contrast
#pragma mark -

- (void)setGlobalContrast:(float)globalContrast {
  _globalContrast = capped(globalContrast);
}

- (GLKMatrix4)makeGlobalContrastMatrix {
  float globalContrast = self.globalContrast * 4;
  return GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0.5, 0.5, 0.5),
      GLKMatrix4Multiply(GLKMatrix4MakeScale(globalContrast, globalContrast, globalContrast),
      GLKMatrix4MakeTranslation(-0.5, -0.5, -0.5)));
}

#pragma mark -
#pragma mark Saturation
#pragma mark -

- (void)setSaturation:(float)saturation {
  _saturation = capped(saturation);
}

- (GLKMatrix4)makeSaturationMatrix {
  float saturation = (self.saturation * 4) - 1;
  return GLKMatrix4Multiply(kYUVAtoRGBA,
         GLKMatrix4Multiply(GLKMatrix4MakeScale(1, 1 + saturation, 1 + saturation), kRGBAtoYUVA));
}

#pragma mark -
#pragma mark Tint
#pragma mark -

- (void)setTint:(float)tint {
  _tint = capped(tint);
}

- (GLKMatrix4)makeTintMatrix {
  float tint = (self.tint - 0.5) * kChromaDampenWeight;
  return GLKMatrix4Multiply(kYUVAtoRGBA,
         GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, tint, tint), kRGBAtoYUVA));
}

#pragma mark -
#pragma mark Temprature
#pragma mark -

- (void)setTemprature:(float)temprature {
  _temprature = capped(temprature);
}

- (GLKMatrix4)makeTempratureMatrix {
  float temp =  (self.temprature - 0.5) * -kChromaDampenWeight;
  return GLKMatrix4Multiply(kYUVAtoRGBA,
         GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, temp, -temp), kRGBAtoYUVA));
}

@end

NS_ASSUME_NONNULL_END