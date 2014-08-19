//
//  MoreInfoVC.m
//  Caxtonfx
//
//  Created by Sumit on 16/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "MoreInfoVC.h"
#import "Validate.h"
#import "AppDelegate.h"
#import "UIButton+CustomDesign.h"

@interface MoreInfoVC ()

@end

@implementation MoreInfoVC

@synthesize scrollView,webView,demoView,wantJoinLbl,textLbl,firstTxtFld,lastTxtFld,emailTxtFld,waringLbl;

@synthesize staticLable;

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
    
    
    
    [self.view setAlpha:0.0f];
    
    if([CommonFunctions reachabiltyCheck]){
        [webView loadHTMLString:[[NSUserDefaults standardUserDefaults] valueForKey:@"moreInfoHtml"] baseURL:nil];}
    else
    {
        
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        NSURL *baseUrl = [NSURL fileURLWithPath:documentPath];
        [webView loadHTMLString:[[NSUserDefaults standardUserDefaults] valueForKey:@"offlineHtml"] baseURL:baseUrl];
    }
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [self setNavigationTitle:@"Join"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.delegate = self;
    [scrollView addGestureRecognizer:gestureRecognizer];
    
    AppDelegate *delegate = [AppDelegate getSharedInstance];
    delegate.customeTabBar.hidden = YES;
    
    [self setUpPage];
    self.waringLbl.text = @"";
    
    [Flurry logEvent:@"Visited More Info"];
     
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)backBtnPressed:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}
-(void)setUpPage
{
    if(IS_HEIGHT_GTE_568)
    {
        [scrollView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 504)];
    }
    [wantJoinLbl setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    
    [textLbl setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    
    [self.staticLable setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    
    [waringLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:10]];
}

- (void) scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGFloat y = viewCenterY +  webView.frame.size.height-120;
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark -----------
#pragma mark IBAction Method

-(IBAction)sendBtnPressed:(id)sender
{
    if([CommonFunctions reachabiltyCheck])
    {
        if([firstTxtFld.text length]==0) {
            [firstTxtFld becomeFirstResponder];
            waringLbl.text = @"Please enter first name.";
        } else if(lastTxtFld.text.length == 0) {
            waringLbl.text = @"Please enter last name.";
            [lastTxtFld becomeFirstResponder];
        } else if(emailTxtFld.text.length == 0 || ![Validate isValidEmailId:emailTxtFld.text]) {
            waringLbl.text = @"Please enter valid email ID.";
            [emailTxtFld becomeFirstResponder];
        } else {
            waringLbl.text = @"";
            UIImageView *firstImgView = (UIImageView *)[self.demoView viewWithTag:13];
            UIImageView *secondImgView = (UIImageView *)[self.demoView viewWithTag:14];
            UIImageView *thrdImgView = (UIImageView *)[self.demoView viewWithTag:15];
            firstImgView.hidden = YES;
            secondImgView.hidden = YES;
            thrdImgView.hidden = YES;
            [(UIButton*)sender btnWithOutCrossImage];
            [(UIButton*)sender btnWithActivityIndicator];
            [Flurry logEvent:@"User sent Join Request"];
            [self sendRequest];
        }
    } else {
        self.waringLbl.text = @"Unfortunately there is no network connection at the moment so we cannot send your request, Please try again later.";
        [(UIButton*)sender btnWithCrossImage];
    }
}

-(void)sendRequest
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage =[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:SendContact><tem:emailAddress>%@</tem:emailAddress><tem:firstName>%@</tem:firstName><tem:lastName>%@</tem:lastName></tem:SendContact></soapenv:Body></soapenv:Envelope>",emailTxtFld.text,firstTxtFld.text,lastTxtFld.text];
        [manger callServiceWithRequest:soapMessage methodName:@"SendContact" andDelegate:self];
    }else
    {
        self.waringLbl.text = @"Unfortunately there is no network connection at the moment so we cannot send your request, Please try again later.";
    }
}

-(void) hideKeyBoard:(id) sender
{
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, webView.frame.size.height) animated:YES];
}


#pragma mark ------
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)thewebView
{
    int height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] integerValue];
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, height);
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    CGRect frame = demoView.frame;
    frame.origin.y = height;
    demoView.frame = frame;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, height+514);
    [self.view setAlpha:1.0f];
}

#pragma mark -------
#pragma mark ShareDelegete method call

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    TBXML *tbxml = [TBXML tbxmlWithXMLString:response];
    TBXMLElement *root = tbxml.rootXMLElement;
    TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
    TBXMLElement *SendContactResponse = [TBXML childElementNamed:@"SendContactResponse" parentElement:rootItemElem];
    TBXMLElement *SendContactResult = [TBXML childElementNamed:@"SendContactResult" parentElement:SendContactResponse];
    NSString *SendContactResultStr = [TBXML textForElement:SendContactResult];
    if([SendContactResultStr isEqualToString:@"true"])
    {
        UIButton *button = (UIButton*)[self.demoView viewWithTag:50];
        [button btnSuccess];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Thanks for getting in touch. We'll contact you shortly." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
       
    }else
    {
        UIButton *button = (UIButton*)[self.demoView viewWithTag:50];
        [button errorSendButtonImage];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    alertView.delegate = nil;
    [self GoBackView];
}
-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]]) {
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    }else{
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    }
    self.waringLbl.text = @"Unfortunately your service is not available at the moment. Please try again later.";
    UIButton *button = (UIButton*)[self.demoView viewWithTag:50];
    [button btnWithoutActivityIndicator];
    [button btnWithCrossImage];
}

-(void)GoBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------
#pragma mark UITextDelegateField Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIImageView *thrdImgView = (UIImageView *)[self.demoView viewWithTag:15];
    if(textField==firstTxtFld)
    {
        if(firstTxtFld.text.length>0)
        {
            waringLbl.text = @"";
            [lastTxtFld becomeFirstResponder];
        }
        else
        {
            waringLbl.text =@"Please enter first name.";
            return NO;
        }
    }else if(textField==lastTxtFld)
    {
        if(lastTxtFld.text.length>0)
        {
            waringLbl.text = @"";
            [emailTxtFld becomeFirstResponder];
        }
        else
        {
            waringLbl.text =@"Please enter last name.";
            return NO;
        }
    }else
    {
        if(emailTxtFld.text.length>0 && [Validate isValidEmailId:emailTxtFld.text])
        {
            waringLbl.text = @"";
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [emailTxtFld resignFirstResponder];
            thrdImgView.hidden = YES;
            return YES;
        }else
        {
            waringLbl.text =@"Please enter valid emailID.";
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollViewToCenterOfScreen:textField];
    
    UIImageView *firstImgView = (UIImageView *)[self.demoView viewWithTag:13];
    UIImageView *secondImgView = (UIImageView *)[self.demoView viewWithTag:14];
    UIImageView *thrdImgView = (UIImageView *)[self.demoView viewWithTag:15];
    if(textField==firstTxtFld)
    {
        firstImgView.hidden = NO;
        secondImgView.hidden= YES;
        thrdImgView.hidden = YES;
    }else if(textField==lastTxtFld)
    {
        firstImgView.hidden = YES;
        secondImgView.hidden= NO;
        thrdImgView.hidden = YES;
    }else
    {
        firstImgView.hidden = YES;
        secondImgView.hidden= YES;
        thrdImgView.hidden = NO;
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
