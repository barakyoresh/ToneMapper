// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "TMEditorViewController.h"

#import "TMGLViewController.h"
#import "TMGLDefaultShaderCompiler.h"
#import "TMGLCachedProgramCompiler.h"
#import "TMGLEngine.h"
#import "TMActivityIndicator.h"
#import "TMGLFeatureManagerViewController.h"
#import "TMTestFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMEditorViewController()

/// A View controller wrapping all the usage of the opengl enviorment via it's injected
/// \c TMGLEngine.
@property (nonatomic, strong) TMGLViewController *TMGLviewController;

/// Loading indicator used when loading images to or from the device memory.
@property (nonatomic, strong) TMActivityIndicator *loadingIndicator;

/// The \c TMGLEngine object used to handle image editing and drawing.
@property (strong, nonatomic) TMGLEngine *engine;

@end

@implementation TMEditorViewController

static NSString * const kAlertImageLoadFailure = @"Failed to load image.";
static NSString * const kAlertImageSaveFailure = @"Failed to save image.";
static NSString * const kAlertImageSaveSuccess = @"Image saved to gallery.";
static NSString * const kAlertDismissText = @"OK";

- (void)viewDidLoad {
  NSLog(@"editor loaded");
  self.engine = [[TMGLEngine alloc] initWithProgramCompiler:[[TMGLCachedProgramCompiler alloc]
                initWithShaderCompiler:[[TMGLDefaultShaderCompiler alloc] init]]];
  self.TMGLviewController = [[TMGLViewController alloc] initWithEngine:self.engine];
  [self addChildViewController:self.TMGLviewController];
  [self.view addSubview:self.TMGLviewController.view];
  [self.TMGLviewController didMoveToParentViewController:self];
  self.loadingIndicator = [[TMActivityIndicator alloc] initWithView:self.view];
}

#pragma mark -
#pragma mark Image import and export
#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self.loadingIndicator stop];

  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
  NSLog(@"Chosen image: %@", chosenImage);
  
  [self.TMGLviewController loadImage:chosenImage completionHandler:^(NSError * __nullable error) {
    if (error) {
      [self showSimpleAlert:kAlertImageLoadFailure];
    }
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.loadingIndicator stop];
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)loadImage:(id)sender {
  [self.loadingIndicator start];
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
  [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)saveImage:(id)sender {
  [self.loadingIndicator start];
  [self.TMGLviewController imageFromWorkspaceWithCompletionHandler:^(UIImage * __nullable image,
                                                                     NSError * __nullable error) {
    if (!image) {
      [self showSimpleAlert:kAlertImageSaveFailure];
    } else {
      NSLog(@"Saving image: %@", image);
      UIImageWriteToSavedPhotosAlbum(image, self,
                                     @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
  }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
  [self.loadingIndicator stop];
  NSLog(@"Finished saving image: %@, error %@", image, error);
  if (error) {
    [self showSimpleAlert:kAlertImageSaveFailure];
  } else {
    [self showSimpleAlert:kAlertImageSaveSuccess];
  }
}

#pragma mark -
#pragma mark Display
#pragma mark -

- (UIActivityIndicatorView *)createLoadingIndicator {
  UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  indicator.center = self.view.center;
  [self.view addSubview:indicator];
  [indicator bringSubviewToFront:self.view];
  return indicator;
}

- (void)showSimpleAlert:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil
                                        cancelButtonTitle:kAlertDismissText otherButtonTitles:nil];
  [alert show];
}

#pragma mark -
#pragma mark Feature flow
#pragma mark -

- (IBAction)feature
{
  TMGLFeatureManagerViewController *featureManagerVC = [[TMGLFeatureManagerViewController alloc]
                                                       initWithEngine:self.engine andFeature:[[TMTestFeature alloc] init]];
  featureManagerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:featureManagerVC animated:NO completion:nil];
}

@end

NS_ASSUME_NONNULL_END
