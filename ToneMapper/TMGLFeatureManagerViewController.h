// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

#import "TMFeature.h"

@class TMGLEngine;

NS_ASSUME_NONNULL_BEGIN

/// Generic Feature view controller enabling canceling and saving of feature parameters.
@interface TMGLFeatureManagerViewController : UIViewController

/// Setting super initializers to unavailable.
- (instancetype)initWithCoder:(NSCoder * __nullable)aDecoder NS_UNAVAILABLE;

/// Setting super initializers to unavailable.
- (instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil
                         bundle:(NSBundle * __nullable)nibBundleOrNil NS_UNAVAILABLE;

/// Initializer recieving \c TMGLEngine object as it's core buisiness logic interface.
- (instancetype)initWithEngine:(TMGLEngine *)engine andFeature:(id<TMFeature>)feature
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
