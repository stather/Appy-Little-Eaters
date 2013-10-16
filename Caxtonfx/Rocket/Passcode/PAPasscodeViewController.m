//
//  PAPasscodeViewController.m
//  PAPasscode
//
//  Created by Denis Hennessy on 15/10/2012.
//  Copyright (c) 2012 Peer Assembly. All rights reserved.


#import <QuartzCore/QuartzCore.h>
#import "PAPasscodeViewController.h"
#import "ForgetPinVC.h"
#import "AppDelegate.h"

#define NAVBAR_HEIGHT   0//50
#define PROMPT_HEIGHT   74
#define DIGIT_SPACING   10
#define DIGIT_WIDTH     61
#define DIGIT_HEIGHT    53
#define MARKER_WIDTH    16
#define MARKER_HEIGHT   16
#define MARKER_X        22
#define MARKER_Y        18
#define MESSAGE_HEIGHT  74
#define FAILED_LCAP     19
#define FAILED_RCAP     19
#define FAILED_HEIGHT   26
#define FAILED_MARGIN   10
#define TEXTFIELD_MARGIN 8
#define SLIDE_DURATION  0.3

@interface PAPasscodeViewController ()
- (void)cancel:(id)sender;
- (void)handleFailedAttempt;
- (void)handleCompleteField;
- (void)passcodeChanged:(id)sender;
- (void)resetFailedAttempts;
- (void)showFailedAttempts;
- (void)showScreenForPhase:(NSInteger)phase animated:(BOOL)animated;
@end

@implementation PAPasscodeViewController
@synthesize skipButton,inputAccView,skipStr;

- (id)initForAction:(PasscodeAction)action {
    self = [super init];
    attemp = 0;
    if (self) {
        _action = action;
        switch (action) {
            case PasscodeActionSet:
                [self setNavigationTitle:NSLocalizedString(@"Create a PIN", nil)];
                // self.title = NSLocalizedString(@"Create a Pin", nil);
                _enterPrompt = NSLocalizedString(@"For added security you can create a 4 digit PIN to access the Caxton FX app. Simply enter a PIN below. You can change or turn it off at any time by visiting ‘Settings’.", nil);
                _confirmPrompt = NSLocalizedString(@"Please re-enter your PIN. You can change or turn it off at any time by visiting ‘Settings’.", nil);
                  self.navigationController.navigationBarHidden = NO;
                
                break;
                
            case PasscodeActionEnter:
                
                [self setNavigationTitle:NSLocalizedString(@"Enter your PIN", nil)];
                // self.title = NSLocalizedString(@"Enter Passcode", nil);
                _enterPrompt = NSLocalizedString(@"Use your PIN to access your account", nil);
                  self.navigationController.navigationBarHidden = NO;
                break;
                
            case PasscodeActionChange:
                
                [self setNavigationTitle:NSLocalizedString(@"Change Passcode", nil)];
                // self.title = NSLocalizedString(@"Change Passcode", nil);
                _changePrompt = NSLocalizedString(@"Enter your old passcode", nil);
                _enterPrompt = NSLocalizedString(@"Enter your new passcode", nil);
                _confirmPrompt = NSLocalizedString(@"Re-enter your new passcode", nil);
                  self.navigationController.navigationBarHidden = NO;
                break;
                
            case PasscodeFoget:
                self.title = NSLocalizedString(@"Reset Pin", nil);
                _enterPrompt = NSLocalizedString(@"Enter your new passcode", nil);
                _confirmPrompt = NSLocalizedString(@"Re-enter your new passcode", nil);
                  self.navigationController.navigationBarHidden = NO;
                break;
                
            case PasscodeReset:
                
                [self setNavigationTitle: NSLocalizedString(@"Create a new PIN", nil)];
                _enterPrompt = NSLocalizedString(@"Create a new PIN to access your account", nil);
                _confirmPrompt = NSLocalizedString(@"Please re-enter your PIN to confirm.", nil);
                  self.navigationController.navigationBarHidden = NO;
                break;
                
                
        }
        self.navigationController.navigationBarHidden = NO;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appDelegate.topBarView.hidden = YES;
        _simple = YES;
    }
    return self;
}

