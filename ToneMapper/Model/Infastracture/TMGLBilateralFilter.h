// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>

#import "TMGLFilter.h"

@class TMGLDrawer;

NS_ASSUME_NONNULL_BEGIN

@interface TMGLBilateralFilter : NSObject <TMGLFilter>

/// Mark default initializer as unavailable.
- (instancetype)init NS_UNAVAILABLE;

/// Designated Initializer requiring \c TMGLDrawer object for processing.
- (instancetype)initWithDrawer:(TMGLDrawer *)drawer NS_DESIGNATED_INITIALIZER;

/// \c kernelSize describes the diameter of the kernel with which to do the bilateral filtering.
/// The minimum size is 7, and all values below it are mapped to it.
/// The sizes are in steps of 6, i.e. 7, 13, 19 etc. all values are mapped to the closest valid size
/// with the following formula:
/// @code
/// validKernelSize = (((kernelSize - 1) / 6) * 6) + 1
/// @endcode
@property (nonatomic) NSUInteger kernelSize;

@end

NS_ASSUME_NONNULL_END
