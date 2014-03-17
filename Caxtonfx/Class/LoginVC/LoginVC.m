//
//  LoginVC.m
//  CaxtonFx
//
//  Created by XYZ on 05/04/13.
//  Copyright (c) 2013 Konstant Info Solutions. All rights reserved.
//

#import "LoginVC.h"
#import "KeychainItemWrapper.h"
#import "FBEncryptorAES.h"
#import "Validate.h"
#import "UIButton+CustomDesign.h"
#import "UITextField+CustomTextBox.h"
#import "MoblieNoCheckedVC.h"
#import "UIButton+CustomDesign.h"
#import "MyCardVC.h"
#import "AppDelegate.h"
#import "AddMobileNoVC.h"
#import "User.h"
#import "Card.h"
#import "ContactVC.h"
#import "ConverterVC.h"
@interface LoginVC ()

@end

@implementation LoginVC

@synthesize emailTxtFld, passwordTxtFld;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ----
#pragma mark AppLifeCycle Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    isRemember = NO;
    [self SetUpDesginPage];
    
    /****** add custom right bar button (Refresh Button) at navigation bar  **********/
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"calculator-26.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ConverterBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 26, 26)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;

    
    //FORCE STAY LOGGED IN
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"stayLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [Flurry logEvent:@"Visited Login"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
    [CommonFunctions setNavigationTitle:@"Log in" ForNavigationItem:self.navigationItem];
    UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
    [logInBtn btnWithOutCheckImage];
    [logInBtn btnWithOutCrossImage];
    [emailTxtFld removeData];
    [passwordTxtFld removeData];
    AppDelegate *appDeleget = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDeleget.topBarView.hidden= YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.navigationController.navigationBar.translucent=NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(IBAction)ContactBtnPressed:(id)sender{
    ContactVC *contactView = [[ContactVC alloc]init];
    [self.navigationController pushViewController:contactView animated:YES];
}
-(IBAction)ConverterBtnPressed:(id)sender{
    
    ConverterVC *converterView = [[ConverterVC alloc]init];
    [self.navigationController pushViewController:converterView animated:YES];
}
#pragma mark -----------
#pragma mark SetUp - DesginPage Method

-(void) SetUpDesginPage
{
    UILabel *topHeadLineLbl = (UILabel *) [self.view viewWithTag:1];
    [topHeadLineLbl setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
    UILabel *rememberLbl = (UILabel *) [self.view viewWithTag:4];
    [rememberLbl setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
    UIButton *infoBtn = (UIButton *) [self.view viewWithTag:7];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"cancelBtnLogin"] forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"cancelBtnSelectedLogin"] forState:UIControlStateHighlighted];
    UIButton *loginBtn = (UIButton *) [self.view viewWithTag:6];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtnSelected"] forState:UIControlStateHighlighted];
    UILabel *errorLable = (UILabel*)[self.view viewWithTag:10];
    [errorLable setFont:[UIFont fontWithName:@"OpenSans-Bold" size:11]];
    errorLable.textColor = UIColorFromRedGreenBlue(213, 32, 39);
    emailTxtFld.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
    emailTxtFld.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    passwordTxtFld.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
    passwordTxtFld.textColor = UIColorFromRedGreenBlue(102, 102, 102);
}

#pragma mark -----------
#pragma mark IBAction Method

