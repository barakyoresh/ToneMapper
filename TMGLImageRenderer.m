// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLImageRenderer.h"

#import "TMGLTextureFrameBuffer.h"
#import "TMGLDrawer.h"
#import "TMGLProgramParametersBuilder.h"
#import "TMGLGeometry.h"

static const int kBitsPerComponent = 8, kBitsPerPixel = 32;
static char * const kImageInputOutputQueue = "Image I/O Queue";
static NSString * const kSaveImageErrorDomain = @"Save Image Error";
static NSString * const kLoadImageErrorDomain = @"Load Image Error";
static const int kTextureError = -1;
static const int kImageError = -2;

NS_ASSUME_NONNULL_BEGIN

/// Category resizing method for UIImage, used to make sure images loaded aren't bigger than
/// \c GL_MAX_TEXTURE_SIZE, in case of error returns nil.
@implementation UIImage(TMTextureCompiler)

- (UIImage *)imageInSize:(CGSize)size {
  CGRect rect = CGRectMake(0, 0, size.width, size.height);
  UIGraphicsBeginImageContext(rect.size);
  [self drawInRect:rect];
  UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resizedImage;
}

@end

@interface TMGLImageRenderer()

/// Internal \c TMGLDrawer to use when drawing the input texture to the output.
@property (nonatomic, strong) TMGLDrawer *drawer;

/// Internal \c TMGLTextureFrameBuffer object to be drawn on.
@property (nonatomic, strong) TMGLTextureFrameBuffer *frameBuffer;

/// Internal \c TMGLProgramParameters to be used for drawing.
@property (nonatomic, strong) TMGLProgramParameters *identityProgramParameters;

@end

@implementation TMGLImageRenderer

- (instancetype)initWithProgramCompiler:(id<TMGLProgramCompiler>)programCompiler {
  if (self = [super init]) {
    _drawer = [[TMGLDrawer alloc] initWithProgramCompiler:programCompiler];
    _identityProgramParameters = [TMGLProgramParametersBuilder identityProgramParameters];
  }
  return self;
}

- (void)imageFromTexture:(TMGLTexture *)texture
       completionHandler:(TMImageErrorBlock)completionHandler {
  if (!texture.size.height || !texture.size.width) {
    completionHandler(nil, [NSError errorWithDomain:kSaveImageErrorDomain code:kImageError
                                           userInfo:nil]);
    return;
  }
  
  if (!self.frameBuffer || !CGSizeEqualToSize(self.frameBuffer.size, texture.size)) {
    self.frameBuffer = [[TMGLTextureFrameBuffer alloc] initWithSize:texture.size];
  }
  
  [self dispatchAsynchronouslyWithCurrentContext:^{
    [self.drawer drawTexture:texture toFrameBuffer:self.frameBuffer
       WithProgramParameters:self.identityProgramParameters];
    
    NSInteger myDataLength = texture.size.width * texture.size.height * 4;
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    
    [self.frameBuffer bind];
    glReadPixels(0, 0, texture.size.width, texture.size.height,
                 GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, releaseBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef imageRef = CGImageCreate(texture.size.width, texture.size.height, kBitsPerComponent,
                                        kBitsPerPixel, 4 * texture.size.width, colorSpace,
                                        kCGBitmapByteOrderDefault, provider, NULL, NO,
                                        kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (image) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(image, nil);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil, [NSError errorWithDomain:kSaveImageErrorDomain code:kImageError
                                               userInfo:nil]);
      });
    }
  }];
  return;
}

void releaseBuffer(void *info, const void *data, size_t size) {
  free((void*)data);
}

- (void)textureFromImage:(UIImage *)image completionHandler:(TMTextureErrorBlock)completionHandler {
  GLint maxTextureSize = 0;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
  
  [self dispatchAsynchronouslyWithCurrentContext:^{
    // cap texture width to max image size
    UIImage *resizedRotatedImage = [self resizedRotatedImage:image maxImageSize:maxTextureSize];
    
    if (!resizedRotatedImage) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil, [NSError errorWithDomain:kLoadImageErrorDomain code:kImageError
                                          userInfo:nil]);
      });
      return;
    }
    
    TMGLTexture *texture = [[TMGLTexture alloc] initWithImage:resizedRotatedImage];
    if (!texture) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil, [NSError errorWithDomain:kLoadImageErrorDomain code:kTextureError
                                          userInfo:nil]);
      });
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completionHandler(texture, nil);
    });
  }];
  
  return;
}

- (UIImage *)resizedRotatedImage:(UIImage *)image maxImageSize:(NSInteger)maxSize{
  // no redrawing necessary.
  if (([image imageOrientation] == UIImageOrientationUp && image.size.width <= maxSize &&
       image.size.height <= maxSize)) {
    return image;
  }
  
  CGSize size = image.size;
  if (image.size.width > maxSize || image.size.height > maxSize) {
    float aspect = image.size.height / image.size.width;
    
    if (image.size.width > image.size.height) {
      size = CGSizeMake(maxSize, maxSize * aspect);
    } else {
      size = CGSizeMake(maxSize / aspect, maxSize);
    }
  }
  
  return [image imageInSize:size];
}

- (void)dispatchAsynchronouslyWithCurrentContext:(TMVoidBlock)block {
  //save current context
  EAGLContext *currentContext = [EAGLContext currentContext];
  
  dispatch_async(dispatch_queue_create(kImageInputOutputQueue, 0), ^{
    //set context to main thread's current context
    [EAGLContext setCurrentContext:currentContext];
    block();
  });
}

@end

NS_ASSUME_NONNULL_END
