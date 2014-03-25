//
//  HomeVC.m
//  Caxtonfx
//
//  Created by XYZ on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "HomeVC.h"
#import "MoreInfoVC.h"
#import "LoginVC.h"
#import "MyCardVC.h"
#import "KeychainItemWrapper.h"
#import "UIButton+CustomDesign.h"
#import "UIButton+CustomDesign.h"
#import "FBEncryptorAES.h"
#import "AppDelegate.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "ContactVC.h"
#import "ConverterVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
@synthesize scrollView,textArray,currentElement;
@synthesize lodingView,updateInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)switchToMoreInfo:(NSNotification *)notification
{
    MoreInfoVC *mivc = [[MoreInfoVC alloc]init];
    [self.navigationController pushViewController:mivc animated:YES];
}

-(void)switchToLogin:(NSNotification *)notification
{
    LoginVC *loginVC = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"showLogin" object:nil];
}
- (void)userTextSizeDidChange {
	[self applyFonts];
}
- (void)applyFonts {
    self.updateInfo.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
	self.mainLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchToMoreInfo:)
                                                 name:@"showMoreInfo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchToLogin:)
                                                 name:@"showLogin"
                                               object:nil];
    
    [updateInfo setFont:[UIFont fontWithName:@"OpenSans" size:14]];
    textArray = [[NSMutableArray alloc]initWithObjects:@"Top up your currency card",@"Check your balance",@"Monitor your spending", nil];
    [self setUpPage];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    NSString *isfirstUser = [[NSUserDefaults standardUserDefaults]stringForKey:@"FirstTimeUser"];
    if([isfirstUser isEqualToString:@"NO"])
    {
        NSString *setPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPin"];
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"stayLogin"] && [setPin isEqualToString:@"NO"])
        {
            [self loginWebServices];
        }else
        {
            
            if([setPin isEqualToString:@"YES"])
            {
                KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
                [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
                NSString *str =   [wrapper objectForKey :(__bridge id)kSecValueData];
                
                PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                }
                passcodeViewController.skipStr = @"YES";
                passcodeViewController.delegate = self;
                passcodeViewController.simple = YES;
                passcodeViewController.passcode = str;
                [self.navigationController pushViewController:passcodeViewController animated:YES];
            }else
            {
                self.scrollView.alpha = 1.0;
                self.lodingView.alpha = 0.0;
                self.updateInfo.alpha = 0.0;
            }
        }
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self applyFonts];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userTextSizeDidChange)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
    [self.scrollView setFrame:CGRectMake(0, 0, 320, 326)];
}
-(IBAction)ConverterBtnPressed:(id)sender{
    
    ConverterVC *converterView = [[ConverterVC alloc]init];
    [self.navigationController pushViewController:converterView animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.customeTabBar.hidden = NO;
    appDelegate.topBarView.hidden= YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent=NO;
    }
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
     self.navigationItem.hidesBackButton = YES;
     self.navigationController.navigationBarHidden = NO;
     [CommonFunctions setNavigationTitle:@"Caxton FX" ForNavigationItem:self.navigationItem];
    
    /****** add custom right bar button (Refresh Button) at navigation bar  **********/
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"calculator-26.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ConverterBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 26, 26)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoAnimation) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)autoAnimation
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate autoAnimation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[AppDelegate getSharedInstance] topBarView] setHidden:YES];
    self.scrollView.alpha = 1.0;
    self.lodingView.alpha = 0.0;
    self.updateInfo.alpha = 0.0;
}
#pragma mark -----
#pragma mark IBAction Method

-(IBAction)moreInfoBtnPressed:(id)sender
{
    if ([CommonFunctions reachabiltyCheck])
    {
        UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [actView startAnimating];
        actView.frame = CGRectMake(10, 10, 10, 20);
        UIButton *btn = (UIButton*)sender;
        [btn addSubview:actView];
        self.view.userInteractionEnabled = NO;
        [self performSelectorInBackground:@selector(callGetPromoApi) withObject:nil];
    }else
    {
        MoreInfoVC *mivc = [[MoreInfoVC alloc]init];
        [self.navigationController pushViewController:mivc animated:YES];
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        self.view.userInteractionEnabled = YES;
        delegate.window.userInteractionEnabled = YES;
    }
}

-(void)callGetPromoApi
{
    sharedManager *manger = [[sharedManager alloc]init];
    manger.delegate = self;
    NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetPromo/></soapenv:Body></soapenv:Envelope>";
    [manger callServiceWithRequest:soapMessage methodName:@"GetPromo" andDelegate:self];
}
-(void)callgetGloableRateApi
{
    User *myUser = [User sharedInstance];
    if([CommonFunctions reachabiltyCheck])
    {
        myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
        myUser.defaultsArray = [myUser loadDefaultsWithRemote:YES];
    }else{
        myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
        myUser.defaultsArray = [myUser loadDefaultsWithRemote:NO];
    }
    UIButton *button = (UIButton*)[self.view viewWithTag:6];
    [button btnWithoutActivityIndicator];
    self.view.userInteractionEnabled = YES;
    [self performSelectorOnMainThread:@selector(goMyCardPage) withObject:nil waitUntilDone:nil];
}

