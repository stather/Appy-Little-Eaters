//
//  AddMobileNoVC.m
//  Caxtonfx
//
//  Created by Sumit on 02/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "AddMobileNoVC.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import "MyCardVC.h"

@interface AddMobileNoVC ()

@end

@implementation AddMobileNoVC


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
    
    self.navigationItem.hidesBackButton =YES;
    [CommonFunctions setNavigationTitle:@"Add a mobile number" ForNavigationItem:self.navigationItem];
    
    [self setupPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appdelegete = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegete.topBarView.hidden = YES;

}

-(void)setupPage
{
    UILabel *textLable = (UILabel *)[self.view viewWithTag:1];
    textLable.font = [UIFont fontWithName:@"OpenSans" size:13];
    textLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
}


#pragma mark -----------
#pragma mark IBActionMethod

-(IBAction)skipBrnPressed:(id)sender
{
    NSString *valueToSave = @"NO";
    [[NSUserDefaults standardUserDefaults]setObject:valueToSave forKey:@"FirstTimeUser"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    MyCardVC *crdsVc = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
    [self.navigationController pushViewController:crdsVc animated:YES];
}

-(IBAction)addNowBtnPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    appDelegate.mobileNumNotificationView.tag = 1;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