- (void)loadView {
    
    if(_action ==1){
        NSLog(@"%d",_action);
    
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = UIColorFromRedGreenBlue(255, 255, 255);
        if([skipStr isEqualToString:@"YES"])
        {
            self.navigationItem.rightBarButtonItem = nil;
            skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [skipButton setFrame:CGRectMake(0.0f, 0.0f, 52, 32.0f)];
            [skipButton setBackgroundImage:[UIImage imageNamed:@"PACancel"] forState:UIControlStateNormal];
            [skipButton setBackgroundImage:[UIImage imageNamed:@"PACancelSelected"] forState:UIControlStateSelected];
            skipButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
            [skipButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [skipButton addTarget:self action:@selector(skipBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:skipButton];
            
            self.navigationItem.rightBarButtonItem = btn;
        }
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, view.bounds.size.width, view.bounds.size.height)];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        if (_backgroundView) {
            [contentView addSubview:_backgroundView];
        }
        contentView.backgroundColor = UIColorFromRedGreenBlue(255, 255, 255);
        [view addSubview:contentView];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT,view.bounds.size.width, view.bounds.size.height)];
        scrollView.delegate = self;
        scrollView.userInteractionEnabled = YES;
        scrollView.scrollEnabled = NO;
        [contentView addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 25, 129,26 )];
        imageView.image = [UIImage imageNamed:@"cfxLogo"];
        [scrollView addSubview:imageView];
        
        CGFloat panelWidth = DIGIT_WIDTH*4+DIGIT_SPACING*3;
        if (_simple) {
            digitPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
            
            digitPanel.frame = CGRectMake(47, 120, 222, 43);
            // [contentView addSubview:digitPanel];
            [scrollView addSubview:digitPanel];
            
            UIImage *backgroundImage = [UIImage imageNamed:@"pinTxtBox"];
            UIImage *markerImage = [UIImage imageNamed:@"pinTxtSelectedBox"];
            CGFloat xLeft = 2;
            for (int i=0;i<4;i++) {
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
                
                backgroundImageView.frame = CGRectMake(xLeft, 0, 41, 41);
                [digitPanel addSubview:backgroundImageView];
                digitImageViews[i] = [[UIImageView alloc] initWithImage:markerImage];
                
                
                digitImageViews[i].frame =  backgroundImageView.frame = CGRectMake(xLeft, 0, 41, 41);
                [digitPanel addSubview:digitImageViews[i]];
                xLeft += 19 + backgroundImage.size.width;
            }
            passcodeTextField = [[UITextField alloc] initWithFrame:digitPanel.frame];
            passcodeTextField.hidden = YES;
            
        } else {
            UIView *passcodePanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
            passcodePanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            passcodePanel.frame = CGRectOffset(passcodePanel.frame, (contentView.bounds.size.width-passcodePanel.bounds.size.width)/2, PROMPT_HEIGHT);
            passcodePanel.frame = CGRectInset(passcodePanel.frame, TEXTFIELD_MARGIN, TEXTFIELD_MARGIN);
            passcodePanel.layer.borderColor = [UIColor colorWithRed:0.65 green:0.67 blue:0.70 alpha:1.0].CGColor;
            passcodePanel.layer.borderWidth = 1.0;
            passcodePanel.layer.cornerRadius = 5.0;
            passcodePanel.layer.shadowColor = [UIColor whiteColor].CGColor;
            passcodePanel.layer.shadowOffset = CGSizeMake(0, 1);
            passcodePanel.layer.shadowOpacity = 1.0;
            passcodePanel.layer.shadowRadius = 1.0;
            passcodePanel.backgroundColor = [UIColor whiteColor];
            [contentView addSubview:passcodePanel];
            passcodeTextField = [[UITextField alloc] initWithFrame:CGRectInset(passcodePanel.frame, 6, 6)];
        }
        passcodeTextField.delegate = self;
        passcodeTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        passcodeTextField.borderStyle = UITextBorderStyleNone;
        passcodeTextField.secureTextEntry = YES;
        passcodeTextField.textColor = [UIColor colorWithRed:0.23 green:0.33 blue:0.52 alpha:1.0];
        passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [passcodeTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
        [contentView addSubview:passcodeTextField];
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 280, 60)];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        
        promptLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
        if(_action==0){
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
            promptLabel.textAlignment = UITextAlignmentLeft;
#else
            promptLabel.textAlignment = NSTextAlignmentCenter;
#endif
        }else
        {
            promptLabel.textAlignment = NSTextAlignmentCenter;
        }
        promptLabel.numberOfLines = 0;
        
        [scrollView addSubview:promptLabel];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 141+30 , contentView.bounds.size.width, 35)];
        messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = UIColorFromRedGreenBlue(213, 32, 50);
        messageLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        messageLabel.textAlignment = UITextAlignmentCenter;