-(void)loginWebServices
{
    self.scrollView.alpha=0.0;
    self.lodingView.alpha=1.0;
    self.updateInfo.alpha=1.0;
    [self.lodingView startAnimating];
    
    dateInString = [[NSUserDefaults standardUserDefaults]objectForKey:@"updateDate"];
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    self.updateInfo.text = [NSString stringWithFormat:@"Getting your account information ...\n%@",[CommonFunctions statusOfLastUpdate:date1]];
    
    [self performSelectorInBackground:@selector(callLoginApi) withObject:nil];
}

-(void)callLoginApi
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *keychain1 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userDOB" accessGroup:nil];
    [keychain1 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
    [keychain2 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    // Get username from keychain (if it exists)
    NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
    User *myUser=[User sharedInstance];
    myUser.username =username1;
    myUser.password =password1;
    
    myUser.contactType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userConactType"];
    myUser.dateOfBirth = [keychain1 objectForKey:(__bridge id)kSecValueData];
    myUser.mobileNumber = [keychain2 objectForKey:(__bridge id)kSecValueData];
    
    if([CommonFunctions reachabiltyCheck])
    {
        myUser.cards = [myUser loadCardsFromDatabasewithRemote:YES];
        myUser.transactions = [myUser loadTransactionsForUSer:@"" withRemote:YES];
        if ([myUser.statusCode isEqualToString:@"000"] || [myUser.statusCode isEqualToString:@"003"]) {
            [self performSelectorInBackground:@selector(callgetGloableRateApi) withObject:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];
        }
    }else{
        [self goMyCardPage];
    }
}

-(void)goMyCardPage
{
    [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] + 1) forKey:@"ApplaunchCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.lodingView stopAnimating];
    self.lodingView.alpha = 0.0;
    self.updateInfo.alpha = 0.0;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    MyCardVC *myCards = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
    [self.navigationController pushViewController:myCards animated:YES];
}

-(void)goMoreInfoPage
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.window.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    UIButton *btn = (UIButton*)[self.scrollView viewWithTag:13];
    [btn btnWithoutActivityIndicator];
    
    MoreInfoVC *mivc = [[MoreInfoVC alloc]init];
    [self.navigationController pushViewController:mivc animated:YES];
    [self performSelectorInBackground:@selector(getHtmlCache) withObject:nil];
    
    
}


-(void)getHtmlCache
{
    NSError *error = nil;
    NSString *htmlstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"moreInfoHtml"];
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlstr error:&error];
    if (error) {
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"img"];
    
    for (HTMLNode *inputNode in inputNodes) {
        
        NSURL *url = [NSURL URLWithString:[inputNode getAttributeNamed:@"src"]];
        
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
      
        UIImage *  img1 = [UIImage imageWithData:data];
        NSString *urlstr = [inputNode getAttributeNamed:@"src"];
        NSArray *parts = [urlstr componentsSeparatedByString:@"/"];
        NSString *filename = [parts objectAtIndex:[parts count]-1];
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        
        if (img1)
        {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",documentPath,filename]])
            {
           [data writeToFile:[NSString stringWithFormat:@"%@/%@",documentPath,filename] atomically:YES];
              
                htmlstr = [htmlstr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img src=\"%@\" />",urlstr] withString:[NSString stringWithFormat:@"<img src=\"%@\" />",filename]];
                
              
            }
                      
        }
        [[NSUserDefaults standardUserDefaults]setObject:htmlstr forKey:@"offlineHtml"];
     
    }
    
}
-(IBAction)LoginBtnPressed:(id)sender
{
    LoginVC *loginVC = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)setUpPage
{
    UILabel *welcomeLbl = (UILabel*)[self.scrollView viewWithTag:2];
    [welcomeLbl setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    int y =167;
    for(int i=0;i<textArray.count;i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, y+5, 8, 8)];
        imageView.image = [UIImage imageNamed:@"bulletLogo.png"];
        [self.scrollView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(38, y, 258, 20)];
        [lable setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        lable.lineBreakMode = NSLineBreakByWordWrapping;
        lable.numberOfLines = 0;
        lable.textColor = UIColorFromRedGreenBlue(86, 83, 78);
        lable.text = [textArray objectAtIndex:i];
        CGSize maximumLabelSize = CGSizeMake(258,9999);
        CGSize expectedLabelSize = [[textArray objectAtIndex:i] sizeWithFont:lable.font
                                                           constrainedToSize:maximumLabelSize
                                                               lineBreakMode:lable.lineBreakMode];
        
        CGRect newFrame = lable.frame;
        newFrame.size.height = expectedLabelSize.height;
        lable.frame = newFrame;
        
        y +=expectedLabelSize.height+2;
        [self.scrollView addSubview:lable];
    }
    
    UILabel *accountLbl = (UILabel *)[self.scrollView viewWithTag:11];
    [accountLbl setFont:[UIFont fontWithName:@"OpenSans" size:10]];
    accountLbl.frame = CGRectMake(99, y+8, 125, 14);
    
    y +=23;
    
    UILabel *useLbl = (UILabel *)[self.scrollView viewWithTag:12];
    [useLbl setFont:[UIFont fontWithName:@"OpenSans" size:10]];
    useLbl.frame = CGRectMake(52, y, 205, 14);
    
    y +=21;
    
    UIButton *moreInfoBtn = (UIButton *)[self.scrollView viewWithTag:13];
    moreInfoBtn.frame = CGRectMake(19, y+10, 140, 43);
    [moreInfoBtn setBackgroundImage:[UIImage imageNamed:@"HomeVCJoinBtn"] forState:UIControlStateNormal];
    [moreInfoBtn setBackgroundImage:[UIImage imageNamed:@"HomeVCJoinBtnHover"] forState:UIControlStateHighlighted];
    
    UIButton *loginBtn = (UIButton *)[self.scrollView viewWithTag:14];
    loginBtn.frame = CGRectMake(19+140, y+10, 142, 43);
    NSLog(@"y - %d",y);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"myCardLoginBtn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"myCardLoginBtnHover"] forState:UIControlStateHighlighted];
}

