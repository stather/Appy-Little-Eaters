//
//  ContactVC.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 17/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "ContactVC.h"
#import "AppDelegate.h"

@interface ContactVC ()

@end

@implementation ContactVC

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
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [self setNavigationTitle:@"Contact Us"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    AppDelegate *delegate = [AppDelegate getSharedInstance];
    delegate.customeTabBar.hidden = YES;
}

#pragma mark -----
#pragma mark setNagtionBar
-(void) setNavigationTitle:(NSString *) title
{
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f,200, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 200,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:title];
    [view addSubview:titleLbl];
    
    [self.navigationItem setTitleView:view];
}

- (void)backBtnPressed:(id)sender
{
    AppDelegate *delegate = [AppDelegate getSharedInstance];
    delegate.customeTabBar.hidden = NO;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
