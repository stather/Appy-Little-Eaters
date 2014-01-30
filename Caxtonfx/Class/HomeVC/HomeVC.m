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
    if(IS_HEIGHT_GTE_568)
    {
        [scrollView setFrame:CGRectMake(0, 77, 320, 326)];
    }else
    {
        [scrollView setFrame:CGRectMake(0, 33, 320, 326)];
    }
    [updateInfo setFont:[UIFont fontWithName:@"OpenSans" size:14]];
    textArray = [[NSMutableArray alloc]initWithObjects:@"Top up your currency card",@"Check your balance",@"Monitor your spending", nil];
    [self setUpPage];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    NSString *isfirstUser = [[NSUserDefaults standardUserDefaults]stringForKey:@"FirstTimeUser"];
    if([isfirstUser isEqualToString:@"NO"])
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"stayLogin"])
        {
            [self loginWebServices];
        }else
        {
            NSString *setPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPin"];
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
        [scrollView setFrame:CGRectMake(0, 77, 320, 326)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.customeTabBar.hidden = NO;
    appDelegate.topBarView.hidden= NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent=NO;
    }
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

-(void)callDefaultsApi
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetDefaults/></soapenv:Body></soapenv:Envelope>";
        [manger callServiceWithRequest:soapMessage methodName:@"GetDefaults" andDelegate:self];
    }
}

