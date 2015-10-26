// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLFeatureManagerViewController.h"

#import "TMGLEngine.h"
#import "TMGLViewController.h"

NS_ASSUME_NONNULL_BEGIN

static const int kFeatureControlsHeight = 100;
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
  [self inflateFeatureControls];
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

- (void)inflateFeatureControls {
  CGRect controlRect = CGRectMake(0, self.view.bounds.size.height - kFeatureControlsHeight,
                                  self.view.bounds.size.width, kFeatureControlsHeight);
  [self.view addSubview:[self.feature controlsWithFrame:controlRect]];
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
