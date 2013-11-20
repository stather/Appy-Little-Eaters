//
//  CameraOverlayVC.m
//  cfx
//
//  Created by Ashish on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraOverlayVC.h"
#import "ImagePickerVC.h"
#import "ImageEditorVC.h"
#import "AppDelegate.h"
#import "ImagePickerVC.h"
#import "MoreInfoVC.h"
#import "LoginVC.h"

@interface CameraOverlayVC ()

@end

@implementation CameraOverlayVC

@synthesize imageVC;
@synthesize flashBtn;
@synthesize libraryBtn;
@synthesize cameraBtn;
@synthesize receiptsBtn;
@synthesize controlsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithParent:(UIImagePickerController*) parent
{
    self = [super init];
    
    if (self) 
    { 
        parentController = parent;
    }
    
    return self;
}
- (void) showControls
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    if (IS_HEIGHT_GTE_568) {
        self.controlsView.frame = CGRectMake(0, 499, 320, 69);
    }
    else{
        self.controlsView.frame = CGRectMake(0, 411, 320, 69);
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self.controlsView setFrame:CGRectMake(self.controlsView.frame.origin.x, self.controlsView.frame.origin.y - 30.0f, self.controlsView.frame.size.width, self.controlsView.frame.size.height)];
    }
    [UIView commitAnimations];
}

- (void) hideControls
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    if (IS_HEIGHT_GTE_568) {
        self.controlsView.frame = CGRectMake(0, 568, 320, 69);
    }
    else
        self.controlsView.frame = CGRectMake(0, 480, 320, 69);
    [UIView commitAnimations];
}

- (IBAction)popupBtnTouched:(UIButton *)sender {
    switch (sender.tag)
    {
        case 1:
        {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [[delegate customeTabBar] setHidden:NO];
            [[delegate topBarView] setHidden:NO];
            
            UIButton *btn = [(UIButton *)[UIButton alloc] init];
            btn.tag = 2;
            delegate.tabBarController.selectedIndex = 1;
            [delegate customTabBarBtnTap:btn];
            
            NSArray *arr = [AppDelegate getSharedInstance].mainNavigation.viewControllers;
            ImagePickerVC *ipvc = nil;
            for (int i = 0; i < [arr count]; i++)
            {
                if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
                {
                    ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
                }
            }
            if (ipvc)
            {
                [ipvc showReceipts];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:nil userInfo:nil];
        }
            break;
        case 2:
        {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [[delegate customeTabBar] setHidden:NO];
            [[delegate topBarView] setHidden:NO];
            
            UIButton *btn = [(UIButton *)[UIButton alloc] init];
            btn.tag = 2;
            delegate.tabBarController.selectedIndex = 1;
            [delegate customTabBarBtnTap:btn];
            
            NSArray *arr = [AppDelegate getSharedInstance].mainNavigation.viewControllers;
            ImagePickerVC *ipvc = nil;
            for (int i = 0; i < [arr count]; i++)
            {
                if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
                {
                    ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
                }
            }
            if (ipvc)
            {
                [ipvc showReceipts];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showMoreInfo" object:nil userInfo:nil];
        }
            break;
        case 3:
        {  
            [self setUpPopUpUI:YES];
           
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_HEIGHT_GTE_568) {
        self.controlsView.frame = CGRectMake(0, 499, 320, 69);
    }
    else
        self.controlsView.frame = CGRectMake(0, 411, 320, 69);

    //check for device type to hide flash button
    [self checkForDeviceType];
    
    //change images for iPhone 5
    if (!IS_IPHONE_5)
    {
        [libraryBtn setImage:[UIImage imageNamed:@"galleryTab.png"] forState:UIControlStateNormal];
        [libraryBtn setImage:[UIImage imageNamed:@"galleryTabHover.png"] forState:UIControlStateHighlighted];
       
        [cameraBtn setImage:[UIImage imageNamed:@"takePictureTab.png"] forState:UIControlStateNormal];
        [cameraBtn setImage:[UIImage imageNamed:@"takePictureTabHover.png"] forState:UIControlStateHighlighted];
      
        [receiptsBtn setImage:[UIImage imageNamed:@"myCardsTab"] forState:UIControlStateNormal];
        [receiptsBtn setImage:[UIImage imageNamed:@"myCardsTabHover.png"] forState:UIControlStateHighlighted];
    }

   [self setUpPopUpUI:(BOOL)[[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent=NO;
    }
    [Flurry logEvent:@"Visited Camera Mode"];
}
// edit by sumit mundra
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpPopUpUI:(BOOL)[[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"]];
}


-(void)setUpPopUpUI:(BOOL)state
{
    [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18.0f]];
    [self.infoLbl setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
    
    if(state)  {
        [self.popUpView setAlpha:0.0f];
    }
    else
    {
        
         [self.popUpView setAlpha:1.0f];
        
    }
}

#pragma mark -
#pragma mark - IBActions

- (IBAction) captureImageBtnTap:(id)sender
{
    [parentController takePicture];
}

- (IBAction) libraryBtnTap:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showGallery" object:nil userInfo:nil];
}

- (IBAction) flashBtnTap:(id)sender
{
    UIButton *btn = (UIButton*) sender;
    
    if (btn.tag == 0)
    {
        [btn setTag:1];
        [btn setImage:[UIImage imageNamed:@"flashHover"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setTag:0];
        [btn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *arr = delegate.mainNavigation.viewControllers;
    
    ImagePickerVC *ipvc = nil;
    
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    
    [ipvc changeCameraMode:btn.tag];
}

- (IBAction)exitButtonTouched:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[delegate customeTabBar] setHidden:NO];
    [[delegate topBarView] setHidden:NO];
    
    
    UIButton *btn = [(UIButton *)[UIButton alloc] init];
    btn.tag = 2;
    //Edit by Sumit Mundra
    //delegate.tabBarController.selectedIndex = 1;
    
    [delegate customTabBarBtnTap:btn];
   [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    NSArray *arr = [AppDelegate getSharedInstance].mainNavigation.viewControllers;
    
    ImagePickerVC *ipvc = nil;
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    if (ipvc)
    {
        [ipvc showReceipts];
    }
}

#pragma mark -
#pragma mark - Methods

- (void) checkForDeviceType
{
    NSString *platform = [self platform];
    
    if ([platform isEqualToString:@"iPhone1,1"] || [platform isEqualToString:@"iPhone1,2"] || [platform isEqualToString:@"iPhone2,1"] || [platform isEqualToString:@"iPod1,1"] || [platform isEqualToString:@"iPod2,1"] || [platform isEqualToString:@"iPod3,1"] || [platform isEqualToString:@"iPad1,1"])
    {
        [flashBtn setHidden:TRUE];
    }
    else if ([platform isEqualToString:@"iPod4,1"] || [platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,3"])
    {
        [flashBtn setHidden:TRUE];
    }
}

- (NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
