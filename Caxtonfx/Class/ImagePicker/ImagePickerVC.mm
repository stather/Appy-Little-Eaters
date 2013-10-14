
//
//  ImagePickerVC.m
//  cfx
//
//  Created by Ashish on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagePickerVC.h"
#import "ImageEditorVC.h"
#import "AppDelegate.h"
#import "UIImage+fixOrientation.h"
#import "ConversionVC.h"
#import "Config.h"


@interface ImagePickerVC ()

@end

@implementation ImagePickerVC

@synthesize isCameraMode;
@synthesize status;
@synthesize libraryPickerController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:YES];
    //init image picker controller
    
    [self registerForNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLibrary) name:@"showGallery" object:nil];
    
    
}

/***** To register and unregister for notification on recieving messages *****/
- (void)registerForNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(calledNotification:)
												 name:STARTED_UPDATION object:nil];
}


-(void)calledNotification:(NSNotification *)notification
{
    NSLog(@"info : %@",[notification userInfo]);
    status = [[[notification userInfo] objectForKey:@"started"] intValue];
}


-(void)unregisterForNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:STARTED_UPDATION object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    #if TARGET_IPHONE_SIMULATOR
    //Simulator
        isCameraMode = NO;
    #else
    // Device
        [self initImagePickerController];
        isCameraMode = YES;
    #endif
   
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark - Methods

- (void) initImagePickerController
{
    if (imagePickerController)
        imagePickerController = nil;
    
    if (covc)
        covc = nil;
    
    //init image picker controller
    imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePickerController setDelegate:self];
    [imagePickerController setAllowsEditing:TRUE];
    [imagePickerController setShowsCameraControls:FALSE];
    
    //set camera overlay
    covc = [[CameraOverlayVC alloc] initWithParent:imagePickerController];
    covc.imageVC = self;
    if (IS_IPHONE_5)
        [covc.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    [covc showControls];
    
    [imagePickerController setCameraOverlayView:covc.view];
    
    // [self showCamera];
}

- (void) goForConversionWithImage:(UIImage *) image withFocusBounds:(CGRect) rect
{
    ConversionVC *cvc = [[ConversionVC alloc] init];
    [cvc setImageToConvert:image];
    [cvc setFocusBounds:rect];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController pushViewController:cvc animated:TRUE];
}

- (void) showCamera
{
    if ([self presentedViewController])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    NSLog(@"%@",imagePickerController);
    
    [self presentViewController:imagePickerController animated:NO completion:nil];
    
    isCameraMode = TRUE;
    
    [covc showControls];
}

- (void) showLibrary
{
    if (libraryPickerController) 
        libraryPickerController = nil;
    
    //present image picker controller
    self.libraryPickerController = [[UIImagePickerController alloc] init];
    [self.libraryPickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self.libraryPickerController setDelegate:self];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    isCameraMode = FALSE;
    
    //present image picker controller
    if(self.libraryPickerController)
        [self presentViewController:self.libraryPickerController animated:NO completion:nil];
}

- (void) showReceipts
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [[self navigationController] popToRootViewControllerAnimated:YES];
    
    [[[AppDelegate getSharedInstance] window] setRootViewController:[[AppDelegate getSharedInstance] tabBarController]];
   
}

- (void) changeCameraMode:(int) mode
{
    if (mode == 1)
    {
        [imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
    }
    else
    {
        [imagePickerController setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    }
}

- (void) goForImageCroppingWithImage:(UIImage*) image
{
    ImageEditorVC *ievc = [[ImageEditorVC alloc] initWithImage:image];
    [self presentViewController:ievc animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Indicator delegate

- (void) indicatorDidComplete
{
    [indicator removeFromSuperview];
    
    indicator = nil;
}

#pragma mark -
#pragma mark - UIImagePickerController Delegate 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    isCameraMode = TRUE;
    
    [self initImagePickerController];
    
    [self showCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{    
    [self dismissViewControllerAnimated:NO completion:nil];
    
  //  libraryPickerController = nil;
    
    preferredCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrency"];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ImageEditorVC *ievc = [[ImageEditorVC alloc] initWithImage:image];
    [self presentViewController:ievc animated:NO completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showGallery" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
