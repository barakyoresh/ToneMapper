// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Wrapper to \c UIActivityIndicatorView specific for the usage cases of ToneMapper
@interface TMActivityIndicator : NSObject

/// Initializer with \c view as the UIView to be displayed on.
- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

/// Start animation and show the activity indicator.
- (void)start;

/// Stop animation and hide the activity indicator.
- (void)stop;

@end

NS_ASSUME_NONNULL_END
