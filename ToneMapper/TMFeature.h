// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

@class TMGLEngine;
@protocol TMGLFilter;

NS_ASSUME_NONNULL_BEGIN

/// Protocol for \c TMFeature delegates, requiring them to be able to apply a given \c TMGLfilter
/// determined by the \c TMFeature's controls.
/// The feature supplies controls and calls delegate methods in order to apply filters on the
/// opengl enviornment. The feature is incharge of creating controls and translating them into an
/// appropriate \c TMGLFilter object.
@protocol TMFeatureDelegate <NSObject>

/// Apply \c filter on the current workspace. The feature must call this delegate method whenever
/// a re-rendering of the workspace is required - i.e. when the controls were altered in a way that
/// requires for a reaplication of the filter.
- (void)applyFilter:(id<TMGLFilter>)filter;

@end

/// Protocol for ToneMapper features. A feature will interact directly with the supplied engine in
/// order to create the desired effect.
@protocol TMFeature <NSObject>

/// Return this \c TMFeature's controls, determinig the outcome of future calls to be made to this
/// feature's delegate.
/// \c TMFeature must be retained while the return value of \c controlsWithRect are displayed.
/// The given frame \c rect represents the available space of the entire workspace, and
/// \c controlsWithFrame must return a view with it's \c frame property matching the desired
/// location of the controls.
- (UIView *)controlsWithFrame:(CGRect)rect;

/// \c TMFeatureDelegate object to recieve calls to \c applyFilter when this filter sees fit.
@property (weak, nonatomic) id<TMFeatureDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
