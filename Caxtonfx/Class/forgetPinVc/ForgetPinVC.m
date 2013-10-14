//
//  ForgetPinVC.m
//  Caxtonfx
//
//  Created by XYZ on 18/06/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "ForgetPinVC.h"
#import "UITextField+CustomTextBox.h"
#import "UIButton+CustomDesign.h"
#import "Validate.h"
#import "MyCardVC.h"
#import "CommonFunctions.h"
#import "AppDelegate.h"

@interface ForgetPinVC ()

@end

@implementation ForgetPinVC

@synthesize emailTxtFld,passwordTxtFld;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark View lyf cycle method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self SetUpDesginPage];
    AppDelegate *appDelegte = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegte.customeTabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.topBarView.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [self setNavigationTitle:@"Change PIN"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegte = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegte.customeTabBar.hidden = NO;
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

#pragma mark -----
#pragma mark SetUpDesginPage

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

#pragma mark ------
#pragma mark IBAction Method

-(IBAction) loginBtnPressed:(id)sender
{
    UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
    
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
             [self showErrorMsg:@"Unfortunately the entered password must be less then 200 characters. Please try again."];
            
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
            [logInBtn btnWithOutCheckImage];
            [logInBtn btnWithOutCrossImage];
            [logInBtn btnWithActivityIndicator];
            
            [self.view endEditing:YES];
            
            [NSThread detachNewThreadSelector:@selector(sendLoginReqToServer) toTarget:self withObject:nil];
        }
    }
    else
    {
        [self showErrorMsg:@"Unfortunately there is no connection available at the moment. Please try again later."];
        [self loginWithAppAccount:4];
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

-(void)startSendingReq:(UIButton *)btn
{
    [btn btnWithActivityIndicator];
    [btn btnWithOutCrossImage];
    [btn btnSuccess];
    [self performSelectorOnMainThread:@selector(ResetPin) withObject:nil waitUntilDone:nil];
    [self showErrorMsg:@""];
}

-(IBAction) forgotpasswordBtnPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.caxtonfxcard.com/secure_cfxcard/cfxcard_password_forget.aspx"]];
}

-(IBAction)cancleBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ResetPin
{
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeReset];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    passcodeViewController.skipStr = @"YES";
    passcodeViewController.delegate = self;
    passcodeViewController.simple = YES;
    
    [self.navigationController pushViewController:passcodeViewController animated:YES];
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

-(void)showErrorMsg:(NSString *)errorString
{
    UILabel *errorLable = (UILabel*)[self.view viewWithTag:10];
    errorLable.text = errorString;
    errorLable.hidden = NO;
}

-(void)sendLoginReqToServer
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        
        NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",emailTxtFld.text,passwordTxtFld.text];
        
        [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
    }
}

