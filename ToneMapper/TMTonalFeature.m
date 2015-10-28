// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMGLToneAdjustFilter.h"
#import "TMGLBilateralFilter.h"
#import "TMGLTexture.h"

#import "TMTonalFeature.h"

NS_ASSUME_NONNULL_BEGIN

static const float kControlsHeight = 80.0;
static const uint kSmoothKernelSize = 19;
static const uint kSmootherKernelSize = 37;
static NSString * const kBrightnessLabel = @"Brightness";
static NSString * const kContrastLabel = @"Contrast";
static NSString * const kSaturationLabel = @"Saturation";
static NSString * const kTintLabel = @"Tint";
static NSString * const kTempratureLabel = @"Temprature";
static const int kBrightnessSegment = 0;
static const int kContrastSegment = 1;
static const int kSaturationSegment = 2;
static const int kTintSegment = 3;
static const int kTempratureSegment = 4;
static NSString * const kBackLabel = @"⏎";
static NSString * const kGlobalContrastLabel = @"Global";
static NSString * const kMediumContrastLabel = @"Medium";
static NSString * const kFineContrastLabel = @"Fine";
static const int kBackSubSegment = 0;
static const int kGlobalContrastSubSegment = 1;
static const int kMediumContrastSubSegment = 2;
static const int kFineContrastSubSegment = 3;

@interface TMTonalFeature()

/// Refernce to the feature's control scheme, defined by the filter.
@property (strong, nonatomic) UIView *controls;

/// Reference to the feature's filter object, altered by the controls.
@property (strong, readonly, nonatomic) TMGLToneAdjustFilter *tonalFilter;

/// Reference to the feature's filter object, altered by the controls.
@property (strong, readonly, nonatomic) TMGLBilateralFilter *bilateralFilter;

/// Input texture reference, required for fine a medium contrast by internally applying a
/// \c TMGLBilateralFilter on it and extractig a localy-smoothed version of the input.
@property (strong, readonly, nonatomic) TMGLTexture *inputTexture;

/// \c UISlider object to used to alter filter values.
@property (strong, nonatomic) UISlider *slider;

/// \c UISegmentedControl object used to select filter operations to alter.
@property (strong, nonatomic) UISegmentedControl *operatorOptions;

/// \c UISegmentedControl object used to select advanced filter operations to alter.
@property (strong, nonatomic) UISegmentedControl *advancedContrastOperatorOptions;

@end

@implementation TMTonalFeature

@synthesize delegate = _delegate;

- (instancetype)initWithDrawer:(TMGLDrawer *)drawer andInputTexture:(TMGLTexture *)inputTexture {
  if (!drawer || !inputTexture) {
    return nil;
  }
  
  if (self = [super init]) {
      _inputTexture = inputTexture;
      _bilateralFilter = [[TMGLBilateralFilter alloc] initWithDrawer:drawer];
      self.bilateralFilter.kernelSize = kSmoothKernelSize;
      TMGLTexture *smoothTexture = [self.bilateralFilter applyOnTexture:inputTexture];
      self.bilateralFilter.kernelSize = kSmoothKernelSize;
      TMGLTexture *smootherTexture = [self.bilateralFilter applyOnTexture:smoothTexture];
      _tonalFilter = [[TMGLToneAdjustFilter alloc] initWithDrawer:drawer smoothTexture:smoothTexture
                                               andSmootherTexture:smootherTexture];
    if (!self.tonalFilter) {
      return nil;
    }
  }
  return self;
}

- (UIView *)controlsWithFrame:(CGRect)rect {
  if (rect.size.height < kControlsHeight) {
    NSLog(@"unable to inflate controls for height:%f, must be larger than %f", rect.size.height,
          kControlsHeight);
    return nil;
  }
  CGRect controlsRect =
      CGRectMake(0, rect.size.height - (kControlsHeight), rect.size.width, kControlsHeight);
  
  UIView *view = [[UIView alloc] initWithFrame:controlsRect];
  
  self.slider = [self setupSliderWithFrame:controlsRect];
  self.operatorOptions = [self setupOperatorOptionWithFrame:controlsRect];
  self.advancedContrastOperatorOptions =
      [self setupAdvancedContrastOperatorOptionWithFrame:controlsRect];
  
  [view addSubview:self.advancedContrastOperatorOptions];
  [view addSubview:self.operatorOptions];
  [view addSubview:self.slider];
  self.controls = view;
  return view;
}

