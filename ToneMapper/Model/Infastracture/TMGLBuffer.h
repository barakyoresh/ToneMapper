// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Protocol wrapping a generalization of opengl frame and render buffer objects.
/// This object symbolizes somthing that can be bound via \c bind method in order for future draw
/// operations to act upon it.
@protocol TMGLBuffer <NSObject>

/// The size associated with this buffer object.
@property (nonatomic, readonly) CGSize size;

/// Binds this buffer object in the opengl interface so that future draw operations will be result
/// in drawing to it.
- (void)bind;

@end

NS_ASSUME_NONNULL_END
