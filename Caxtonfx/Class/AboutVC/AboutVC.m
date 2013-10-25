//
//  AboutVC.m
//  Caxtonfx
//
//  Created by Sumit on 04/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

@synthesize scrollview;

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
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setNavigationTitle:@"About Caxton FX"];
    
    UIBarButtonItem *backBtn = [CommonFunctions backButton];
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0,0,32,32);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareBtnSelected"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.customeTabBar setHidden:YES];
    [appDelegate.customeTabBar removeFromSuperview];
    
    if(IS_HEIGHT_GTE_568)
       [appDelegate.shareTabBar setFrame:CGRectMake(0, 509, 320, 59)];
    else
         [appDelegate.shareTabBar setFrame:CGRectMake(0, 421, 320, 59)];
    [appDelegate.shareTabBar setHidden:NO];
    [appDelegate.tabBarController.view addSubview:appDelegate.shareTabBar];
        
    if(IS_HEIGHT_GTE_568)
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,443 )];
    else
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,355 )];
    scrollview.backgroundColor = [UIColor clearColor];
    scrollview.delegate =self;
    scrollview.translatesAutoresizingMaskIntoConstraints = YES;
    [self.view addSubview:self.scrollview];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 19, 91, 91)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.tag = 1;
    imageView.image = [UIImage imageNamed:@"logo"];
    [self.scrollview addSubview:imageView];
    
    UILabel *cfxLable = [[UILabel alloc]initWithFrame:CGRectMake(128, 21,170,30)];
    cfxLable.backgroundColor = [UIColor clearColor ];
    cfxLable.tag =2;
    cfxLable.text = @"Caxton FX travel currency app";
    cfxLable.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
    cfxLable.textColor = UIColorFromRedGreenBlue(86, 83, 78);
    cfxLable.numberOfLines = 0;
    [self.scrollview addSubview:cfxLable];
    
    UILabel *versionLable = [[UILabel alloc]initWithFrame:CGRectMake(128,54, 109, 21)];
    versionLable.backgroundColor = [UIColor clearColor ];
    versionLable.text = @"Version: 1.0";
    versionLable.tag =3;
    versionLable.textColor = UIColorFromRedGreenBlue(86, 83, 78);
    versionLable.font = [UIFont fontWithName:@"OpenSans" size:12];
    [self.scrollview addSubview:versionLable];
    
    UILabel *copyRightLable = [[UILabel alloc]initWithFrame:CGRectMake(128, 80, 170, 31)];
    copyRightLable.backgroundColor = [UIColor clearColor ];
    copyRightLable.tag =4;
    copyRightLable.numberOfLines=0;
    copyRightLable.text = @"© 2013 Caxton FX Limited. All rights reserved.";
    copyRightLable.textColor = UIColorFromRedGreenBlue(86, 83, 78);
    copyRightLable.font = [UIFont fontWithName:@"OpenSans" size:12];
    [self.scrollview addSubview:copyRightLable];
    
    UILabel *textLable  = [[UILabel alloc]initWithFrame:CGRectMake(20, 124, 280, 60)];
    textLable.backgroundColor = [UIColor clearColor ];
    textLable.tag =5;
    textLable.textColor = UIColorFromRedGreenBlue(86, 83, 78);
    textLable.numberOfLines=0;
    textLable.text = @"Caxton FX – the foreign currency experts\n\nAs specialists in the field of foreign exchange, we’re committed to providing excellent value for money and great customer service. Our currency cards are the smarter way to take your money to money abroad, whilst our international payments service makes overseas money transfers fast, safe and easy.\n\nCURRENCY CARDS\n\nCarrying your travel money on our Visa currency cards means you could benefit from great value, enjoy easy and hassle-free spending abroad, buy and spend your holiday currency safely.\n\nHere's why getting a currency card is a great idea:\n\n• Competitive exchange rates\n• Free to use in shops, restaurants and other outlets worldwide*\n• Easy loading and reloading\n• ‘Chip & PIN’ security\n• Use anywhere you see the Visa sign\n\nINTERNATIONAL PAYMENTS\n\nOur online payment service provides a convenient, reliable and great value way to transfer currency to abroad.\nYou don’t need to rely on your bank to transfer money abroad. We can help you keep your costs down and take the hassle out of international payments.\n\n• Bank beating exchange rates\n• No overseas transfer fees or commission\n• Transfer £100 - £50,000 at the click of a  button\n• 24/7 online payment platform\n• Authorised and regulated by the FCA\n\nFor more information visit www.caxtonfx.com or call 0845 222 2639\n\n*Caxton FX does not charge a fee for international point of sale or international ATM transactions. However some merchants or ATMs may levy their own charges. Visa and the Visa Brand Mark are registered trademarks of Visa.\n\n\nIssuer text: Visa and the Visa Brand Mark are registered trademarks of Visa. Caxton FX currency cards are issued by R. Raphael & Sons plc, pursuant to licence from Visa Europe. R. Raphael & Sons plc is a UK Bank authorised by the Prudential Regulation Authority and regulated by the Financial Conduct Authority and the Prudential Regulation Authority (registration number 161302). Registered office at Albany Court Yard, 47/48 Piccadilly, London W1J 0LR, company registration number 01288938.";
    
   
    textLable.font = [UIFont fontWithName:@"OpenSans" size:13];
    [self.scrollview addSubview:textLable];

    CGSize maximumLabelSize = CGSizeMake(280,9999);
    
    CGSize expectedLabelSize = [textLable.text sizeWithFont:textLable.font
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:textLable.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = textLable.frame;
    newFrame.size.height = expectedLabelSize.height;
    textLable.frame = newFrame;
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UILabel *textLable = (UILabel *)[self.scrollview viewWithTag:5];
    [self.scrollview setContentSize:CGSizeMake(320, 124+textLable.frame.size.height+30)];
}

#pragma mark ------
#pragma mark IBAction Method

-(IBAction)shareBtnPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate showActionSheet];
}

-(void) setNavigationTitle:(NSString *) title
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f,200, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f,200,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:title];
    [view addSubview:titleLbl];
    
    [self.navigationItem setTitleView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