#pragma mark -----
#pragma mark shardemangerDelegate Method

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    if([service isEqualToString:@"GetPromo"])
    {
        NSLog(@"GetPromo -> %@",response);
        
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *getPromoResponseEle = [TBXML childElementNamed:@"GetPromoResponse" parentElement:rootItemElem];
        TBXMLElement *GetPromoResult = [TBXML childElementNamed:@"GetPromoResult" parentElement:getPromoResponseEle];
        TBXMLElement *GetPromoHtmlResult = [TBXML childElementNamed:@"html" parentElement:GetPromoResult];
        NSString *str = [TBXML textForElement:GetPromoHtmlResult];
        
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"moreInfoHtml"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelectorOnMainThread:@selector(goMoreInfoPage) withObject:nil waitUntilDone:NO];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2 ){
        if (buttonIndex == 0)
        {
            [self resetHome];
        }
    }
}
-(void)resetHome{
    NSString *query  = @"";
    
    query = @"DELETE FROM conversionHistoryTable ";
    DatabaseHandler *dataBaseHandler = [[DatabaseHandler alloc] init];
    [dataBaseHandler executeQuery:query];
    query = @"DELETE FROM getHistoryTable";
    [dataBaseHandler executeQuery:query];
    query = @"DELETE FROM myCards";
    [dataBaseHandler executeQuery:query ];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [documentsDirectory stringByAppendingPathComponent:@"patientPhotoFolder"];
    NSString *dataPath = patientPhotoFolder;
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:dataPath
                          isDirectory:&isDir] && isDir == NO) {
        [fileManager removeItemAtPath:dataPath error:nil];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"switchState"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstTimeUser"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginAttamp"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"attemp"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"stayLogin"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //reset the Home Screen
    self.scrollView.alpha=1.0;
    self.lodingView.alpha=0.0;
    self.updateInfo.alpha=0.0;
    [self.lodingView stopAnimating];
    self.view.userInteractionEnabled = YES;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.window.userInteractionEnabled = YES;

}
-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if([service isEqualToString:@"CheckAuthGetCards"] ||[service isEqualToString:@"GetPromo"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Please check your internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
    
}

-(void)performingUpdatesOnExpiryTime
{
    NSDate * now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * mile = [df dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"expiryTime"]];
    NSComparisonResult result = [now compare:mile];
    switch (result)
    {
        case NSOrderedAscending:
        {
             [self callgetGloableRateApi];
        }
            break;
            
        case NSOrderedDescending:
        {
            [self callgetGloableRateApi];
        }
        break;
            
        case NSOrderedSame:
        {
           [self callgetGloableRateApi];
        }
            break;
            
        default:
        {
            [self callgetGloableRateApi];
        }
            break;
    }
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller
{
    if([CommonFunctions reachabiltyCheck])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self loginWebServices];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self performSelectorOnMainThread:@selector(goMyCardPage) withObject:nil waitUntilDone:nil];
    }
}

-(void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
     [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.scrollView.alpha = 1.0;
    self.lodingView.alpha = 0.0;
    self.updateInfo.alpha = 0.0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