-(IBAction) rememberBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    isRemember = !isRemember;
    UIImageView *chekBoxImgView = (UIImageView*)[self.view viewWithTag:5];
    if(isRemember)
        chekBoxImgView.image = [UIImage imageNamed:@"checkboxSelectedRed"];
    else
        chekBoxImgView.image = [UIImage imageNamed:@"checkboxUnselected"];
    
    [[NSUserDefaults standardUserDefaults]setBool:isRemember forKey:@"stayLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(IBAction) loginBtnPressed:(id)sender
{
    UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
    [logInBtn btnWithOutCrossImage];
    if ([CommonFunctions reachabiltyCheck])
    {
        if ((emailTxtFld.text.length==0) && (passwordTxtFld.text.length==0))
        {
            [self showErrorMsg:@"Username and Password must be entered."];
            [self loginWithAppAccount:4];
            loginCrossImgView.hidden=NO;
            [emailTxtFld becomeFirstResponder];
            [self resetFields];
        }
        else if([emailTxtFld.text length]==0)
        {
            [self showErrorMsg:@"Please enter the username."];
            [self loginWithAppAccount:0];
            loginCrossImgView.hidden=NO;
            [emailTxtFld incorrectDataTxtFld];
        }
        else if (![Validate isValidUserName:emailTxtFld.text])
        {
            [self showErrorMsg:@"Unfortunately the entered username is not valid. Please try again."];
            [self loginWithAppAccount:0];
            loginCrossImgView.hidden=NO;
            [emailTxtFld incorrectDataTxtFld];
        }
        else if ([passwordTxtFld.text length] > 200)
        {
            [self showErrorMsg:@"Unfortunately the entered password must be less than 200 characters. Please try again."];
            [self loginWithAppAccount:1];
            loginCrossImgView.hidden=NO;
            [passwordTxtFld becomeFirstResponder];
            [passwordTxtFld incorrectDataTxtFld];
        }
        else if([passwordTxtFld.text length]==0)
        {
            
            [self showErrorMsg:@"Please enter the password."];
            
            [self loginWithAppAccount:1];
            loginCrossImgView.hidden=NO;
            [passwordTxtFld becomeFirstResponder];
            [passwordTxtFld incorrectDataTxtFld];
        }
        else
        {
            [self loginWithAppAccount:4];
            [logInBtn btnWithActivityIndicator];
            [self.view endEditing:YES];
            [NSThread detachNewThreadSelector:@selector(sendLoginReqToServer) toTarget:self withObject:nil];
            [Flurry logEvent:@"User did a Login attempt."];
        }
    }
    else
    {
        [self showErrorMsg:@"Unfortunately there is no connection available at the moment. Please try again later."];
        [self loginWithAppAccount:4];
    }
    
}


-(void)sendLoginReqToServer
{
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
                
                NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",emailTxtFld.text,passwordTxtFld.text];
                [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
            }else
            {
                LoginAttamp = [[NSUserDefaults standardUserDefaults] integerForKey:@"LoginAttamp"];
                if(LoginAttamp<3)
                {
                    sharedManager *manger = [[sharedManager alloc]init];
                    manger.delegate = self;
                    NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",emailTxtFld.text,passwordTxtFld.text];
                    [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
                }else
                {
                    [self showErrorMsg:@"Your Caxton FX account has been locked. To unlock your account please email info@caxtonfxcard.com"];
                }
            }
        }else
        {
            sharedManager *manger = [[sharedManager alloc]init];
            manger.delegate = self;
            
            NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",emailTxtFld.text,passwordTxtFld.text];
            [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
        }
    }else
    {
        [self showErrorMsg:@"Unfortunately there is no connection available at the moment. Please try again later."];
    }
}


-(void)resetFields
{
    UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
    [emailTxtFld removeData];
    [passwordTxtFld removeData];
    [self loginWithAppAccount:4];
    loginCrossImgView.hidden=YES;
    [logInBtn btnWithOutCrossImage];
}
/*
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
*/

-(void)callgetGloableRateApi
{
    User *myUser = [User sharedInstance];
    if([CommonFunctions reachabiltyCheck])
    {
        myUser.globalRates = [myUser loadGlobalRatesWithRemote:YES];
        myUser.defaultsArray = [myUser loadDefaultsWithRemote:YES];
    }else{
        myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
        myUser.defaultsArray = [myUser loadDefaultsWithRemote:NO];
    }
    UIButton *button = (UIButton*)[self.view viewWithTag:6];
    [button btnWithoutActivityIndicator];
    [self startSendingReq:button];
}


-(void)startSendingReq:(UIButton *)btn
{
    DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyid-symbol-map" ofType:@"csv"];
    NSString *myText = nil;
    if (filePath) {
        myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
        if (myText) {
            [dbHandler executeQuery:@"delete from currencySymbole_table"];
            NSArray *contentArray = [myText componentsSeparatedByString:@"\r"];
            for (NSString *item in contentArray)
            {
                NSArray *itemArray = [item componentsSeparatedByString:@","];
                // log first item
                if ([itemArray count] > 3)
                {
                    NSString *mainSTr = [itemArray objectAtIndex:2];
                    NSString *cId = [itemArray objectAtIndex:0];
                    NSString * cIdStr = [cId stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    
                    NSString *querryStr = [NSString stringWithFormat:@"insert into currencySymbole_table values (\"%@\",\"%@\"); ",cIdStr,mainSTr];
                    [dbHandler executeQuery:querryStr];
                }
            }
            
        }
    }
    [btn btnWithActivityIndicator];
    [btn btnWithOutCrossImage];
    [btn btnSuccess];
    [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] + 1) forKey:@"ApplaunchCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelectorOnMainThread:@selector(goTopupScreen) withObject:nil waitUntilDone:nil];
    [self showErrorMsg:@""];
}

-(void)goTopupScreen
{
    NSString *isfirstUser = [[NSUserDefaults standardUserDefaults]stringForKey:@"FirstTimeUser"];
    if(![isfirstUser isEqualToString:@"NO"])
    {
        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionSet];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        passcodeViewController.skipStr = @"YES";
        passcodeViewController.delegate = self;
        passcodeViewController.simple = YES;
        [self.navigationController pushViewController:passcodeViewController animated:YES];
    }else
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        MyCardVC *cardVC = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
        [self.navigationController pushViewController:cardVC animated:YES];
    }
}