-(void)callgetGloableRateApi
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetGlobalRates/></soapenv:Body></soapenv:Envelope>";
        [manger callServiceWithRequest:soapMessage methodName:@"GetGlobalRates" andDelegate:self];
    }
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
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
     [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    // Get username from keychain (if it exists)
    NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
    if([CommonFunctions reachabiltyCheck])
    {
        if([[NSUserDefaults standardUserDefaults]doubleForKey:@"LoginnewTimeIntrval"])
        {
            double time = [[NSUserDefaults standardUserDefaults]doubleForKey:@"LoginnewTimeIntrval"];
            NSDate *currentdate = [NSDate date];
            double currentTimeIntrval = [currentdate timeIntervalSince1970];
            if(currentTimeIntrval>time){
                sharedManager *manger = [[sharedManager alloc]init];
                manger.delegate = self;
                delegate.window.userInteractionEnabled = NO;
                NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",username1,password1];
                
                [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
            }else
            {
                LoginAttamp = [[NSUserDefaults standardUserDefaults] integerForKey:@"LoginAttamp"];
                if(LoginAttamp<3)
                {
                    delegate.window.userInteractionEnabled = NO;
                    sharedManager *manger = [[sharedManager alloc]init];
                    manger.delegate = self;
                    
                    NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",username1,password1];
                    
                    [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
                }
            }
        }else
        {
            delegate.window.userInteractionEnabled = NO;
            sharedManager *manger = [[sharedManager alloc]init];
            manger.delegate = self;
            NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",username1,password1];
            [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
        }
    }else
    {
        [self performSelectorOnMainThread:@selector(goMyCardPage) withObject:nil waitUntilDone:nil];
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
    sleep(10);
    
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
        
    }else if([service isEqualToString:@"CheckAuthGetCards"])
    {
        NSLog(@"CheckAuthGetCards - > %@",response);
        NSMutableArray *array = [[NSMutableArray alloc]init];
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"CheckAuthGetCardsResponse" parentElement:rootItemElem];
        TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"CheckAuthGetCardsResult" parentElement:checkAuthGetCardsResponseElem];
        TBXMLElement *statusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
        NSString *statusCodeStr = [TBXML textForElement:statusCode];
        if([statusCodeStr intValue]== 000 || [statusCodeStr intValue]== 003)
        {
            TBXMLElement *DOBElem = [TBXML childElementNamed:@"a:bd" parentElement:checkAuthGetCardsResultElem];
            userDOBStr = [TBXML textForElement:DOBElem];
            
            KeychainItemWrapper *keychain1 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userDOB" accessGroup:nil];
            [keychain1 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain1 setObject:userDOBStr forKey:(__bridge id)kSecAttrAccount];
            [keychain1 setObject:userDOBStr forKey:(__bridge id)kSecValueData];
            
            TBXMLElement *contactTypeElem = [TBXML childElementNamed:@"a:contactType" parentElement:checkAuthGetCardsResultElem];
            userConactTypeStr = [TBXML textForElement:contactTypeElem];
            
                      
            KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
             [keychain2 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain2 setObject:userMobileStr forKey:(__bridge id)kSecAttrAccount];
            [keychain2 setObject:userMobileStr forKey:(__bridge id)kSecValueData];
            
            [[NSUserDefaults standardUserDefaults]setObject:userConactTypeStr forKey:@"userConactType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TBXMLElement *mobileElem = [TBXML childElementNamed:@"a:mobile" parentElement:checkAuthGetCardsResultElem];
            userMobileStr = [TBXML textForElement:mobileElem];
            
            if([statusCodeStr intValue]!= 003)
            {
                TBXMLElement *cardsElem = [TBXML childElementNamed:@"a:cards" parentElement:checkAuthGetCardsResultElem];
                if(cardsElem)
                {
                    TBXMLElement *CardElm    = [TBXML childElementNamed:@"a:card" parentElement:cardsElem];
                    while (CardElm != nil)
                    {
                        TBXMLElement *cardBalance   = [TBXML childElementNamed:@"a:CardBalance" parentElement:CardElm];
                        NSString *cardBalanceStr = [TBXML textForElement:cardBalance];
                        TBXMLElement *CardCurrencyDescription    = [TBXML childElementNamed:@"a:CardCurrencyDescription" parentElement:CardElm];
                        NSString *CardCurrencyDescriptionStr = [TBXML textForElement:CardCurrencyDescription];
                        TBXMLElement *CardCurrencyID    = [TBXML childElementNamed:@"a:CardCurrencyID" parentElement:CardElm];
                        NSString *CardCurrencyIDStr = [TBXML textForElement:CardCurrencyID];
                        TBXMLElement *CardCurrencySymbol    = [TBXML childElementNamed:@"a:CardCurrencySymbol" parentElement:CardElm];
                        NSString *CardCurrencySymbolStr = [TBXML textForElement:CardCurrencySymbol];
                        TBXMLElement *CardName    = [TBXML childElementNamed:@"a:CardName" parentElement:CardElm];
                        NSString *CardNameStr = [TBXML textForElement:CardName];
                        TBXMLElement *CardNumber    = [TBXML childElementNamed:@"a:CardNumber" parentElement:CardElm];
                        NSString *CardNumberStr = [TBXML textForElement:CardNumber];
                        TBXMLElement *CardType    = [TBXML childElementNamed:@"a:CardType" parentElement:CardElm];
                        NSString *CardTypeStr = [TBXML textForElement:CardType];
                        TBXMLElement *CurrencyCardID    = [TBXML childElementNamed:@"a:CurrencyCardID" parentElement:CardElm];
                        NSString *CurrencyCardIDStr = [TBXML textForElement:CurrencyCardID];
                        TBXMLElement *ProductTypeID    = [TBXML childElementNamed:@"a:ProductTypeID" parentElement:CardElm];
                        NSString *ProductTypeIDStr = [TBXML textForElement:ProductTypeID];
                        TBXMLElement *CurrencyCardTypeID    = [TBXML childElementNamed:@"a:CurrencyCardTypeID" parentElement:CardElm];
                        NSString *CurrencyCardTypeIDStr = [TBXML textForElement:CurrencyCardTypeID];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:cardBalanceStr,@"cardBalanceStr",CardCurrencyDescriptionStr,@"CardCurrencyDescriptionStr",CardCurrencyIDStr,@"CardCurrencyIDStr",CardCurrencySymbolStr,@"CardCurrencySymbolStr",CardNameStr,@"CardNameStr",CardNumberStr,@"CardNumberStr",CurrencyCardIDStr,@"CurrencyCardIDStr",ProductTypeIDStr,@"ProductTypeIDStr",CurrencyCardTypeIDStr ,@"CurrencyCardTypeIDStr",CardTypeStr,@"CardTypeStr", nil];
                        [array addObject:dict];
                        
                        CardElm = [TBXML nextSiblingNamed:@"a:card" searchFromElement:CardElm];
                    }
                }
                DatabaseHandler *DBHandler = [[DatabaseHandler alloc]init];
                [DBHandler executeQuery:@"DELETE FROM myCards" ];
                for(int i=0;i<array.count;i++)
                {
                    NSMutableDictionary *dict = [array objectAtIndex:i];
                    NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO myCards values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[dict objectForKey:@"CurrencyCardIDStr"],[dict objectForKey:@"CurrencyCardTypeIDStr"],[dict objectForKey:@"ProductTypeIDStr"],[dict objectForKey:@"CardCurrencyIDStr"],[dict objectForKey:@"cardBalanceStr"],[dict objectForKey:@"CardCurrencyDescriptionStr"],[dict objectForKey:@"CardCurrencySymbolStr"],[dict objectForKey:@"CardNameStr"],[dict objectForKey:@"CardNumberStr"],[dict objectForKey:@"CardTypeStr"],@"NO",@"NO"];
                        [DBHandler executeQuery:queryStr];
                }
                
            }
            NSDate *today = [NSDate date];
            dateInString = [today description];
            [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
                    
            [self performSelectorInBackground:@selector(callgetGloableRateApi) withObject:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];
        }
    }else if([service isEqualToString:@"GetGlobalRates"])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyflags_map" ofType:@"csv"];
        NSString *myText = nil;
        if (filePath) {
            myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
            if (myText) {
               
            }
        }
        NSArray *contentArray = [myText componentsSeparatedByString:@"\r"]; // CSV ends with ACSI 13 CR 
        NSMutableArray *codesMA = [NSMutableArray new];
        for (NSString *item in contentArray)
        {
            NSArray *itemArray = [item componentsSeparatedByString:@","];
            if ([itemArray count] > 3)
            {
                [codesMA addObject:[itemArray objectAtIndex:3]];
            }
        }
        NSMutableArray *glabalRatesMA  = [[NSMutableArray alloc] init];
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        if(rootItemElem)
        {
            TBXMLElement *subcategoryEle = [TBXML childElementNamed:@"GetGlobalRatesResponse" parentElement:rootItemElem];
            TBXMLElement * GetGlobalRatesResult = [TBXML childElementNamed:@"GetGlobalRatesResult" parentElement:subcategoryEle];
            TBXMLElement *expiryTime = [TBXML childElementNamed:@"a:expiryTime" parentElement:GetGlobalRatesResult];
            NSString *expiryTimeStr = [TBXML textForElement:expiryTime];
            [[NSUserDefaults standardUserDefaults]setObject:expiryTimeStr forKey:@"expiryTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            TBXMLElement *rates = [TBXML childElementNamed:@"a:rates" parentElement:GetGlobalRatesResult];
            if (rates)
            {
                TBXMLElement *CFXExchangeRate = [TBXML childElementNamed:@"a:CFXExchangeRate" parentElement:rates];
                while (CFXExchangeRate != nil) {
                    TBXMLElement *currencyCode = [TBXML childElementNamed:@"a:CcyCode" parentElement:CFXExchangeRate];
                    TBXMLElement *rate = [TBXML childElementNamed:@"a:Rate" parentElement:CFXExchangeRate];
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setObject:[TBXML textForElement:currencyCode] forKey:@"currencyCode"];
                    [dict setObject:[TBXML textForElement:rate] forKey:@"rate"];
                    int index = -1;
                    NSString *imageName = @"";
                    if ([codesMA containsObject:[dict objectForKey:@"currencyCode"]])
                    {
                        index=  [codesMA indexOfObject:[dict objectForKey:@"currencyCode"]];
                    }
                    if(index >=0)
                    {
                        NSString *item = [contentArray objectAtIndex:index];
                        NSArray *itemArray = [item componentsSeparatedByString:@","];
                        if (itemArray.count != 0) {
                            imageName =[[[itemArray objectAtIndex:1] lowercaseString] stringByAppendingFormat:@" - %@",[[itemArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
                        }
                    }
                    [dict setObject:imageName forKey:@"imageName"];
                    if (dict)
                    {
                        [glabalRatesMA addObject:dict];
                    }
                    CFXExchangeRate = [TBXML nextSiblingNamed:@"a:CFXExchangeRate" searchFromElement:CFXExchangeRate];
                    }
            }
            NSString *deleteQuerry = [NSString stringWithFormat:@"DELETE FROM globalRatesTable"];
            DatabaseHandler *database = [[DatabaseHandler alloc]init];
            [database executeQuery:deleteQuerry];
            for (NSMutableDictionary *dict in glabalRatesMA) {
                NSString *query = [NSString stringWithFormat:@"insert into globalRatesTable ('CcyCode','Rate','imageName') values ('%@',%f,'%@')",[dict objectForKey:@"currencyCode"] ,[[dict objectForKey:@"rate"] doubleValue],[dict objectForKey:@"imageName"]];
                [database executeQuery:query];
            }
        }
        [self callDefaultsApi];
    }
    else if ([service isEqualToString:@"GetDefaults"])
    {
        NSMutableArray *getDefaultDataArr  = [[NSMutableArray alloc] init];
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *getPromoResponseEle = [TBXML childElementNamed:@"GetDefaultsResponse" parentElement:rootItemElem];
        TBXMLElement *GetPromoResult = [TBXML childElementNamed:@"GetDefaultsResult" parentElement:getPromoResponseEle];
        TBXMLElement *GetPromoHtmlResult = [TBXML childElementNamed:@"a:products" parentElement:GetPromoResult];
        TBXMLElement *phoenproduct = [TBXML childElementNamed:@"a:PhoenixProduct" parentElement:GetPromoHtmlResult];
        while (phoenproduct != nil)
        {
            TBXMLElement *ccy = [TBXML childElementNamed:@"a:Ccy" parentElement:phoenproduct];
            TBXMLElement *description = [TBXML childElementNamed:@"a:Description" parentElement:phoenproduct];
            TBXMLElement *maxTopUp = [TBXML childElementNamed:@"a:MaxTopUp" parentElement:phoenproduct];
            TBXMLElement *maxTotalBalance = [TBXML childElementNamed:@"a:MaxTotalBalance" parentElement:phoenproduct];
            TBXMLElement *minTopUp = [TBXML childElementNamed:@"a:MinTopUp" parentElement:phoenproduct];
            TBXMLElement *productID = [TBXML childElementNamed:@"a:ProductID" parentElement:phoenproduct];
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            [tempDic setValue:[TBXML textForElement:ccy] forKey:@"ccy"];
            [tempDic setValue:[TBXML textForElement:description] forKey:@"description"];
            [tempDic setValue:[TBXML textForElement:maxTopUp] forKey:@"maxTopUp"];
            [tempDic setValue:[TBXML textForElement:maxTotalBalance] forKey:@"maxTotalBalance"];
            [tempDic setValue:[TBXML textForElement:minTopUp] forKey:@"minTopUp"];
            [tempDic setValue:[TBXML textForElement:productID] forKey:@"productID"];
            phoenproduct = [TBXML nextSiblingNamed:@"a:PhoenixProduct" searchFromElement:phoenproduct];
            [getDefaultDataArr addObject:tempDic];
        }
        NSString *deleteQuerry = [NSString stringWithFormat:@"DELETE FROM getDefaults"];
        DatabaseHandler *database = [[DatabaseHandler alloc]init];
        [database executeQuery:deleteQuerry];
                
        for (int i = 0; i < getDefaultDataArr.count ; i++)
        {
            NSString *query = [NSString stringWithFormat:@"insert into getDefaults values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[getDefaultDataArr objectAtIndex:i] valueForKey:@"ccy"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"description"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"maxTopUp"],[[getDefaultDataArr objectAtIndex:i] valueForKey:@"maxTotalBalance"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"minTopUp"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"productID"]];
                [database executeQuery:query];
        }
        UIButton *button = (UIButton*)[self.view viewWithTag:6];
        [button btnWithoutActivityIndicator];
        self.view.userInteractionEnabled = YES;
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.window.userInteractionEnabled = YES;
       [self performSelectorOnMainThread:@selector(goMyCardPage) withObject:nil waitUntilDone:nil];
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