- (UISlider *)setupSliderWithFrame:(CGRect)rect {
  UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0,  rect.size.width,
                                                                (rect.size.height / 2))];
  [slider addTarget:self action:@selector(sliderValueChanged:)
        forControlEvents:UIControlEventValueChanged];
  return slider;
}

- (UISegmentedControl *)setupOperatorOptionWithFrame:(CGRect)rect {
  UISegmentedControl *operatorOptions =
      [[UISegmentedControl alloc] initWithItems:@[kBrightnessLabel, kContrastLabel,
                                                  kSaturationLabel, kTintLabel, kTempratureLabel]];
  [operatorOptions addTarget:self action:@selector(toneOptionsValueChanged:)
            forControlEvents:UIControlEventValueChanged];
  [operatorOptions setSelectedSegmentIndex:0];
  [self toneOptionsValueChanged:operatorOptions];
  
  operatorOptions.frame =
      CGRectMake(0, rect.size.height / 2, rect.size.width, rect.size.height / 2);

  return operatorOptions;
}

- (UISegmentedControl *)setupAdvancedContrastOperatorOptionWithFrame:(CGRect)rect {
  UISegmentedControl *advancedOperatorOptions = [[UISegmentedControl alloc]
                                         initWithItems:@[kBackLabel, kGlobalContrastLabel,
                                                         kMediumContrastLabel, kFineContrastLabel]];
  [advancedOperatorOptions addTarget:self action:@selector(toneOptionsValueChanged:)
            forControlEvents:UIControlEventValueChanged];
  [advancedOperatorOptions setSelectedSegmentIndex:0];
  [self toneOptionsValueChanged:advancedOperatorOptions];
  advancedOperatorOptions.frame =
  CGRectMake(0, rect.size.height / 2, rect.size.width, rect.size.height / 2);
  
  [advancedOperatorOptions setSelectedSegmentIndex:1];
  [advancedOperatorOptions setHidden:YES];
  return advancedOperatorOptions;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
  switch (self.operatorOptions.selectedSegmentIndex) {
    case kBrightnessSegment:
      self.tonalFilter.brightness = sender.value;
      break;
    case kContrastSegment:
      switch (self.advancedContrastOperatorOptions.selectedSegmentIndex) {
        case kGlobalContrastSubSegment:
          self.tonalFilter.globalContrast = sender.value;
          break;
        case kMediumContrastSubSegment:
          self.tonalFilter.mediumContrast = sender.value;
          break;
        case kFineContrastSubSegment:
          self.tonalFilter.fineContrast = sender.value;
          break;
        default:
          break;
      }
      break;
    case kSaturationSegment:
      self.tonalFilter.saturation = sender.value;
      break;
    case kTintSegment:
      self.tonalFilter.tint = sender.value;
      break;
    case kTempratureSegment:
      self.tonalFilter.temprature = sender.value;
      break;
    default:
      break;
  }
  [self updateFilter];
}

- (IBAction)toneOptionsValueChanged:(UISegmentedControl *)sender {
  [self.advancedContrastOperatorOptions setHidden:YES];
  [self.operatorOptions setHidden:NO];
  switch (self.operatorOptions.selectedSegmentIndex) {
    case kBrightnessSegment:
      [self.slider setValue:self.tonalFilter.brightness];
      break;
    case kContrastSegment:
      [self.advancedContrastOperatorOptions setHidden:NO];
      [self.operatorOptions setHidden:YES];
      switch (self.advancedContrastOperatorOptions.selectedSegmentIndex) {
        case kBackSubSegment:
          [self.advancedContrastOperatorOptions setSelectedSegmentIndex:1];
          [self.operatorOptions setSelectedSegmentIndex:kBrightnessSegment];
          [self toneOptionsValueChanged:self.operatorOptions];
          break;
        case kGlobalContrastSubSegment:
          [self.slider setValue:self.tonalFilter.globalContrast];
          break;
        case kMediumContrastSubSegment:
          [self.slider setValue:self.tonalFilter.mediumContrast];
          break;
        case kFineContrastSubSegment:
          [self.slider setValue:self.tonalFilter.fineContrast];
          break;
        default:
          break;
      }
      break;
    case kSaturationSegment:
      [self.slider setValue:self.tonalFilter.saturation];
      break;
    case kTintSegment:
      [self.slider setValue:self.tonalFilter.tint];
      break;
    case kTempratureSegment:
      [self.slider setValue:self.tonalFilter.temprature];
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
  [self.delegate applyFilter:self.tonalFilter];
}

@end

NS_ASSUME_NONNULL_END