#pragma mark ------
#pragma mark sharedManager Delegate

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    if([service isEqualToString:@"CheckAuthGetCards"]){
        NSMutableArray *array = [[NSMutableArray alloc]init];
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"CheckAuthGetCardsResponse" parentElement:rootItemElem];
        TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"CheckAuthGetCardsResult" parentElement:checkAuthGetCardsResponseElem];
        TBXMLElement *statusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
        NSString *statusCodeStr = [TBXML textForElement:statusCode];
        if(!([statusCodeStr intValue]== 001 || [statusCodeStr intValue]== 002 ||[statusCodeStr intValue]== 005))
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
                
                UIButton *button = (UIButton*)[self.view viewWithTag:6];
                [button btnWithoutActivityIndicator];
                [self startSendingReq:button];
                
                [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDate"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
                [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
                
                // Store username to keychain
                [keychain setObject:emailTxtFld.text forKey:(__bridge id)kSecAttrAccount];
                
                // Store password to keychain
                [keychain setObject:passwordTxtFld.text forKey:(__bridge id)kSecValueData];
               
                
            }
            
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
                if(LoginAttamp >=3)
                {
                    [self performSelectorOnMainThread:@selector(showMsg:) withObject:@"Account locked due to wrong password entered too many times." waitUntilDone:NO];
                    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Lock"];
                    
                }
            }
            if([statusCodeStr intValue]==005)
            {
                [self performSelectorOnMainThread:@selector(showMsg:) withObject:@"Account locked due to wrong password entered too many times." waitUntilDone:NO];
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Lock"];
            }
        }else
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
                if(LoginAttamp >=3)
                {
                    [self performSelectorOnMainThread:@selector(showMsg:) withObject:@"Account locked due to wrong password entered too many times." waitUntilDone:NO];
                    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Lock"];
                    
                }
            }
            
            if([statusCodeStr intValue]==005)
            {
                [self showErrorMsg:@"Your Caxton Fx account has been locked. To unlock your account please email info@caxtonfxcard.com"];
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Lock"];
                
                UIButton *button = (UIButton*)[self.view viewWithTag:6];
                [button btnWithoutActivityIndicator];
                [button btnWithCrossImage];
                [emailTxtFld incorrectDataTxtFld];
                [passwordTxtFld incorrectDataTxtFld];
                
            }else
            {
                
                if(LoginAttamp == 1 || LoginAttamp == 0)
                    [self showErrorMsg:@"Your username or password cannot be verifield please try again."];
                else if (LoginAttamp == 2)
                    [self showErrorMsg:@"Your username or password cannot be verifield please try again."];
                
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
    [self showErrorMsg:@"Unfortunately our service is not available at the moment. But please do try again later."];
    UIButton *button = (UIButton*)[self.view viewWithTag:6];
    [button btnWithoutActivityIndicator];
    [button btnWithCrossImage];
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
    else if((textField == passwordTxtFld) &&   ([passwordTxtFld.text length] > 200))
    {
        emailErrorimgView.hidden = YES;
        
        passwordErrorimgView.hidden = NO;
        [self showErrorMsg:@"Unfortunately the entered password must be less then 200 characters. Please try again."];

        [passwordTxtFld incorrectDataTxtFld];
        return NO;
    }
    else if((textField == passwordTxtFld) &&  [Validate isValidPassword:passwordTxtFld.text]){
        
        passwordErrorimgView.hidden = YES;
        
        UIButton *logInBtn = (UIButton*)[self.view viewWithTag:6];
        [self loginBtnPressed:logInBtn];
        
        [textField resignFirstResponder];
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
        
        [passwordTxtFld becomeFirstResponder];
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
        
        [self showErrorMsg:@"Unfortunately the entered password must be less then 200 characters. Please try again."];

        
        [passwordTxtFld incorrectDataTxtFld];
        }else if((textField == passwordTxtFld) &&  [Validate isValidPassword:passwordTxtFld.text]){
        passwordErrorimgView.hidden = YES;
    
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    UIImageView *emailErrorimgView = (UIImageView *)[self.view viewWithTag:13];
    UIImageView *passwordErrorimgView = (UIImageView *)[self.view viewWithTag:12];
    [emailTxtFld        removeData];
    emailErrorimgView.hidden = YES;
    
    [passwordTxtFld         removeData];
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
            [emailTxtFld        removeData];
            emailErrorimgView.hidden = YES;
        }
        else
        {
            [passwordTxtFld         removeData];
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

#pragma mark --------
#pragma mark PAPasscodeDelagete

- (void)PAPasscodeViewControllerDidResetPasscode:(PAPasscodeViewController *)controller
{
    NSString *valueToSave = @"YES";
    
    [[NSUserDefaults standardUserDefaults]setObject:valueToSave forKey:@"setPin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *passcodeStr = controller.passcode ;
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
    [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    [wrapper setObject:[NSString stringWithFormat:@"%@",@"CFX"] forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:[NSString stringWithFormat:@"%@",passcodeStr] forKey:(__bridge id)kSecValueData];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"setPin"];
    
    MyCardVC *crdsVc = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
    [self.navigationController pushViewController:crdsVc animated:YES];
}

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    MyCardVC *crdsVc = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
    [self.navigationController pushViewController:crdsVc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