#else
        messageLabel.textAlignment = NSTextAlignmentCenter;
#endif
        messageLabel.numberOfLines = 0;
        
        // [contentView addSubview:messageLabel];
        
        [scrollView addSubview:messageLabel];
        
        UIImage *failedBg = [[UIImage imageNamed:@"papasscode_failed_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, FAILED_LCAP, 0, FAILED_RCAP)];
        failedImageView = [[UIImageView alloc] initWithImage:failedBg];
        failedImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        failedImageView.hidden = YES;
        [contentView addSubview:failedImageView];
        
        failedAttemptsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        failedAttemptsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        failedAttemptsLabel.backgroundColor = [UIColor clearColor];
        failedAttemptsLabel.textColor = [UIColor whiteColor];
        failedAttemptsLabel.font = [UIFont boldSystemFontOfSize:15];
        failedAttemptsLabel.shadowColor = [UIColor blackColor];
        failedAttemptsLabel.shadowOffset = CGSizeMake(0, -1);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        failedAttemptsLabel.textAlignment = UITextAlignmentCenter;
#else
        failedAttemptsLabel.textAlignment = NSTextAlignmentCenter;
#endif
        failedAttemptsLabel.hidden = YES;
        [contentView addSubview:failedAttemptsLabel];
        
        UIImageView *shadowTopBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 2)];
        shadowTopBar.image = [UIImage imageNamed:@"shadowTopBar"];
        [view addSubview:shadowTopBar];
        
        forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetBtn setFrame:CGRectMake(220, 141+30, 68, 10)];
        [forgetBtn setBackgroundImage:[UIImage imageNamed:@"forgotText"] forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(forgetBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:forgetBtn];
        
         self.view = view;
    
    }else{
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = UIColorFromRedGreenBlue(255, 255, 255);
        if([skipStr isEqualToString:@"YES"])
        {
            self.navigationItem.rightBarButtonItem = nil;
            skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [skipButton setFrame:CGRectMake(0.0f, 0.0f, 52, 32.0f)];
            [skipButton setBackgroundImage:[UIImage imageNamed:@"skipBtn"] forState:UIControlStateNormal];
            [skipButton setBackgroundImage:[UIImage imageNamed:@"skipBtnSelected"] forState:UIControlStateSelected];
            [skipButton addTarget:self action:@selector(skipBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:skipButton];
            
            self.navigationItem.rightBarButtonItem = btn;
        }
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, view.bounds.size.width, view.bounds.size.height)];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        if (_backgroundView) {
            [contentView addSubview:_backgroundView];
        }
        contentView.backgroundColor = UIColorFromRedGreenBlue(255, 255, 255);
        [view addSubview:contentView];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT,view.bounds.size.width, view.bounds.size.height)];
        scrollView.delegate = self;
        scrollView.userInteractionEnabled = YES;
        scrollView.scrollEnabled = NO;
        [contentView addSubview:scrollView];
        
        CGFloat panelWidth = DIGIT_WIDTH*4+DIGIT_SPACING*3;
        if (_simple) {
            digitPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
            if(_action==0)
                digitPanel.frame = CGRectMake(47, 107, 222, 43);
            else
                digitPanel.frame = CGRectMake(47, 82, 222, 43);
            // [contentView addSubview:digitPanel];
            [scrollView addSubview:digitPanel];
            
            UIImage *backgroundImage = [UIImage imageNamed:@"pinTxtBox"];
            UIImage *markerImage = [UIImage imageNamed:@"pinTxtSelectedBox"];
            CGFloat xLeft = 2;
            for (int i=0;i<4;i++) {
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
                
                backgroundImageView.frame = CGRectMake(xLeft, 0, 41, 41);
                [digitPanel addSubview:backgroundImageView];
                digitImageViews[i] = [[UIImageView alloc] initWithImage:markerImage];
                
                
                digitImageViews[i].frame =  backgroundImageView.frame = CGRectMake(xLeft, 0, 41, 41);
                [digitPanel addSubview:digitImageViews[i]];
                xLeft += 19 + backgroundImage.size.width;
            }
            passcodeTextField = [[UITextField alloc] initWithFrame:digitPanel.frame];
            passcodeTextField.hidden = YES;
            
        } else {
            UIView *passcodePanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
            passcodePanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            passcodePanel.frame = CGRectOffset(passcodePanel.frame, (contentView.bounds.size.width-passcodePanel.bounds.size.width)/2, PROMPT_HEIGHT);
            passcodePanel.frame = CGRectInset(passcodePanel.frame, TEXTFIELD_MARGIN, TEXTFIELD_MARGIN);
            passcodePanel.layer.borderColor = [UIColor colorWithRed:0.65 green:0.67 blue:0.70 alpha:1.0].CGColor;
            passcodePanel.layer.borderWidth = 1.0;
            passcodePanel.layer.cornerRadius = 5.0;
            passcodePanel.layer.shadowColor = [UIColor whiteColor].CGColor;
            passcodePanel.layer.shadowOffset = CGSizeMake(0, 1);
            passcodePanel.layer.shadowOpacity = 1.0;
            passcodePanel.layer.shadowRadius = 1.0;
            passcodePanel.backgroundColor = [UIColor whiteColor];
            [contentView addSubview:passcodePanel];
            passcodeTextField = [[UITextField alloc] initWithFrame:CGRectInset(passcodePanel.frame, 6, 6)];
        }
        passcodeTextField.delegate = self;
        passcodeTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        passcodeTextField.borderStyle = UITextBorderStyleNone;
        passcodeTextField.secureTextEntry = YES;
        passcodeTextField.textColor = [UIColor colorWithRed:0.23 green:0.33 blue:0.52 alpha:1.0];
        passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [passcodeTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
        [contentView addSubview:passcodeTextField];
        
        if(_action ==0)
            promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 280, 80)];
        else
            promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 280, 20)];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        
        promptLabel.font = [UIFont fontWithName:@"OpenSans" size:11];
        if(_action==0){
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
            promptLabel.textAlignment = UITextAlignmentLeft;
#else
            promptLabel.textAlignment = NSTextAlignmentLeft;
#endif
        }else
        {
            promptLabel.textAlignment = NSTextAlignmentCenter;
        }
        promptLabel.numberOfLines = 0;
        
        // [contentView addSubview:promptLabel];
        
        [scrollView addSubview:promptLabel];
        
        if(_action==0)
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 141+14, contentView.bounds.size.width, 30)];
        else
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 141, contentView.bounds.size.width, 35)];
        messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = UIColorFromRedGreenBlue(213, 32, 39);
        messageLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        messageLabel.textAlignment = UITextAlignmentCenter;
