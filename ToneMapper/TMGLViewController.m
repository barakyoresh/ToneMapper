// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.


#import "TMGLViewController.h"

#import <UIKit/UIKit.h>

#import "TMGLScreenRenderBuffer.h"
#import "TMActivityIndicator.h"
#import "TMGLEngine.h"

NS_ASSUME_NONNULL_BEGIN


@interface TMGLViewController()

/// The \c TMGLEngine object used to handle image editing and drawing.
@property (strong, readonly, nonatomic) TMGLEngine *engine;

/// The view with which to display the content of the \c engine.
@property (nonatomic, strong) GLKView *glkView;

/// Internal book keeping for current panning offset.
@property (nonatomic) CGPoint panOffset;

/// Internal book keeping for current panning offset resulting by zooming off center.
@property (nonatomic) CGPoint zoomPanOffset;

/// Internal book keeping for current zoom scale.
@property (nonatomic) CGFloat zoomScale;

/// Loading indicator used when loading images to or from the view.
@property (strong, nonatomic) TMActivityIndicator *loadingIndicator;

/// Flag determining whether the internal engine's full draw cycle needs to be called
@property (nonatomic) BOOL needsRedraw;

@end

@implementation TMGLViewController

static const float kMaxZoomScale = 3;
static const float kMinZoomScale = 0.2;

- (instancetype)initWithEngine:(TMGLEngine *)engine {
  if (!engine) {
    return nil;
  }
  
  if (self = [super init]) {
    _engine = engine;
    self.zoomScale = 1;
  }
  return self;
}

- (void)setupGLKView {
  self.glkView = [[GLKView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.glkView];
  self.glkView.delegate = self;
  self.glkView.context = [EAGLContext currentContext];
  NSLog(@"context set");
}

- (void)viewDidAppear:(BOOL)animated {
  NSLog(@"view did apear");
  if (!self.glkView) {
    [self setupGLKView];
    [self enableScrolling];
    [self.engine outputBuffer:[[TMGLScreenRenderBuffer alloc] initWithGLKView:self.glkView]];
  }
  
  if (!self.loadingIndicator) {
    self.loadingIndicator = [[TMActivityIndicator alloc] initWithView:self.view];
  }
  
  [self.glkView setNeedsDisplay];
}

- (void)loadImage:(UIImage *)image
completionHandler:(TMErrorBlock)completionHandler {
  [self.loadingIndicator start];
  
  [self.engine loadImage:image completionHandler:^(NSError *error) {
    NSLog(@"load image completion block, error:%@", error);
    if (!error) {
      self.zoomScale = 1;
      self.panOffset = CGPointMake(0, 0);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"stopping animation");
      [self.loadingIndicator stop];
      self.needsRedraw = YES;
      [self.glkView setNeedsDisplay];
      completionHandler(error);
    });
  }];
  
  return;
}

- (void)imageFromWorkspaceWithCompletionHandler:(TMImageErrorBlock)completionHandler {
  [self.loadingIndicator start];
  [self.engine imageFromWorkspaceWithCompletionHandler:^(UIImage * __nullable image,
                                                         NSError * __nullable error){
    [self.loadingIndicator stop];
    completionHandler(image, error);
  }];
}

#pragma mark -
#pragma mark GLKViewDelegate
#pragma mark -

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self.engine draw];
}

#pragma mark -
#pragma mark Scrolling
#pragma mark -

- (void)enableScrolling {
  [self.glkView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                           action:@selector(panGesture:)]];
  [self.glkView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self
                          action:@selector(pinchGesture:)]];
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
  CGPoint panOffset =
    [self pointFromPoint:[self normalizedTranslation:[gestureRecognizer translationInView:self.view]]
               plusPoint:self.panOffset];
  
  [self.engine panOffset:panOffset andZoomScale:self.zoomScale];
  
  [self.glkView setNeedsDisplay];
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    self.panOffset = panOffset;
    self.zoomPanOffset = self.panOffset;
  }
}

- (CGPoint)normalizedTranslation:(CGPoint)translation {
  CGFloat xRatio = (translation.x / self.view.bounds.size.width) * 2;
  CGFloat yRatio = (translation.y / self.view.bounds.size.height) * 2;
  return CGPointMake(xRatio, -yRatio);
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
  CGFloat newZoomScale = [self clampedScale:self.zoomScale + ([gestureRecognizer scale] - 1)];
  
  // Calculate and save pinch location relative to image center
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
    self.zoomPanOffset =
      [self pointFromPoint:self.panOffset minusPoint:
        [self normalizedTranslation:
          [self pointFromPoint:[gestureRecognizer locationInView:self.view]
                    minusPoint:CGPointMake(self.view.bounds.size.width / 2,
                                           self.view.bounds.size.height / 2)]]];
  }
  
  // Calculate pan correction required 
  CGPoint panCorrection =
    [self pointFromPoint:CGPointApplyAffineTransform(self.zoomPanOffset,
      CGAffineTransformMakeScale(newZoomScale - self.zoomScale, newZoomScale - self.zoomScale))
               plusPoint:self.panOffset];
  
  [self.engine panOffset:panCorrection andZoomScale:newZoomScale];
  [self.glkView setNeedsDisplay];
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    self.zoomScale = newZoomScale;
    self.panOffset = panCorrection;
  }
}

#pragma mark -
#pragma mark CGPoint operations
#pragma mark -

- (CGPoint) pointFromPoint:(CGPoint)point1 minusPoint:(CGPoint)point2 {
  return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

- (CGPoint) pointFromPoint:(CGPoint)point1 plusPoint:(CGPoint)point2 {
  return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

- (CGFloat)clampedScale:(CGFloat)scale {
  return MIN(kMaxZoomScale, MAX(kMinZoomScale, scale));
}

@end

NS_ASSUME_NONNULL_END












