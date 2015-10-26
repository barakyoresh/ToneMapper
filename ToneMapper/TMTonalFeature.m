// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLToneAdjustFilter.h"

#import "TMTonalFeature.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kBrightnessLabel = @"Brightness";
static NSString * const kContrastLabel = @"Contrast";
static NSString * const kSaturationLabel = @"Saturation";
static NSString * const kTintLabel = @"Tint";
static NSString * const kTempratureLabel = @"Temprature";
static const int kBrightnessSegment = 0;
static const int kGlobalContrastSegment = 1;
static const int kSaturationSegment = 2;
static const int kTintSegment = 3;
static const int kTempratureSegment = 4;

@interface TMTonalFeature()

/// Refernce to the feature's control scheme, defined by the filter.
@property (strong, nonatomic) UIView *controls;

/// Reference to the feature's filter object, altered by the controls.
@property (strong, readonly, nonatomic) TMGLToneAdjustFilter *filter;

/// \c UISlider object to used to alter filter values.
@property (strong, nonatomic) UISlider *slider;

/// \c UISegmentedControl object used to select filter operations to alter.
@property (strong, nonatomic) UISegmentedControl *operatorOptions;

@end

@implementation TMTonalFeature

@synthesize delegate = _delegate;

- (instancetype)initWithDrawer:(TMGLDrawer *)drawer {
  if (!drawer) {
    return nil;
  }
  
  if (self = [super init]) {
    _filter = [[TMGLToneAdjustFilter alloc] initWithDrawer:drawer];
  }
  return self;
}

- (UIView *)controlsWithFrame:(CGRect)rect {
  UIView *view = [[UIView alloc] initWithFrame:rect];
  self.slider =
      [[UISlider alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, (rect.size.height / 2))];
  [self.slider addTarget:self action:@selector(sliderValueChanged:)
      forControlEvents:UIControlEventValueChanged];
  
  self.operatorOptions = [[UISegmentedControl alloc]
      initWithItems:@[kBrightnessLabel, kContrastLabel, kSaturationLabel, kTintLabel,
                      kTempratureLabel]];
  [self.operatorOptions addTarget:self action:@selector(toneOptionsValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
  [self.operatorOptions setSelectedSegmentIndex:0];
  [self toneOptionsValueChanged:self.operatorOptions];
  
  self.operatorOptions.frame = CGRectMake(0, rect.size.height / 2, rect.size.width,
                                          rect.size.height / 2);

  [view addSubview:self.operatorOptions];
  [view addSubview:self.slider];
  self.controls = view;
  return view;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
  NSLog(@"slider value = %f, currently selected segment = %lu", sender.value,
        self.operatorOptions.selectedSegmentIndex);
  switch (self.operatorOptions.selectedSegmentIndex) {
    case kBrightnessSegment:
      self.filter.brightness = sender.value;
      break;
    case kGlobalContrastSegment:
      self.filter.globalContrast = sender.value;
      break;
    case kSaturationSegment:
      self.filter.saturation = sender.value;
      break;
    case kTintSegment:
      self.filter.tint = sender.value;
      break;
    case kTempratureSegment:
      self.filter.temprature = sender.value;
      break;
    default:
      break;
  }
  [self updateFilter];
}

- (IBAction)toneOptionsValueChanged:(UISegmentedControl *)sender {
  NSLog(@"selected segment = %lu", sender.selectedSegmentIndex);
  switch (sender.selectedSegmentIndex) {
    case kBrightnessSegment:
      [self.slider setValue:self.filter.brightness];
      break;
    case kGlobalContrastSegment:
      [self.slider setValue:self.filter.globalContrast];
      break;
    case kSaturationSegment:
      [self.slider setValue:self.filter.saturation];
      break;
    case kTintSegment:
      [self.slider setValue:self.filter.tint];
      break;
    case kTempratureSegment:
      [self.slider setValue:self.filter.temprature];
      break;
    default:
      [self.slider setValue:0];
      break;
  }
}

- (void)setDelegate:(id<TMFeatureDelegate>)delegate {
  _delegate = delegate;
  [self updateFilter];
}

- (void)updateFilter {
  [self.delegate applyFilter:self.filter];
}

@end

NS_ASSUME_NONNULL_END
