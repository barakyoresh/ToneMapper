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

/// Internal book keeping for current panning offset resulting by zooming off center.
@property (nonatomic) CGPoint zoomPanOffset;

/// Loading indicator used when loading images to or from the view.
@property (nonatomic, strong) TMActivityIndicator *loadingIndicator;

@end

@implementation TMGLViewController

- (instancetype)initWithEngine:(TMGLEngine *)engine {
  if (self = [super init]) {
    _engine = engine;

  }
  return self;
}

- (void)viewDidLoad {
  [self setupGLKView];
  self.loadingIndicator = [[TMActivityIndicator alloc] initWithView:self.view];
  [self enableScrolling];
}

- (void)setupGLKView {
  self.glkView = [[GLKView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.glkView];
  self.glkView.delegate = self;
  self.glkView.context = [EAGLContext currentContext];
  NSLog(@"context set");
}

- (void)viewDidAppear:(BOOL)animated {
  self.engine.outputBuffer = [[TMGLScreenRenderBuffer alloc] initWithGLKView:self.glkView];
  [self.glkView setNeedsDisplay];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  self.glkView.frame =
      CGRectMake(self.glkView.frame.origin.x, self.glkView.frame.origin.y, size.width, size.height);
  self.engine.outputBuffer = [[TMGLScreenRenderBuffer alloc] initWithGLKView:self.glkView];
  [self.glkView setNeedsDisplay];
}

- (void)loadImage:(UIImage *)image
completionHandler:(TMErrorBlock)completionHandler {
  [self.loadingIndicator start];
  
  [self.engine loadImage:image completionHandler:^(NSError *error) {
    NSLog(@"load image completion block, error:%@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"stopping animation");
      [self.loadingIndicator stop];
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

- (void)glSetNeedsDisplay {
  [self.glkView setNeedsDisplay];
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
  [self.engine panOffset:[self normalizedTranslation:[gestureRecognizer
                                                      translationInView:self.view]]
                   ended:([gestureRecognizer state] == UIGestureRecognizerStateEnded)];
  [self.glkView setNeedsDisplay];
}

- (CGPoint)normalizedTranslation:(CGPoint)translation {
  CGFloat xRatio = (translation.x / self.view.bounds.size.width) * 2;
  CGFloat yRatio = (translation.y / self.view.bounds.size.height) * 2;
  return CGPointMake(xRatio, -yRatio);
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
  // Calculate and save pinch location relative to image center
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
    self.zoomPanOffset = [self normalizedTranslation:
                                [self pointFromPoint:[gestureRecognizer locationInView:self.view]
                                          minusPoint:CGPointMake(self.view.bounds.size.width / 2,
                                                                self.view.bounds.size.height / 2)]];
  }
  
  [self.engine zoomScaleOffset:([gestureRecognizer scale] - 1) focalPoint:self.zoomPanOffset
                         ended:([gestureRecognizer state] == UIGestureRecognizerStateEnded)];
  
  [self.glkView setNeedsDisplay];
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

@end

NS_ASSUME_NONNULL_END
