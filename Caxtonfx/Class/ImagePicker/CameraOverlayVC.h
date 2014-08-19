//
//  CameraOverlayVC.h
//  cfx
//
//  Created by Ashish on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePickerVC;
@interface CameraOverlayVC : UIViewController
{
    UIImagePickerController *parentController;
}
@property (nonatomic, strong) ImagePickerVC *imageVC;
@property (nonatomic, weak) IBOutlet UIButton *flashBtn;
@property (nonatomic, weak) IBOutlet UIButton *libraryBtn;
@property (nonatomic, weak) IBOutlet UIButton *cameraBtn;
@property (nonatomic, weak) IBOutlet UIButton *receiptsBtn;
@property (nonatomic, weak) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLbl;
- (id) initWithParent:(UIViewController*) parent;

- (IBAction) captureImageBtnTap:(id)sender;
- (IBAction) libraryBtnTap:(id)sender;
- (IBAction) flashBtnTap:(id)sender;
- (IBAction)exitButtonTouched:(id)sender;

- (void) checkForDeviceType;
- (NSString *) platform;
- (void) showControls;
- (void) hideControls;

- (IBAction)popupBtnTouched:(UIButton *)sender;

@end
