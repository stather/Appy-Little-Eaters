//
//  ConverterVC.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 26/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "ConverterVC.h"
#import "User.h"

@interface ConverterVC ()

@end

@implementation ConverterVC
@synthesize baseField;
@synthesize targetField;
@synthesize myGlobj;
@synthesize targetLabel;
@synthesize myScrollView;
@synthesize HUD;
@synthesize targetRate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)ccyCodeSelected:(NSString*)ccyCode{
    User *myUser =[User sharedInstance];
    self.myGlobj = [myUser loadGlobalRateForCcyCode:ccyCode];
    if ([ccyCode isEqualToString:@"EUR"]) {
        targetLabel.text = [NSString stringWithFormat:@"%@ €:",self.myGlobj.ccyCode];
    }else if ([ccyCode isEqualToString:@"USD"]){
        targetLabel.text = [NSString stringWithFormat:@"%@ $:",self.myGlobj.ccyCode];
    }else{
        targetLabel.text = [NSString stringWithFormat:@"%@ :",self.myGlobj.ccyCode];
    }
    
    baseField.text = @"";
    targetField.text = @"";
    AppDelegate *delegate = [AppDelegate getSharedInstance];
    delegate.customeTabBar.hidden = YES;
    targetRate.text = [NSString stringWithFormat:@"%0.2f %@",[self.myGlobj.rate floatValue],self.myGlobj.ccyCode];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [self setNavigationTitle:@"Currency Converter"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    AppDelegate *delegate = [AppDelegate getSharedInstance];
    delegate.customeTabBar.hidden = YES;
    
    User *myUser =[User sharedInstance];
    self.myGlobj = [myUser loadGlobalRateForCcyCode:@"EUR"];
    targetRate.text = [NSString stringWithFormat:@"%0.2f %@",[self.myGlobj.rate floatValue],self.myGlobj.ccyCode];

}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *delegate = [AppDelegate getSharedInstance];
    delegate.customeTabBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    if ([self.myGlobj.ccyCode isEqualToString:@""]) {
        User *myUser =[User sharedInstance];
        self.myGlobj = [myUser loadGlobalRateForCcyCode:@"EUR"];
        if ([self.myGlobj.ccyCode isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Rates not loaded. Please check your internet connection and try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }else{
            targetRate.text = [NSString stringWithFormat:@"%0.2f %@",[self.myGlobj.rate floatValue],self.myGlobj.ccyCode];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self backBtnPressed:nil];
}
-(void)refreshRates{
    sleep(1);
    User *myUser =[User sharedInstance];
    if ([CommonFunctions reachabiltyCheck]){
         myUser.globalRates = [myUser loadGlobalRatesWithRemote:YES];
    }else{
         myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
    }
    self.myGlobj = [myUser loadGlobalRateForCcyCode:@"EUR"];
    targetRate.text = [NSString stringWithFormat:@"%0.2f %@",[self.myGlobj.rate floatValue],self.myGlobj.ccyCode];
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
-(IBAction)baseCurrencySelect:(id)sender{
    fromConversionSection = @"NO";
    BaseCurrencyVC *currencyVC = [[BaseCurrencyVC alloc]initWithNibName:@"BaseCurrencyVC" bundle:nil];
    currencyVC.fromConverter = YES;
    currencyVC.delegate = self;
    currencyVC.selectedCurrency =self.myGlobj.ccyCode;
    [self.navigationController pushViewController:currencyVC animated:YES];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)],
                                [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    
    [self scrollViewToCenterOfScreen:textField];
    
}
- (void)nextTextField {
    if (baseField) {
        
        [baseField resignFirstResponder];
        [targetField becomeFirstResponder];
        
    }
}

-(void)previousTextField
{
    if (targetField) {
        [targetField resignFirstResponder];
        [baseField becomeFirstResponder];
    }
}
-(void)resignKeyboard{
    [baseField resignFirstResponder];
    [targetField resignFirstResponder];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range
replacementString: (NSString*) string {
    User *myUser = [User sharedInstance];
    NSLog(@"textField.text %@",textField.text);
    NSLog(@"string %@",string);
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength>5)
    {
        
        return NO;
    }
    
    if(textField==baseField)
    {
        NSString * text = [baseField.text stringByReplacingCharactersInRange:range
                                                                     withString: string];
        if([text length] !=0)
        {
            baseField.text = text;
            float newprice  = 0.0f;
            if (myUser.globalRates.count > 0)
            {
                newprice = text.floatValue * [self.myGlobj.rate floatValue];
            }
            else{
                newprice = text.floatValue * 0.0f;
            }
            targetField.text = [NSString stringWithFormat:@"%.02f",newprice];
        }
        else
        {
            baseField.text =@"";
            targetField.text = @"";
        }
        
        return NO;
    }
    else
    {
        NSString * text = [targetField.text stringByReplacingCharactersInRange:range
                                                                      withString: string];
        NSLog(@"%@",text);
        if([text length] !=0){
            
            targetField.text = text;
            float newprice  = 0.0f;
            if (myUser.globalRates.count > 0)
            {
                newprice = text.floatValue / [self.myGlobj.rate floatValue];
                
                
            }
            
            baseField.text = [NSString stringWithFormat:@"%.02f",newprice];
            
            NSLog(@"leftTxtField.text = %@", baseField.text );
            
        }else
        {
            baseField.text = @"";
            targetField.text = @"";
        }
        return  NO;
    }
    
    return  YES;
    
}
- (void) scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
    CGFloat availableHeight = applicationFrame.size.height - 100;            // Remove area covered by keyboard
	
    CGFloat y = viewCenterY - availableHeight/3 ;
    
    if (y < 0)
    {
        y = 0;
    }
    
    [myScrollView setContentOffset:CGPointMake(0, y) animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

-(IBAction) applyCardButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.caxtonfx.com/apply/"]];
}

#pragma mark -----
#pragma mark Touch Delegate method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
