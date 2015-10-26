// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMActivityIndicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMActivityIndicator()

/// Internal \c UIActivityIndicatorView to wrap.
@property (weak, readonly, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation TMActivityIndicator

- (instancetype)initWithView:(UIView *)view {
  if (self = [super init]) {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = view.center;
    [view addSubview:indicator];
    [indicator bringSubviewToFront:view];
    _activityIndicator = indicator;
  }
  return self;
}

- (void)start {
  [self.activityIndicator startAnimating];
}

- (void)stop {
  [self.activityIndicator stopAnimating];
}

@end

NS_ASSUME_NONNULL_END
