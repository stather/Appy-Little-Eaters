//
//  AppDelegate.h
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "JJGActionSheet.h"
#import "sharedManager.h"
#import "TestFlight.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,sharedDelegate,MFMailComposeViewControllerDelegate,JJGActionSheetDelegate>
{
    CGPoint startPos;
    
    BOOL shouldShowImgPicker;
}


@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;

@property (strong, nonatomic) IBOutlet UIView *customeTabBar;
@property (strong ,nonatomic) IBOutlet UIView *shareTabBar;

@property (strong, nonatomic) IBOutlet UINavigationController *mainNavigation;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *ratePopUpView;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIView *mobileNumNotificationView;
@property (strong, nonatomic) IBOutlet UIImageView *cameraLayoutImgView;

@property (nonatomic , strong) NSString *currentId;
@property (nonatomic , strong) NSMutableArray *_array;
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;
- (IBAction) customTabBarBtnTap:(id)sender;

+(AppDelegate*) getSharedInstance;
- (void) showBottomBar;
- (IBAction)BottomButtonTouched:(UIButton *)sender;

- (IBAction)shareTabBarBtnPressed:(UIButton *)sender;

-(IBAction)cancleBtnPressed:(id)sender;

-(IBAction)okBtnPressed:(id)sender;
- (void)showActionSheet;

- (IBAction)cameraButtonTouched:(UIButton *)sender;

- (IBAction) handlePanGesture:(id)sender;
- (IBAction) handleTapGesture:(id)sender;

-(IBAction) autoAnimation;

@end