-(IBAction) forgotpasswordBtnPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.caxtonfxcard.com/secure_cfxcard/cfxcard_password_forget.aspx"]];
}

-(IBAction) moreInfoBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showErrorMsg:(NSString *)errorString
{
    UILabel *errorLable = (UILabel*)[self.view viewWithTag:10];
    errorLable.text = errorString;
    errorLable.hidden = NO;
    UIButton *btn = (UIButton*)[self.view viewWithTag:6];
    [btn btnWithoutActivityIndicator];
}

-(void)showMsg:(NSString *)errorString
{
    UILabel *errorLable = (UILabel*)[self.view viewWithTag:10];
    errorLable.text = errorString;
    errorLable.hidden = NO;
    UIButton *btn = (UIButton*)[self.view viewWithTag:6];
    [btn btnWithoutActivityIndicator];
    [btn btnWithCrossImage];
    [emailTxtFld incorrectDataTxtFld];
    [passwordTxtFld incorrectDataTxtFld];
}

-(void)loginWithAppAccount:(NSInteger)BtnTag
{
    UIImageView *emailErrorimgView = (UIImageView *)[self.view viewWithTag:13];
    UIImageView *passwordErrorimgView = (UIImageView *)[self.view viewWithTag:12];
    
    if (BtnTag==0)
    {
        loginCrossImgView.hidden=NO;
        emailErrorimgView .hidden=NO;
        passwordErrorimgView.hidden=YES;
    }
    else if(BtnTag==1)
    {
        loginCrossImgView.hidden=NO;
        emailErrorimgView.hidden=YES;
        passwordErrorimgView.hidden=NO;
    }
    else if(BtnTag==3)
    {
        loginCrossImgView.hidden=NO;
        emailErrorimgView.hidden=NO;
        passwordErrorimgView.hidden=NO;
    }
    else if(BtnTag==4)
    {
        passwordErrorimgView.hidden=YES;
        loginCrossImgView.hidden=YES;
        emailErrorimgView.hidden=YES;
    }
}


