//
//  ImageEditorVC.m
//  cfx
//
//  Created by Ashish on 07/09/12.
//
//

#import "ImageEditorVC.h"
#import "ImagePickerVC.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif

@interface ImageEditorVC ()

@end

@implementation ImageEditorVC

@synthesize imageView;
@synthesize imageCropper;
@synthesize bottomBarView;
@synthesize doneBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithImage:(UIImage *) image
{
    self = [super init];
    
    if (self)
    {
        imageToEdited = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_HEIGHT_GTE_568) {
        self.bottomBarView.frame = CGRectMake(0, 515, 320, 53);
    }
    else
        self.bottomBarView.frame = CGRectMake(0, 515, 320, 53);
    

    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    if(IS_HEIGHT_GTE_568)
    {
    }else
    {
        [self.hintLabel setFrame:CGRectMake(20, 30,270 , 70)];
    }
    self.imageCropper = [[BJImageCropper alloc] initWithImage:imageToEdited andMaxSize:IS_IPHONE_5?CGSizeMake(320, 1090):CGSizeMake(320, 434)];
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = IS_IPHONE_5?CGPointMake(160.0f, 291.0f):CGPointMake(160.0f, 250);
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
   [self.view bringSubviewToFront:self.bottomBarView];
    
    [self.view bringSubviewToFront:self.doneBtn];
    
    croppedRect = CGRectMake(CGOriginX(self.imageCropper.crop), CGOriginY(self.imageCropper.crop), CGWidth(self.imageCropper.crop), CGHeight(self.imageCropper.crop));

    [self.view bringSubviewToFront:self.hintLabel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hintLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13.0f]];
        self.hintLabel.alpha = 1.0;
        [self performSelector:@selector(displayHint) withObject:nil afterDelay:7];
        
    });
}

-(void)displayHint
{
    [UIView animateWithDuration:1.0 animations:^{
            self.hintLabel.alpha = 0.0;
        }];
}

#pragma mark -
#pragma mark - IBActions

- (IBAction) libraryBtnTap:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *arr = delegate.mainNavigation.viewControllers;
    
    ImagePickerVC *ipvc = nil;
    
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    
    [ipvc showLibrary];
}

- (IBAction) cameraBtnTap:(id)sender
{
    AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSArray *arr = delegate.mainNavigation.viewControllers;
    ImagePickerVC *ipvc = nil;
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    if(ipvc.isCameraMode)
    {
        [ipvc showCamera];
    }
    else
        [ipvc showLibrary];
}

- (IBAction) doneBtnTap:(id)sender
{
    CGRect rect = CGRectMake(CGOriginX(self.imageCropper.crop), CGOriginY(self.imageCropper.crop), CGWidth(self.imageCropper.crop), CGHeight(self.imageCropper.crop));

    AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSArray *arr = delegate.mainNavigation.viewControllers;
    ImagePickerVC *ipvc ;
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    [self.imageCropper removeObserver:self forKeyPath:@"crop"];
    
    //show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [ipvc goForConversionWithImage:imageToEdited withFocusBounds:rect];
    
}

#pragma mark -
#pragma mark - Methods

- (void)updateDisplay
{
   croppedRect = CGRectMake(CGOriginX(self.imageCropper.crop), CGOriginY(self.imageCropper.crop), CGWidth(self.imageCropper.crop), CGHeight(self.imageCropper.crop));
    NSLog(@"%@",[NSString stringWithFormat:@"(%f, %f) (%f, %f)", CGOriginX(self.imageCropper.crop), CGOriginY(self.imageCropper.crop), CGWidth(self.imageCropper.crop), CGHeight(self.imageCropper.crop)]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
    croppedRect = CGRectMake(242.763290, 552.599030, 467.748779, 639.342957);

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
