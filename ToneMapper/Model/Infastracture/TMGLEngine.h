// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLProgramParameters.h"

#import <Foundation/Foundation.h>

#import "TMTypes.h"

@protocol TMGLBuffer, TMGLFilter;
@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

/// A Wrapper to the opengl framework enabling easy usage of it via \c TMGLProgramParameters objects
/// that encapsulate all there is to an opengl program.
/// Textures are handled internally and and all programs that use textures will have the workspace
/// texture bound internally before using them to draw.
@interface TMGLEngine : NSObject

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Designated initializer for \c TMGLEngine, requires \c TMGLDrawer object to be injected and used
/// for future drawing.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer NS_DESIGNATED_INITIALIZER;

/// Loads \c UIImage to be set as the new workspace asynchronously. Upon completion
/// \c completionHandler will be called with \c error will be filled appropriately in case of an
/// error and nil otherwise.
- (void)loadImage:(UIImage *)image completionHandler:(TMErrorBlock)completionHandler;

/// Request for the current workspace as a \c UIImage. Upon completion \c completionHandler will be
/// called with \c image as the workspace image or nil upon error. Incase of an error \c error will
/// be filled with an appropriate error value.
- (void)imageFromWorkspaceWithCompletionHandler:(TMImageErrorBlock)completionHandler;

/// Applies \c filter on the current workspace state texture, causing the current output texture
/// to be the filtered version of the current workspace state.
- (void)useFilter:(id<TMGLFilter>)filter;

/// Draws the internal workspace state to the output buffer specified by \c outputBuffer method.
- (void)draw;

/// Adjust the pan offset and zoom scale of the displayed workspace to \c offset and \c scale
/// respectively. This automatically calls \c draw internally for performace reasons.
- (void)panOffset:(CGPoint)offset andZoomScale:(float)scale;

/// Determines the output buffer of the engine's subsequent draws as \c outputBuffer.
/// \c outputBuffer's size property will also determine the aspect ratio correction made from image
/// size to display.
@property (strong, nonatomic) id<TMGLBuffer> outputBuffer;

@end

NS_ASSUME_NONNULL_END
