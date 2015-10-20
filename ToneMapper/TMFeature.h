// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

@class TMGLEngine;
@protocol TMGLFilter;

NS_ASSUME_NONNULL_BEGIN

/// Protocol for \c TMFeature delegates, requiring them to be able to apply a given \c TMGLfilter
/// determined by the \c TMFeature's controls.
@protocol TMFeatureDelegate <NSObject>

/// Apply \c filter on the current workspace.
- (void)applyFilter:(id<TMGLFilter>)filter;

@end

/// Protocol for ToneMapper features. A feature will interact directly with the supplied engine in
/// order to create the desired effect.
@protocol TMFeature <NSObject>

/// Return this \c TMFeature's controls, determinig the outcome of future calls to be made to this
/// feature's delegate.
/// \c TMFeature must be retained while the return value of \c controlsWithRect are displayed.
- (UIView *)controlsWithRect:(CGRect)rect;

/// \c TMFeatureDelegate object to recieve calls to \c applyFilter when this filter sees fit.
@property (strong, nonatomic) id<TMFeatureDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