#pragma mark ------
#pragma mark sharedManagerDelegate

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    if([service isEqualToString:@"CheckAuthGetCards"])
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"CheckAuthGetCardsResponse" parentElement:rootItemElem];
        TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"CheckAuthGetCardsResult" parentElement:checkAuthGetCardsResponseElem];
        TBXMLElement *statusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
        NSString *statusCodeStr = [TBXML textForElement:statusCode];
        if([statusCodeStr intValue]== 000 || [statusCodeStr intValue]== 003 || [statusCodeStr intValue]== 004)
        {
            TBXMLElement *DOBElem = [TBXML childElementNamed:@"a:bd" parentElement:checkAuthGetCardsResultElem];
            userDOBStr = [TBXML textForElement:DOBElem];
            KeychainItemWrapper *keychain1 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userDOB" accessGroup:nil];
            [keychain1 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain1 setObject:userDOBStr forKey:(__bridge id)kSecAttrAccount];
            [keychain1 setObject:userDOBStr forKey:(__bridge id)kSecValueData];
            TBXMLElement *contactTypeElem = [TBXML childElementNamed:@"a:contactType" parentElement:checkAuthGetCardsResultElem];
            userConactTypeStr = [TBXML textForElement:contactTypeElem];
            [[NSUserDefaults standardUserDefaults]setObject:userConactTypeStr forKey:@"userConactType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            TBXMLElement *mobileElem = [TBXML childElementNamed:@"a:mobile" parentElement:checkAuthGetCardsResultElem];
            userMobileStr = [TBXML textForElement:mobileElem];
            KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
            [keychain2 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain2 setObject:userMobileStr forKey:(__bridge id)kSecAttrAccount];
            [keychain2 setObject:userMobileStr forKey:(__bridge id)kSecValueData];
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
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                         [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LoginAttamp"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
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
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"updateDate"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // this work is done for remove histrory when user not set pin or remove pin
                NSString *query  = @"";
                query = @"DELETE FROM conversionHistoryTable ";
                DatabaseHandler *dataBaseHandler = [[DatabaseHandler alloc]init];
                [dataBaseHandler executeQuery:query];
                query = [NSString stringWithFormat:@"DELETE FROM getHistoryTable"];
                [dataBaseHandler executeQuery:query];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
                // this is done for the remove history data.
                KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
                [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
                // Get username from keychain (if it exists)
                NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
                NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
                if (!([username1 isEqualToString:emailTxtFld.text]  && [password1 isEqualToString:passwordTxtFld.text]))
                {
                    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
                    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
                    // Store username to keychain
                    [keychain setObject:emailTxtFld.text forKey:(__bridge id)kSecAttrAccount];
                    // Store password to keychain
                    [keychain setObject:passwordTxtFld.text forKey:(__bridge id)kSecValueData];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"switchState"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPin"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstTimeUser"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginAttamp"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"attemp"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self  callgetGloableRateApi];
            }else{
                // this work is done for remove histrory when user not set pin or remove pin
                NSString *query  = @"";
                query = @"DELETE FROM conversionHistoryTable ";
                DatabaseHandler *dataBaseHandler = [[DatabaseHandler alloc]init];
                [dataBaseHandler executeQuery:query];
                query = [NSString stringWithFormat:@"DELETE FROM getHistoryTable"];
                [dataBaseHandler executeQuery:query];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
                // this is done for the remove history data.
                KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
                [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
                // Get username from keychain (if it exists)
                NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
                NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
                if (!([username1 isEqualToString:emailTxtFld.text]  && [password1 isEqualToString:passwordTxtFld.text]))
                {
                    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
                    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
                    // Store username to keychain
                    [keychain setObject:emailTxtFld.text forKey:(__bridge id)kSecAttrAccount];
                    // Store password to keychain
                    [keychain setObject:passwordTxtFld.text forKey:(__bridge id)kSecValueData];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"switchState"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPin"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstTimeUser"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginAttamp"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"attemp"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self  callgetGloableRateApi];
            }
            
            //POPULATE USER SINGLETON OBJECT
            KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
            [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            // Get username from keychain (if it exists)
            NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
            NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
            User *myUser=[User sharedInstance];
            myUser.cards = [myUser loadCardsFromDatabasewithRemote:NO];
            myUser.username =username1;
            myUser.password =password1;
            myUser.statusCode = statusCodeStr;
            myUser.contactType = userConactTypeStr;
            myUser.dateOfBirth = userDOBStr;
            myUser.mobileNumber = userMobileStr;
            myUser.transactions = [myUser loadTransactionsForUSer:@"" withRemote:YES];
        }else //it is not 000
        {
            if([statusCodeStr intValue]== 002)
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if([userDefaults doubleForKey:@"LoginTimeInterval"])
                {
                    double firstAttamp = [userDefaults doubleForKey:@"LoginTimeInterval"];
                    NSDate *currentdate = [NSDate date];
                    double currentTimeIntrval = [currentdate timeIntervalSince1970];
                    double newTimeIntrval = [userDefaults doubleForKey:@"LoginnewTimeIntrval"];
                    if(currentTimeIntrval>firstAttamp && currentTimeIntrval<newTimeIntrval)
                    {
                        LoginAttamp = [userDefaults integerForKey:@"LoginAttamp"];
                        LoginAttamp = LoginAttamp +1;
                        [userDefaults setInteger:LoginAttamp forKey:@"LoginAttamp"];
                    }else
                    {
                        NSDate *currentdate = [NSDate date];
                        double currentTimeIntrval = [currentdate timeIntervalSince1970];
                        NSDate *newDate = [currentdate dateByAddingTimeInterval:60*60*24];
                        NSLog(@"%@",newDate);
                        double newTimeIntrval = [newDate timeIntervalSince1970];
                        [userDefaults setDouble:currentTimeIntrval forKey:@"LoginTimeInterval"];
                        [userDefaults setDouble:newTimeIntrval forKey:@"LoginnewTimeIntrval"];
                        [userDefaults setInteger:1 forKey:@"LoginAttamp"];
                        LoginAttamp = 1;
                        [userDefaults synchronize];
                    }
                }
                else
                {
                    NSDate *currentdate = [NSDate date];
                    double currentTimeIntrval = [currentdate timeIntervalSince1970];
                    NSDate *newDate = [currentdate dateByAddingTimeInterval:60*60*24];
                    double newTimeIntrval = [newDate timeIntervalSince1970];
                    [userDefaults setDouble:currentTimeIntrval forKey:@"LoginTimeInterval"];
                    [userDefaults setDouble:newTimeIntrval forKey:@"LoginnewTimeIntrval"];
                    [userDefaults setInteger:1 forKey:@"LoginAttamp"];
                    [userDefaults synchronize];
                    LoginAttamp = 1;
                }
                preferredCurrency = @"GBP";
                [userDefaults setObject:@"GBP" forKey:@"defaultCurrency"];
                [userDefaults setObject:@"flag" forKey:@"defaultCurrencyImage"];
                [userDefaults synchronize];
            }
            if([statusCodeStr intValue]==005)
            {
                [self showErrorMsg:@"Your Caxton FX account has been locked. To unlock your account please email info@caxtonfxcard.com"];
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Lock"];
                UIButton *button = (UIButton*)[self.view viewWithTag:6];
                [button btnWithoutActivityIndicator];
                [button btnWithCrossImage];
                [emailTxtFld incorrectDataTxtFld];
                [passwordTxtFld incorrectDataTxtFld];
            }else
            {
                NSLog(@"LoginAttamp - > %d",LoginAttamp);
                if(LoginAttamp == 1 || LoginAttamp == 0)
                    [self showErrorMsg:@"Your username or password cannot be verifield please try again."];
                else if (LoginAttamp == 2)
                    [self showErrorMsg:@"Your username or password cannot be verified please try again. If you are unsure of your password please use the link above to reset it."];
                
                UIButton *button = (UIButton*)[self.view viewWithTag:6];
                [button btnWithoutActivityIndicator];
                [button btnWithCrossImage];
                [emailTxtFld incorrectDataTxtFld];
                [passwordTxtFld incorrectDataTxtFld];
            }
        }
    }
  
}

-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]])
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    else
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    
    [self showErrorMsg:@"Unfortunately our service is not available at the moment. But please do try again later."];
    UIButton *button = (UIButton*)[self.view viewWithTag:6];
    [button btnWithoutActivityIndicator];
    [button btnWithCrossImage];
}

