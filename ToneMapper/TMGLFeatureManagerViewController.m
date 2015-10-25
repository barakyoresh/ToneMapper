// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLFeatureManagerViewController.h"

#import "TMGLEngine.h"
#import "TMGLViewController.h"

NS_ASSUME_NONNULL_BEGIN

static const int kNavigationBarHeight = 44;
static const int kFeatureControlsHeight = 100;
static NSString * const kCancelLabel = @"X";
static NSString * const kAcceptLabel = @"√";

@interface TMGLFeatureManagerViewController()

/// The \c TMGLEngine object used to handle image editing and drawing.
@property (strong, readonly, nonatomic) TMGLEngine *engine;

/// \c TMFeature object to be inflated as the feature manager's current logic handler, supplying
/// the controls and calling \c TMGLFeatureManagerViewController's \c TMGLFeatureDelegate methods.
@property (strong, readonly, nonatomic) id<TMFeature> feature;

@property (strong, nonatomic) TMGLViewController *glViewController;

@end

@implementation TMGLFeatureManagerViewController

- (instancetype)initWithEngine:(TMGLEngine * __nonnull)engine andFeature:(id<TMFeature>)feature {
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
  [self addNavigationBar];
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

- (void)addNavigationBar {
  UINavigationBar *navigationBar = [[UINavigationBar alloc]
    initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kNavigationBarHeight)];
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancelLabel
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancel)];
  
  UIBarButtonItem *acceptButton = [[UIBarButtonItem alloc] initWithTitle:kAcceptLabel
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(accept)];
  
  UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
  [navigationItem setLeftBarButtonItem:cancelButton];
  [navigationItem setRightBarButtonItem:acceptButton];
  [navigationBar setItems:@[navigationItem]];
  [self.view addSubview:navigationBar];
}

- (void)cancel {
  [self.engine cancelFilter];
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)accept {
  [self.engine acceptFilter];
  [self dismissViewControllerAnimated:NO completion:nil];
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

- (void)applyFilter:(id<TMGLFilter> __nonnull)filter {
  [self.engine applyFilter:filter];
  [self.self.glViewController glSetNeedsDisplay];
}

@end

NS_ASSUME_NONNULL_END