#else
        messageLabel.textAlignment = NSTextAlignmentCenter;
#endif
        messageLabel.numberOfLines = 0;
        
        // [contentView addSubview:messageLabel];
        
        [scrollView addSubview:messageLabel];
        
        UIImage *failedBg = [[UIImage imageNamed:@"papasscode_failed_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, FAILED_LCAP, 0, FAILED_RCAP)];
        failedImageView = [[UIImageView alloc] initWithImage:failedBg];
        failedImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        failedImageView.hidden = YES;
        [contentView addSubview:failedImageView];
        
        failedAttemptsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        failedAttemptsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        failedAttemptsLabel.backgroundColor = [UIColor clearColor];
        failedAttemptsLabel.textColor = [UIColor whiteColor];
        failedAttemptsLabel.font = [UIFont boldSystemFontOfSize:15];
        failedAttemptsLabel.shadowColor = [UIColor blackColor];
        failedAttemptsLabel.shadowOffset = CGSizeMake(0, -1);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        failedAttemptsLabel.textAlignment = UITextAlignmentCenter;
#else
        failedAttemptsLabel.textAlignment = NSTextAlignmentCenter;
#endif
        failedAttemptsLabel.hidden = YES;
        [contentView addSubview:failedAttemptsLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 2)];
        imageView.image = [UIImage imageNamed:@"shadowTopBar"];
        [view addSubview:imageView];
        self.view = view;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    errorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];
    errorImageView.image = [UIImage imageNamed:@"pinTxtBoxRed"];
    errorImageView.hidden = YES;
    [digitPanel addSubview:errorImageView];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    if (screenRect.size.height >= 548 )
    {
        isiPhone5 = YES;
    }else
    {
        isiPhone5 = NO;
    }
    
     self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
   
     [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem=nil;
    [self.navigationItem setLeftBarButtonItem:nil];
   
    [self showScreenForPhase:0 animated:NO];
    [passcodeTextField becomeFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    switch (_action)
    {
        case PasscodeActionSet:
            [self setNavigationTitle:NSLocalizedString(@"Create a PIN", nil)];
            
            break;
            
        case PasscodeActionEnter:
            
            [self setNavigationTitle:NSLocalizedString(@"Enter your PIN", nil)];
            break;
            
        case PasscodeActionChange:
            
            [self setNavigationTitle:NSLocalizedString(@"Change Passcode", nil)];
            
            break;
            
        case PasscodeFoget:
            
            [self setNavigationTitle: NSLocalizedString(@"Create a new PIN", nil)];
            break;
            
        case PasscodeReset:
            [self setNavigationTitle: NSLocalizedString(@"Create a new PIN", nil)];
            
            break;
        }
    
    self.navigationItem.hidesBackButton = YES;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)cancel:(id)sender {
    [_delegate PAPasscodeViewControllerDidCancel:self];
}

#pragma mark - implementation helpers

- (void)handleCompleteField {
    NSString *text = passcodeTextField.text;
    switch (_action) {
        case PasscodeActionSet:
            if (phase == 0) {
                _passcode = text;
                messageLabel.text = @"";
                [self showScreenForPhase:1 animated:YES];
                [scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            } else {
                if ([text isEqualToString:_passcode]) {
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidSetPasscode:)]) {
                        [passcodeTextField resignFirstResponder];
                        [_delegate PAPasscodeViewControllerDidSetPasscode:self];
                    }
                } else {
                    [self showScreenForPhase:0 animated:YES];
                    if(!isiPhone5)
                        [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                    messageLabel.text = NSLocalizedString(@"That’s different to the PIN you’ve just entered.Please try again.", nil);
                }
            }
            break;
            
        case PasscodeActionEnter:
            if ([text isEqualToString:_passcode]) {
                [self resetFailedAttempts];
                if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidEnterPasscode:)]) {
                    [passcodeTextField resignFirstResponder];
                     [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"attemp"];
                    [_delegate PAPasscodeViewControllerDidEnterPasscode:self];
                }
            } else {
                if (_alternativePasscode && [text isEqualToString:_alternativePasscode]) {
                    [self resetFailedAttempts];
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidEnterAlternativePasscode:)]) {
                        [_delegate PAPasscodeViewControllerDidEnterAlternativePasscode:self];
                    }
                } else {
                    [self handleFailedAttempt];
                    if(attemp>=2)
                    {
                    }else{
                        [self showScreenForPhase:0 animated:NO];
                    }
                }
            }
            break;
            
        case PasscodeActionChange:
            if (phase == 0) {
                if ([text isEqualToString:_passcode]) {
                    [self resetFailedAttempts];
                    [self showScreenForPhase:1 animated:YES];
                } else {
                    [self handleFailedAttempt];
                    [self showScreenForPhase:0 animated:NO];
                }
            } else if (phase == 1) {
                _passcode = text;
                messageLabel.text = @"";
                [self showScreenForPhase:2 animated:YES];
            } else {
                if ([text isEqualToString:_passcode]) {
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidChangePasscode:)]) {
                        [_delegate PAPasscodeViewControllerDidChangePasscode:self];
                    }
                } else {
                    [self showScreenForPhase:1 animated:YES];
                    messageLabel.text = NSLocalizedString(@"Passcodes did not match. Try again.", nil);
                }
            }
            break;
            
        case PasscodeFoget:
            if (phase == 0) {
                _passcode = text;
                messageLabel.text = @"";
                [self showScreenForPhase:1 animated:YES];
            } else {
                if ([text isEqualToString:_passcode]) {
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidSetPasscode:)]) {
                        [_delegate PAPasscodeViewControllerDidFogetPasscode:self];
                    }
                } else {
                    _action = 0;
                    
                    [self showScreenForPhase:0 animated:YES];
                    messageLabel.text = NSLocalizedString(@"Passcodes did not match. Try again.", nil);
                }
            }
            break;
            
        case PasscodeReset:
            if (phase == 0) {
                _passcode = text;
                messageLabel.text = @"";
                [self showScreenForPhase:1 animated:YES];
                [scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            } else {
                if ([text isEqualToString:_passcode]) {
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidResetPasscode:)]) {
                        [_delegate PAPasscodeViewControllerDidResetPasscode:self];
                    }
                } else {
                    [self showScreenForPhase:0 animated:YES];
                    if(!isiPhone5)
                        [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                    messageLabel.text = NSLocalizedString(@"That’s different to the PIN you’ve just entered.Please try again.", nil);
                }
            }
            break;
            
    }
}

