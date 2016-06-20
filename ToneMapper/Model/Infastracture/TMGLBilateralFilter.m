// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"

#import "TMGLBilateralFilter.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLGeometry.h"
#import "TMGLTextureFrameBuffer.h"
#import "TMGLProgramUniform2f.h"
#import "TMGLTexture.h"
#import "TMGLDrawer.h"

NS_ASSUME_NONNULL_BEGIN

static const int kKernelStep = 6;
static NSString * const kBilateralProgramTextureCoordinatesAttribute = @"texCoords";
static NSString * const kBilateralProgramPositionAttribute = @"position";
static NSString * const kBilateralProgramTextureSamplerUniform = @"texture";
static NSString * const kBilateralProgramDirectionVectorUniform = @"direction";
static NSString * const kBilateralProgramStepSizeUniform = @"stepSize";
static NSString * const kBilateralProgramShaderName = @"TMGLBilateralFilter";

@interface TMGLBilateralFilter()

/// Internal \c TMGLDrawer object for image processing
@property (strong, readonly, nonatomic) TMGLDrawer *drawer;

/// Internal open gl program parameters to create the desired tone adjustment effect.
@property (strong, nonatomic) TMGLProgramParameters *programParams;

/// Internal \c TMGLTextureFrameBuffer object to be drawn on. When doing the horizontal convolution.
@property (strong, nonatomic) TMGLTextureFrameBuffer *horizontalConvFrameBuffer;

/// Internal \c TMGLTextureFrameBuffer object to be drawn on. When doing the vertical convolution.
@property (nullable, strong, nonatomic) TMGLTextureFrameBuffer *verticalConvFrameBuffer;

@end

@implementation TMGLBilateralFilter

- (instancetype)initWithDrawer:(TMGLDrawer *)drawer {
  if (self = [super init]) {
    _drawer = drawer;
    _kernelSize = 1 + kKernelStep;
    self.programParams = [self setupProgramParameters];
  }
  return self;
}

- (TMGLProgramParameters *)setupProgramParameters {
  TMGLProgramParametersBuilder *builder = [[TMGLProgramParametersBuilder alloc] init];
  GLuint textureValue = 0;
  GLKVector2 direction = GLKVector2Make(1, 0);
  GLKVector2 stepSize = GLKVector2Make(0, 0);
  
  [[[[[[[[builder addAttribute:kBilateralProgramTextureCoordinatesAttribute
        valuePointer:[TMGLGeometry quadTextureCoordinates]
        size:[TMGLGeometry quadTextureCoordinatesSize]
        type:[TMGLGeometry quadTextureCoordinatesType]
        andStride:[TMGLGeometry quadTextureCoordinatesStride]]
      addAttribute:kBilateralProgramPositionAttribute valuePointer:[TMGLGeometry quadPositions]
        size:[TMGLGeometry quadPositionsSize] type:[TMGLGeometry quadPositionsType]
        andStride:[TMGLGeometry quadPositionsStride]]
      addUniform:kBilateralProgramTextureSamplerUniform valuePointer:&textureValue
        andType:TMGLUniformInt]
      addUniform:kBilateralProgramDirectionVectorUniform valuePointer:&direction
        andType:TMGLUniformFloat2]
      addUniform:kBilateralProgramStepSizeUniform valuePointer:&stepSize andType:TMGLUniformFloat2]
      setVertexShader:kBilateralProgramShaderName]
      setFragmentShader:kBilateralProgramShaderName]
      setDrawingMethod:GL_TRIANGLE_STRIP andVertexCount:4];
  
  return [builder build];
}

- (TMGLTexture *)applyOnTexture:(TMGLTexture *)inputTexture {
  self.verticalConvFrameBuffer = nil;
  NSUInteger kernelPasses = (self.kernelSize - 1) / 6;
  
  GLKVector2 stepSize = GLKVector2Make(1 / inputTexture.size.width, 1 / inputTexture.size.height);
  TMGLProgramUniform2f *stepSizeUniform =
  [[TMGLProgramUniform2f alloc] initWithName:kBilateralProgramStepSizeUniform
                             andValuePointer:(GLfloat *)&stepSize];
  self.programParams = [self.programParams parametersWithReplacedUniform:stepSizeUniform];
  
  GLKVector2 horizontalDirection = GLKVector2Make(1, 0);
  GLKVector2 verticalDirection = GLKVector2Make(0, 1);
  
  TMGLProgramUniform2f *horizontalUniform =
      [[TMGLProgramUniform2f alloc] initWithName:kBilateralProgramDirectionVectorUniform
                                 andValuePointer:(GLfloat *)&horizontalDirection];
  TMGLProgramUniform2f *verticalUniform =
      [[TMGLProgramUniform2f alloc] initWithName:kBilateralProgramDirectionVectorUniform
                                 andValuePointer:(GLfloat *)&verticalDirection];
  
  if (!self.horizontalConvFrameBuffer || !self.verticalConvFrameBuffer ||
      !CGSizeEqualToSize(self.horizontalConvFrameBuffer.size, inputTexture.size) ||
      !CGSizeEqualToSize(self.verticalConvFrameBuffer.size, inputTexture.size)) {
    self.horizontalConvFrameBuffer =
        [[TMGLTextureFrameBuffer alloc] initWithSize:inputTexture.size];
    self.verticalConvFrameBuffer = [[TMGLTextureFrameBuffer alloc] initWithSize:inputTexture.size];
  }
  
  // initial pass
  self.programParams = [self.programParams parametersWithReplacedUniform:horizontalUniform];
  [self.drawer drawTexture:inputTexture toFrameBuffer:self.horizontalConvFrameBuffer
     withProgramParameters:self.programParams];
  self.programParams = [self.programParams parametersWithReplacedUniform:verticalUniform];
  [self.drawer drawTexture:self.horizontalConvFrameBuffer.texture
             toFrameBuffer:self.verticalConvFrameBuffer withProgramParameters:self.programParams];
  
  // possible multiple passes
  for (int i = 1; i < kernelPasses; i++) {
    self.programParams = [self.programParams parametersWithReplacedUniform:horizontalUniform];
    [self.drawer drawTexture:self.verticalConvFrameBuffer.texture
        toFrameBuffer:self.horizontalConvFrameBuffer withProgramParameters:self.programParams];
    self.programParams = [self.programParams parametersWithReplacedUniform:verticalUniform];
    [self.drawer drawTexture:self.horizontalConvFrameBuffer.texture
               toFrameBuffer:self.verticalConvFrameBuffer withProgramParameters:self.programParams];
  }
  
  return self.verticalConvFrameBuffer.texture;
}

- (void)setKernelSize:(NSUInteger)kernelSize {
  _kernelSize = MAX(1 + kKernelStep, (((kernelSize - 1) / kKernelStep) * kKernelStep) + 1);
}

@end

NS_ASSUME_NONNULL_END
