// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>

#import "TMGLProgramParameters.h"
#import "TMTypes.h"

@class TMGLEngine;

NS_ASSUME_NONNULL_BEGIN

/// View controller handling all displaying, controlling and editing of images.
/// The \c TMGLViewController also handles panning and zooming internally.
@interface TMGLViewController : UIViewController <GLKViewDelegate>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Set super initializers as unavilable.
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/// Set super initializers as unavilable.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
    NS_UNAVAILABLE;

/// Initializer recieving \c TMGLEngine object as it's core buisiness logic interface.
- (instancetype)initWithEngine:(TMGLEngine *)engine NS_DESIGNATED_INITIALIZER;

/// Loads \c UIImage to be displayed in the view asynchronously. Upon completion
/// \c completionHandler will be called with \c error will be filled appropriately in case of an
/// error and nil otherwise.
- (void)loadImage:(UIImage *)image completionHandler:(TMErrorBlock)completionHandler;

/// Request for the currently edited version of the image displayed in this view controller's view while
/// ignoring current zoom and pan state. Upon completion \c completionHandler will be
/// called with \c image as the edited image or nil upon error. Incase of an error \c error will
/// be filled with an appropriate error value.
- (void)imageFromWorkspaceWithCompletionHandler:(TMImageErrorBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