- (void)handleFailedAttempt {
    _failedAttempts++;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults doubleForKey:@"currentTimeIntrval"])
    {
        double firstAttamp = [userDefaults doubleForKey:@"currentTimeIntrval"];
        NSDate *currentdate = [NSDate date];
        double currentTimeIntrval = [currentdate timeIntervalSince1970];
        double newTimeIntrval = [userDefaults doubleForKey:@"newTimeIntrval"];
        if(currentTimeIntrval>firstAttamp && currentTimeIntrval<newTimeIntrval)
        {
            attemp = [userDefaults integerForKey:@"attemp"];
            
            attemp = attemp +1;
            [userDefaults setInteger:attemp forKey:@"attemp"];
            
        }else
        {
            
            NSDate *currentdate = [NSDate date];
            double currentTimeIntrval = [currentdate timeIntervalSince1970];
            NSDate *newDate = [currentdate dateByAddingTimeInterval:60*60*24];
            NSLog(@"%@",newDate);
            double newTimeIntrval = [newDate timeIntervalSince1970];
            [userDefaults setDouble:currentTimeIntrval forKey:@"currentTimeIntrval"];
            [userDefaults setDouble:newTimeIntrval forKey:@"newTimeIntrval"];
            [userDefaults setInteger:1 forKey:@"attemp"];
            attemp = 1;
            [userDefaults synchronize];
            
        }
        
    }
    else
    {
        NSDate *currentdate = [NSDate date];
        NSLog(@"%@",currentdate);
        double currentTimeIntrval = [currentdate timeIntervalSince1970];
        NSLog(@"%f",currentTimeIntrval);
        
        NSDate *newDate = [currentdate dateByAddingTimeInterval:60*60*24];
        NSLog(@"%@",newDate);
        double newTimeIntrval = [newDate timeIntervalSince1970];
        NSLog(@"%f",newTimeIntrval);
        
        [userDefaults setDouble:currentTimeIntrval forKey:@"currentTimeIntrval"];
        [userDefaults setDouble:newTimeIntrval forKey:@"newTimeIntrval"];
        [userDefaults setInteger:1 forKey:@"attemp"];
        [userDefaults synchronize];
        attemp = 1;
        
    }
    NSLog(@"attemp %d",attemp);
    if(attemp >=3)
    {
        messageLabel.text = @"Maximum login attempts tried.Please try logging using the Forgotten PIN button below";
         [self showFailedAttempts];
        
    }else{
        [self showFailedAttempts];
        messageLabel.text = @"That’s the wrong PIN. Please try again.";

        if ([_delegate respondsToSelector:@selector(PAPasscodeViewController:didFailToEnterPasscode:)]) {
            [_delegate PAPasscodeViewController:self didFailToEnterPasscode:_failedAttempts];
        }
    }
}

