// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import "TMGLFilter.h"

@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

/// \c TMToneAdjustFilter enables basic adjustments for tone mapping.
@interface TMGLToneAdjustFilter : NSObject <TMGLFilter>

/// Set base initializer as unavilable.
- (instancetype)init NS_UNAVAILABLE;

/// Initializer method for \c TMToneAdjustFilter object, with \c drawer as its drawing manager.
/// All parameters are initialized to their default values.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer
    NS_DESIGNATED_INITIALIZER;

/// Brightness value, capped at [0, 1] sets the \c TMToneAdjustFilter's brightness level to
/// \c brightness. Defaults at 0.5.
@property (nonatomic) float brightness;

/// Global contrast value, capped at [0, 1] sets the \c TMToneAdjustFilter's Global contrast level
/// to \c globalContrast. Defaults at 0.25.
@property (nonatomic) float globalContrast;

/// Saturation value, capped at [0, 1] sets the \c TMToneAdjustFilter's saturation level to
/// \c saturation. Defaults at 0.25.
@property (nonatomic) float saturation;

/// Tint value, capped at [0, 1] sets the \c TMToneAdjustFilter's tint level to \c tint.
/// Defaults at 0.5.
@property (nonatomic) float tint;

/// Temprature value, capped at [0, 1] sets the \c TMToneAdjustFilter's temprature level to
/// \c temprature. Defaults at 0.5.
@property (nonatomic) float temprature;

@end

NS_ASSUME_NONNULL_END
