//
//  ImagePickerVC.h
//  cfx
//
//  Created by Ashish on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CameraOverlayVC.h"
#import "Indicator.h"

@interface ImagePickerVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, IndicatorDelegate>
{
    CameraOverlayVC *covc;
    
    Indicator *indicator;
    
    UIImagePickerController *imagePickerController;
    UIImagePickerController *libraryPickerController;
}
@property (nonatomic, strong) UIImagePickerController *libraryPickerController;

@property (nonatomic) BOOL isCameraMode;
@property (nonatomic , assign) int status;

- (void) goForConversionWithImage:(UIImage *) image withFocusBounds:(CGRect) rect;
- (void) showCamera;
- (void) showLibrary;
- (void) changeCameraMode:(int) mode;
- (void) showReceipts;
- (void) initImagePickerController;
- (void) goForImageCroppingWithImage:(UIImage*) image;

@end
