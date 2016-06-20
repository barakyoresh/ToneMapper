// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLFeatureManagerViewController.h"

#import "TMGLEngine.h"
#import "TMGLViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCancelLabel = @"X";
static NSString * const kAcceptLabel = @"√";

@interface TMGLFeatureManagerViewController() <TMFeatureDelegate>

/// The \c TMGLEngine object used to handle image editing and drawing.
@property (strong, readonly, nonatomic) TMGLEngine *engine;

/// \c TMFeature object to be inflated as the feature manager's current logic handler, supplying
/// the controls and calling \c TMGLFeatureManagerViewController's \c TMGLFeatureDelegate methods.
@property (strong, readonly, nonatomic) id<TMFeature> feature;

/// Internally managed \c TMGLViewController to display the \c TMGLEngine's workspace.
@property (strong, nonatomic) TMGLViewController *glViewController;

@property (strong, nonatomic) UIView *featureControlsContainer;

@end

@implementation TMGLFeatureManagerViewController

- (instancetype)initWithEngine:(TMGLEngine *)engine andFeature:(id<TMFeature>)feature {
  if (self = [super init]) {
    _engine = engine;
    _feature = feature;
    self.feature.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [self.view setBackgroundColor:[UIColor clearColor]];
  [self addTMGLviewController];
  [self configureNavigationBar];
  [self inflateFeatureControlsInFrame:CGRectMake(0,
      self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width,
      self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height)];
}

- (void)addTMGLviewController {
  self.glViewController = [[TMGLViewController alloc] initWithEngine:self.engine];
  [self addChildViewController:self.glViewController];
  [self.view addSubview:self.glViewController.view];
  [self.glViewController didMoveToParentViewController:self];
}

#pragma mark -
#pragma mark Navigation bar
#pragma mark -

- (void)configureNavigationBar {
  UIBarButtonItem *cancelButton =
      [[UIBarButtonItem alloc] initWithTitle:kCancelLabel style:UIBarButtonItemStylePlain
                                      target:self action:@selector(cancel)];
  UIBarButtonItem *acceptButton =
      [[UIBarButtonItem alloc] initWithTitle:kAcceptLabel style:UIBarButtonItemStylePlain
                                      target:self action:@selector(accept)];
  [self.navigationItem setRightBarButtonItem:acceptButton];
  [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void)cancel {
  [self.engine cancelFilter];
  [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)accept {
  [self.engine acceptFilter];
  [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark Feature controls
#pragma mark -

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [self inflateFeatureControlsInFrame:CGRectMake(0,
      self.navigationController.navigationBar.bounds.size.height, size.width,
      size.height - self.navigationController.navigationBar.bounds.size.height)];
}

- (void)inflateFeatureControlsInFrame:(CGRect)rect {
  [self.featureControlsContainer removeFromSuperview];
  UIView *featureControls = [self.feature controlsWithFrame:rect];
  self.featureControlsContainer =
      [[UIView alloc] initWithFrame:CGRectMake(featureControls.frame.origin.x,
                                               featureControls.frame.origin.y + self.navigationController.navigationBar.bounds.size.height,
                                               featureControls.frame.size.width,
                                               featureControls.frame.size.height)];
  featureControls.frame = featureControls.bounds;
  [self.featureControlsContainer addSubview:featureControls];
  [self.view addSubview:self.featureControlsContainer];
}

#pragma mark -
#pragma mark TMFeatureDelegate
#pragma mark -

- (void)applyFilter:(id<TMGLFilter>)filter {
  [self.engine applyFilter:filter];
  [self.self.glViewController glSetNeedsDisplay];
}

@end

NS_ASSUME_NONNULL_END
