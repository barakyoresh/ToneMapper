// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLFeatureManagerViewController.h"

#import "TMGLEngine.h"
#import "TMGLViewController.h"
#import "TMFeature.h"

NS_ASSUME_NONNULL_BEGIN

static const int kNavigationBarHeight = 44;
static const int kFeatureControlsHeight = 150;
static NSString * const kCancelLabel = @"X";
static NSString * const kAcceptLabel = @"√";


@interface TMGLFeatureManagerViewController()

/// The \c TMGLEngine object used to handle image editing and drawing.
@property (strong, nonatomic) TMGLEngine *engine;

@property (strong, nonatomic) id<TMFeature> feature;

@end

@implementation TMGLFeatureManagerViewController

- (instancetype)initWithEngine:(TMGLEngine * __nonnull)engine andFeature:(id<TMFeature>)feature {
  if (self = [super init]) {
    _engine = engine;
    _feature = feature;
  }
  return self;
}

- (void)viewDidLoad {
  [self.view setBackgroundColor:[UIColor clearColor]];
  [self addTMGLVC];
  [self addNavigationBar];
  [self inflateFeatureControls];
}

- (void)addTMGLVC {
  TMGLViewController *TMGLviewController = [[TMGLViewController alloc] initWithEngine:self.engine];
  [self addChildViewController:TMGLviewController];
  [self.view addSubview:TMGLviewController.view];
  [TMGLviewController didMoveToParentViewController:self];
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
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)accept {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Feature controls
#pragma mark -

- (void)inflateFeatureControls {
  CGRect controlRect = CGRectMake(0, self.view.bounds.size.height - kFeatureControlsHeight,
                                  self.view.bounds.size.width, kFeatureControlsHeight);
  [self.view addSubview:[self.feature controlsWithRect:controlRect]];
}

@end

NS_ASSUME_NONNULL_END
