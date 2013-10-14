//
//  MoblieNoCheckedVC.m
//  Caxtonfx
//
//  Created by Sumit on 29/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "MoblieNoCheckedVC.h"
#import "AddMobileNoVC.h"
#import "LoginVC.h"
#import "MyCardVC.h"

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@interface MoblieNoCheckedVC ()

@end

@implementation MoblieNoCheckedVC
@synthesize scrollView;
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
    // Do any additional setup after loading the view from its nib.
    
    [CommonFunctions setNavigationTitle:@"Your mobile number" ForNavigationItem:self.navigationItem];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setupPage];
    
    AppDelegate *appdelegete = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegete.topBarView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height >= 548 )
    {
        [self.scrollView setContentSize:CGSizeMake(320, 500)];
    }else
    {
        [self.scrollView setContentSize:CGSizeMake(320, 1920)];
    }
}

-(void)setupPage
{
    NSLog(@"%@",userMobileStr);
    KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
    NSString *suStr = [keychain2 objectForKey:(__bridge id)kSecAttrAccount];
    NSLog(@"suStr -> %@",suStr);
    UILabel *inOderLbl = (UILabel*)[self.scrollView viewWithTag:1];
    inOderLbl.font = [UIFont fontWithName:@"OpenSans" size:13];
    
    UILabel *chekLbl = (UILabel*)[self.scrollView viewWithTag:2];
    chekLbl.font = [UIFont fontWithName:@"OpenSans" size:10];
    
    UILabel *numberLable = (UILabel*)[self.scrollView viewWithTag:3];
    numberLable.font = [UIFont fontWithName:@"OpenSans" size:65];
    NSString *numberStr = [NSString stringWithFormat:@"\"%@\"",[suStr substringFromIndex: [suStr length] - 4]];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:numberStr];
    
    UIColor *_black=[UIColor blackColor];
    UIFont *font=[UIFont fontWithName:@"OpenSans" size:65];
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 6)];
    [attString addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(1, 4)];
    numberLable.attributedText = attString;
    
    UIButton *itsCorrcetBtn = (UIButton *)[self.scrollView viewWithTag:5];
    [itsCorrcetBtn setBackgroundImage:[UIImage imageNamed:@"itCorrectBtn"] forState:UIControlStateNormal];
    [itsCorrcetBtn setBackgroundImage:[UIImage imageNamed:@"itCorrectBtnHover"] forState:UIControlStateHighlighted];
    
}

#pragma mark ------
#pragma mark IBAction Method

-(IBAction)editBtnPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    appDelegate.mobileNumNotificationView.tag = 2;
    
    if(IS_HEIGHT_GTE_568)
    {
        appDelegate.mobileNumNotificationView.frame = CGRectMake(11, 136, 298,165 );
    }
    else
    {
        appDelegate.mobileNumNotificationView.frame = CGRectMake(11, 92, 298,165 );
    }
    
    [self.view addSubview:appDelegate.mobileNumNotificationView];
}

-(IBAction)itsCorrectBtnPressed:(id)sender
{
    NSString *valueToSave = @"NO";
    [[NSUserDefaults standardUserDefaults]setObject:valueToSave forKey:@"FirstTimeUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    MyCardVC *crdsVc = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
    [self.navigationController pushViewController:crdsVc animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
