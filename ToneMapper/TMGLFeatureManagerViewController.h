// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

@class TMGLEngine;
@protocol TMFeature;

NS_ASSUME_NONNULL_BEGIN

/// Generic Feature view controller enabling canceling and saving of feature parameters.
@interface TMGLFeatureManagerViewController : UIViewController

/// Initializer recieving \c TMGLEngine object as it's core buisiness logic interface.
- (instancetype)initWithEngine:(TMGLEngine *)engine andFeature:(id<TMFeature>)feature
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
