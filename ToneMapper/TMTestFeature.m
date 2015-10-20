// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMTestFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTestFeature()

@property (strong, nonatomic) UIView *controls;

@end

@implementation TMTestFeature

@synthesize delegate = _delegate;

- (UIView *)controlsWithRect:(CGRect)rect {
  UIView *view = [[UIView alloc] initWithFrame:rect];
  UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(rect.origin.x, (rect.size.height / 2), rect.size.width, (rect.size.height / 2))];
  [slider setValue:0.3];
  [slider addTarget:self action:@selector(sliderValueChanged:)
   forControlEvents:UIControlEventValueChanged];
  [view addSubview:slider];
  self.controls = view;
  return view;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
  if (self.controls) {
    [self.controls setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:sender.value alpha:1]];
    [self.controls setNeedsDisplay];
  }
  NSLog(@"slider value = %f", sender.value);
}



@end

NS_ASSUME_NONNULL_END
