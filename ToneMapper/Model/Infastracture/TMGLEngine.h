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
/// Texture 0 is set by the engine to be the input texture image.
- (void)loadImage:(UIImage *)image completionHandler:(TMErrorBlock)completionHandler;

/// Request for the current workspace as a \c UIImage. Upon completion \c completionHandler will be
/// called with \c image as the workspace image or nil upon error. Incase of an error \c error will
/// be filled with an appropriate error value.
- (void)imageFromWorkspaceWithCompletionHandler:(TMImageErrorBlock)completionHandler;

/// Applies \c filter on the current workspace state texture, causing the current output texture
/// drawn on the output buffer to be the filtered version of the current workspace state.
- (void)applyFilter:(id<TMGLFilter>)filter;

/// Draws the internal workspace state to the output buffer specified by \c outputBuffer method.
- (void)draw;

/// Removes the currently applied \c TMGLFilter object and returns to the previous state.
- (void)cancelFilter;

/// Removes the currently applied \c TMGLFilter object and sets the default texture to it's output.
- (void)acceptFilter;

/// Adjust the pan offset and of the displayed workspace by \c offset. pass \c YES to \c ended if
// the offset is reseted and the current value should be falttened and stored.
- (void)panOffset:(CGPoint)offset ended:(BOOL)ended;

/// Adjust the zoom scale offset and of the displayed workspace by \c offset. pass \c YES to
/// \c ended if the offset is reseted and the current value should be falttened and stored.
/// \c panOffset is the center of the zoom gesture, used to make the zoom's focal point in that
/// point.
- (void)zoomScaleOffset:(CGFloat)offset focalPoint:(CGPoint)focalPoint ended:(BOOL)ended;

/// Determines the output buffer of the engine's subsequent draws as \c outputBuffer.
/// \c outputBuffer's size property will also determine the aspect ratio correction made from image
/// size to display.
@property (strong, nonatomic) id<TMGLBuffer> outputBuffer;

@end

NS_ASSUME_NONNULL_END