#pragma mark --------
#pragma mark Passcode Delegate Method

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller {
   
    NSString *valueToSave = @"YES";
    [[NSUserDefaults standardUserDefaults]setObject:valueToSave forKey:@"setPin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *passcodeStr = controller.passcode ;
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
    [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    // Store password to keychain
    [wrapper setObject:[NSString stringWithFormat:@"%@",@"CFX"] forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:[NSString stringWithFormat:@"%@",passcodeStr] forKey:(__bridge id)kSecValueData];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"switchState"];
    KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
    NSString *suStr = [keychain2 objectForKey:(__bridge id)kSecAttrAccount];
    if (suStr == (id)[NSNull null] || suStr.length == 0 )
    {
        AddMobileNoVC *addVC = [[AddMobileNoVC alloc]initWithNibName:@"AddMobileNoVC" bundle:nil];
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        MoblieNoCheckedVC *mobileVC = [[MoblieNoCheckedVC alloc]initWithNibName:@"MoblieNoCheckedVC" bundle:nil];
        [self.navigationController pushViewController:mobileVC animated:YES];
    }
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller
{
    UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
    [logInBtn btnWithActivityIndicator];
    [self.view setUserInteractionEnabled:NO];
    [NSThread detachNewThreadSelector:@selector(sendLoginReqToServer) toTarget:nil withObject:nil];
}

- (void)PAPasscodeViewControllerDidFogetPasscode:(PAPasscodeViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    NSString *valueToSave = @"NO";
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"switchState"];
    [[NSUserDefaults standardUserDefaults]setObject:valueToSave forKey:@"setPin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
    NSString *suStr = [keychain2 objectForKey:(__bridge id)kSecAttrAccount];
    if (suStr == (id)[NSNull null] || suStr.length == 0 )
    {
        AddMobileNoVC *addVC = [[AddMobileNoVC alloc]initWithNibName:@"AddMobileNoVC" bundle:nil];
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        MoblieNoCheckedVC *mobileVC = [[MoblieNoCheckedVC alloc]initWithNibName:@"MoblieNoCheckedVC" bundle:nil];
        [self.navigationController pushViewController:mobileVC animated:YES];
    }
}

#pragma mark ----
#pragma mark UITextFieldDelegateMethod

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIImageView *emailErrorimgView = (UIImageView *)[self.view viewWithTag:13];
    UIImageView *passwordErrorimgView = (UIImageView *)[self.view viewWithTag:12];
    if(![Validate isValidUserName:emailTxtFld.text])
    {
        [self loginWithAppAccount:0];
        [self showErrorMsg:@"Unfortunately the entered username is not valid. Please try again."];
        [emailTxtFld incorrectDataTxtFld];
        return NO;
    }
    else if ([emailTxtFld.text length]== 0)
    {
        [self loginWithAppAccount:0];
        [self showErrorMsg:@"Unfortunately the entered username is not valid. Please try again."];
        [emailTxtFld incorrectDataTxtFld];
        return NO;
    }
    else if ((textField == emailTxtFld) && [Validate isValidUserName:emailTxtFld.text] && (![emailTxtFld.text length]== 0))
    {
        emailErrorimgView.hidden = YES;
        [self showErrorMsg:@""];
        [passwordTxtFld becomeFirstResponder];
    }
    else if ((textField == passwordTxtFld) && (!passwordTxtFld.text.length>0))
    {
        [self showErrorMsg:@"Please enter the password."];
        passwordErrorimgView.hidden = NO;
        [passwordTxtFld incorrectDataTxtFld];
        [self loginWithAppAccount:1];
        return  NO;
    }
    else if((textField == passwordTxtFld) &&  ([passwordTxtFld.text length] > 200))
    {
        emailErrorimgView.hidden = YES;
        passwordErrorimgView.hidden = NO;
        [self showErrorMsg:@"Unfortunately the entered password must be less than 200 characters. Please try again."];
        [passwordTxtFld incorrectDataTxtFld];
        return NO;
    }else if((textField == passwordTxtFld) &&  [Validate isValidPassword:passwordTxtFld.text]){
        passwordErrorimgView.hidden = YES;
        [textField resignFirstResponder];
        UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
        [self loginBtnPressed:logInBtn];
        return YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    UIImageView *emailErrorimgView = (UIImageView *)[self.view viewWithTag:13];
    UIImageView *passwordErrorimgView = (UIImageView *)[self.view viewWithTag:12];
    if(![Validate isValidUserName:emailTxtFld.text])
    {
        [self loginWithAppAccount:0];
        [self showErrorMsg:@"Unfortunately the entered username is not valid. Please try again."];
        [emailTxtFld incorrectDataTxtFld];
    }
    else if ([emailTxtFld.text length]== 0)
    {
        [self loginWithAppAccount:0];
        [self showErrorMsg:@"Unfortunately the entered username is not valid. Please try again."];
        [emailTxtFld incorrectDataTxtFld];
    }
    else if ((textField == emailTxtFld) && [Validate isValidUserName:emailTxtFld.text] && (![emailTxtFld.text length]== 0))
    {
        emailErrorimgView.hidden = YES;
        
        [self showErrorMsg:@""];
    }
    else if ((textField == passwordTxtFld) && (!passwordTxtFld.text.length>0))
    {
        passwordErrorimgView.hidden = NO;
        [self showErrorMsg:@"Please enter the password."];
        [passwordTxtFld incorrectDataTxtFld];
        [self loginWithAppAccount:1];
    }
    else if((textField == passwordTxtFld) &&  ([passwordTxtFld.text length] > 200))
    {
        passwordErrorimgView.hidden = NO;
        emailErrorimgView.hidden = YES;
        [self showErrorMsg:@"Unfortunately the entered password must be less than 200 characters. Please try again."];
        [passwordTxtFld incorrectDataTxtFld];
    }else if((textField == passwordTxtFld) &&  [Validate isValidPassword:passwordTxtFld.text]){
        passwordErrorimgView.hidden = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    UIImageView *emailErrorimgView = (UIImageView *)[self.view viewWithTag:13];
    UIImageView *passwordErrorimgView = (UIImageView *)[self.view viewWithTag:12];
    [emailTxtFld removeData];
    emailErrorimgView.hidden = YES;
    [passwordTxtFld removeData];
    passwordErrorimgView.hidden = YES;
    [textField removeData];
    if (textField==emailTxtFld)
    {
        [self showErrorMsg:@""];
        [self resetFields];
    }
}

// ------------ check text field's length if it is greater than 0. then login btn enabled -------------------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UIImageView *emailErrorimgView = (UIImageView *)[self.view viewWithTag:13];
    UIImageView *passwordErrorimgView = (UIImageView *)[self.view viewWithTag:12];
    if ([textField.text length] + [string length] - range.length == 0)
    {
        //--------------------- if lenght of text field is equal to zero so in that case we will remove cross image and alert label -----------------
        if ([textField isEqual:emailTxtFld])
        {
            [emailTxtFld removeData];
            emailErrorimgView.hidden = YES;
        }
        else
        {
            [passwordTxtFld removeData];
            passwordErrorimgView.hidden = YES;
        }
    }
    
    //--------------------- We can't enter value in passward text field after 40 character and 256 character in email text field ------------
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if ([textField isEqual:emailTxtFld] || [textField isEqual:passwordTxtFld])
    {
        if ([textField isEqual:emailTxtFld])
            return (newLength > 200) ? NO : YES;
        else
            return (newLength > 200) ? NO : YES;
    }
    else
    {
        return (newLength > 200) ? NO : YES;
    }
}

#pragma mark ------
#pragma mark touch Delegte Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end