- (void)resetFailedAttempts {
    messageLabel.hidden = NO;
    failedImageView.hidden = YES;
    failedAttemptsLabel.hidden = YES;
    _failedAttempts = 0;
}

- (void)showFailedAttempts
{
    if(! isiPhone5)
    {
        if(_action==1){
               [scrollView setFrame:CGRectMake(0, -60, 320, self.view.frame.size.height)];
           [forgetBtn setFrame:CGRectMake(220, 141+30+40+10, 68, 10)];
            
        }else{
        
        [scrollView setFrame:CGRectMake(0, -20, 320, self.view.frame.size.height)];
        }
    }else
    {
         [forgetBtn setFrame:CGRectMake(220, 141+30+40+10, 68, 10)];
    }
    
}

- (void)passcodeChanged:(id)sender {
    errorImageView.hidden = YES;
    NSString *text = passcodeTextField.text;
    if (_simple) {
        if ([text length] > 4) {
            text = [text substringToIndex:4];
        }
        for (int i=0;i<4;i++) {
            digitImageViews[i].hidden = i >= [text length];
        }
        if ([text length] == 4) {
            [self handleCompleteField];
        }
    } else {
        self.navigationItem.rightBarButtonItem.enabled = [text length] > 0;
    }
}

- (void)showScreenForPhase:(NSInteger)newPhase animated:(BOOL)animated {
    CGFloat dir = (newPhase > phase) ? 1 : -1;
    if (animated) {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        snapshotImageView = [[UIImageView alloc] initWithImage:snapshot];
        snapshotImageView.frame = CGRectOffset(snapshotImageView.frame, -contentView.frame.size.width*dir, 0);
        [contentView addSubview:snapshotImageView];
    }
    phase = newPhase;
    passcodeTextField.text = @"";
    if (!_simple) {
        BOOL finalScreen = _action == PasscodeActionSet && phase == 1;
        finalScreen |= _action == PasscodeActionEnter && phase == 0;
        finalScreen |= _action == PasscodeActionChange && phase == 2;
        if (finalScreen) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleCompleteField)];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(handleCompleteField)];
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    switch (_action) {
        case PasscodeActionSet:
            if (phase == 0) {
                 [self setNavigationTitle:NSLocalizedString(@"Confirm your PIN", nil)];
                promptLabel.text = _enterPrompt;
            } else {
                promptLabel.text = _confirmPrompt;
                [self setNavigationTitle:NSLocalizedString(@"Confirm your PIN", nil)];
            }
            break;
            
        case PasscodeActionEnter:
            promptLabel.text = _enterPrompt;
            break;
            
        case PasscodeActionChange:
            if (phase == 0) {
                promptLabel.text = _changePrompt;
            } else if (phase == 1) {
                promptLabel.text = _enterPrompt;
            } else {
                promptLabel.text = _confirmPrompt;
            }
            break;
            
        case PasscodeFoget:
            if (phase == 0) {
                promptLabel.text = _enterPrompt;
            } else {
                promptLabel.text = _confirmPrompt;
            }
            break;
            
        case PasscodeReset:
            if (phase == 0) {
                promptLabel.text = _enterPrompt;
            } else {
                promptLabel.text = _confirmPrompt;
            }
            break;
    }
    for (int i=0;i<4;i++) {
        digitImageViews[i].hidden = YES;
    }
    if (animated) {
        contentView.frame = CGRectOffset(contentView.frame, contentView.frame.size.width*dir, 0);
        [UIView animateWithDuration:SLIDE_DURATION animations:^() {
            contentView.frame = CGRectOffset(contentView.frame, -contentView.frame.size.width*dir, 0);
        } completion:^(BOOL finished) {
            [snapshotImageView removeFromSuperview];
            snapshotImageView = nil;
        }];
    }
}


-(void)createInputAccessoryView{
    
    switch (_action) {
        
        case PasscodeReset:
        {
            
            inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 45.0)];
            
            [inputAccView setBackgroundColor:[UIColor clearColor]];
            
            [inputAccView setAlpha: 1.0];
            
            UIButton * forgetBtnLocal = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            
            [forgetBtnLocal setFrame: CGRectMake(01.0, 0.0, 100, 42.0)];
            [forgetBtnLocal setBackgroundColor: [UIColor clearColor]];
            forgetBtnLocal.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
            forgetBtnLocal.titleLabel.textAlignment = NSTextAlignmentCenter;
            [forgetBtnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [forgetBtnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [forgetBtnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [forgetBtnLocal setTitle:@"Remove Pin" forState:UIControlStateNormal];
            [forgetBtnLocal addTarget: self action: @selector(RemoveBtnPressed) forControlEvents: UIControlEventTouchUpInside];
            [forgetBtnLocal setBackgroundImage:[UIImage imageNamed:@"grayBtn"] forState:UIControlStateNormal];
            
            
            UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextBtn setFrame:CGRectMake(242.0, 0.0f, 77.0f, 42.0f)];
            nextBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
            nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [nextBtn setBackgroundColor:[UIColor clearColor]];
            [nextBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [nextBtn addTarget:self action:@selector(nextBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [nextBtn setTitle:@"next" forState:UIControlStateNormal];
            [nextBtn setBackgroundImage:[UIImage imageNamed:@"grayBtn"] forState:UIControlStateNormal];
            
            [inputAccView addSubview:nextBtn];
            
            [inputAccView addSubview:forgetBtn];
            
            
        }
            
            
            
            
            
        default:
            break;
    }
    
    
}

-(void)skipBtnPressed:(id)sender
{
    [_delegate PAPasscodeViewControllerDidCancel:self];
}


-(void)RemoveBtnPressed
{
    
    [passcodeTextField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"setPin"];
    [_delegate PAPasscodeViewControllerDidCancel:self];
}

-(void)cancelBtnPressed
{
    
    NSLog(@"cancelBtnPressed");
    
    [_delegate PAPasscodeViewControllerDidCancel:self];
    
}


-(void)forgetBtnPressed
{
    ForgetPinVC *fPVC = [[ForgetPinVC alloc]initWithNibName:@"ForgetPinVC" bundle:nil];
    [self.navigationController pushViewController:fPVC animated:YES];
    
}

-(void)enterCancleBtnPressed
{
    
    NSLog(@"cancelBtnPressed");
    
    [_delegate PAPasscodeViewControllerDidCancel:self];
}

-(void)nextBtnPressed
{
    if(phase ==0){
        
        errorImageView.hidden = YES;
        NSString *str = @"Please enter 4 digits to create a PIN and try again";
        switch (passcodeTextField.text.length) {
            case 0:
                [errorImageView setFrame:CGRectMake(1, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                break;
                
            case 1:
                [errorImageView setFrame:CGRectMake(61, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                
                break;
            case 2:
                [errorImageView setFrame:CGRectMake(123, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                
                break;
            case 3:
                [errorImageView setFrame:CGRectMake(185, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                
                break;
                
            case 4:
                errorImageView.hidden = YES;
                messageLabel.text = @"";
                [scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                [self handleCompleteField];
                break;
                
            default:
                break;
        }
    }else
    {
        [self handleCompleteField];
    }
    
    
}

-(void)doneBtnPressed
{
    if(phase ==0){
        
        errorImageView.hidden = YES;
        NSString *str = @"Please enter 4 digits to create a PIN and try again";
        switch (passcodeTextField.text.length) {
            case 0:
                [errorImageView setFrame:CGRectMake(1, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                break;
                
            case 1:
                [errorImageView setFrame:CGRectMake(61, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                
                break;
            case 2:
                [errorImageView setFrame:CGRectMake(123, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                
                break;
            case 3:
                [errorImageView setFrame:CGRectMake(185, 0, 43, 43)];
                errorImageView.hidden = NO;
                messageLabel.text = str;
                if(!isiPhone5)
                    [scrollView setFrame:CGRectMake(0, -40, 320, self.view.frame.size.height)];
                
                break;
                
            case 4:
                errorImageView.hidden = YES;
                messageLabel.text = @"";
                [scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                [self handleCompleteField];
                break;
                
            default:
                break;
        }
    }else
    {
        [self handleCompleteField];
    }
}

#pragma mark ----------
#pragma mark TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    passcodeTextField = textField;
}


-(void) setNavigationTitle:(NSString *) title
{
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f, 200, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 200,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setShadowColor:[UIColor colorWithRed:2.0f/255.0f green:42.0f/255.0f blue:63.0f/255 alpha:1]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [titleLbl setText:title];
    [view addSubview:titleLbl];
    
    [self.navigationItem setTitleView:view];
}


@end
