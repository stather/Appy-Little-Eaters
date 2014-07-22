//
//  SettingVC.m
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//[topHeadLineLbl setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];

#import "SettingVC.h"
#import "LogoutTableCell.h"
#import "PinTableCell.h"
#import "BaseCurrencyTableCell.h"
#import "SetPinTableCell.h"
#import "AboutVC.h"
#import "BaseCurrencyVC.h"

#import "UIColor+Additions.h"
#import "FBEncryptorAES.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"

#import "ConverterVC.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCryptor.h>

@interface SettingVC ()

@end

@implementation SettingVC

@synthesize tableView,defaultconDic;
@synthesize pinLable,pinSecLable;
@synthesize logoutTableCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ------
#pragma mark View Life cycle Method
- (void)userTextSizeDidChange {
	[self applyFonts];
    needsHeight = YES;
    [self.tableView reloadData];
}
- (void)applyFonts {
    logoutTableCell.lbl.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    needsHeight = NO;
    
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f,320, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f,210.0f,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:@"Settings"];
    [view addSubview:titleLbl];
    [self.navigationItem setTitleView:view];
    
    /****** add custom left bar button (Converter Button) at navigation bar  **********/
    UIButton *conversionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    conversionBtn.frame = CGRectMake(0,0,26,26);
    [conversionBtn setImage:[UIImage imageNamed:@"calculator-26.png"] forState:UIControlStateNormal];
    [conversionBtn addTarget:self action:@selector(ConverterBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:conversionBtn];
    [self.navigationItem setLeftBarButtonItem:left];

    isOn = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self applyFonts];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userTextSizeDidChange)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
    
    [Flurry logEvent:@"Visited Settings"];
}
-(IBAction)ConverterBtnPressed:(id)sender{
    ConverterVC *converterView = [[ConverterVC alloc]init];
    [self.navigationController pushViewController:converterView animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.shareTabBar setHidden:YES];
    [appDelegate.shareTabBar removeFromSuperview];
    if(IS_HEIGHT_GTE_568)
        [appDelegate.customeTabBar setFrame:CGRectMake(0, 507, 320, 60)];
    else
        [appDelegate.customeTabBar setFrame:CGRectMake(0, 419, 320, 60)];
    
    [appDelegate.customeTabBar setHidden:NO];
    [appDelegate.tabBarController.view addSubview:appDelegate.customeTabBar];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
        return 151;
    else
        return  51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier2 = @"Cell2";
    if(indexPath.row == 0)
    {
        logoutTableCell = (LogoutTableCell *)[tableView1 dequeueReusableCellWithIdentifier:[LogoutTableCell reuseIdentifier]];
        
        if (logoutTableCell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LogoutTableCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    logoutTableCell = (LogoutTableCell *)currentObject;
                    break;
                }
            }
        }
        logoutTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        logoutTableCell.lbl.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            [logoutTableCell.lbl setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
        }
        [logoutTableCell.btn setBackgroundImage:[UIImage imageNamed:@"logoutBtn1"] forState:UIControlStateNormal];
        [logoutTableCell.btn setBackgroundImage:[UIImage imageNamed:@"logoutBtnHover"] forState:UIControlStateHighlighted];
        
        return logoutTableCell;
        
    }else if (indexPath.row ==1)
    {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            pinLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 210,20)];
            pinLable.backgroundColor = [UIColor clearColor];
            [pinLable setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
            pinLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
            pinLable.text = @"PIN";
            [cell addSubview:pinLable];
            pinSecLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 22, 210,18)];
            pinSecLable.backgroundColor = [UIColor clearColor];
            pinSecLable.text = @"Log in using your PIN for added security";
            pinSecLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
            [pinSecLable setFont:[UIFont fontWithName:@"OpenSans" size:11]];
            [cell addSubview:pinSecLable];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 1)];
            view.backgroundColor = UIColorFromRedGreenBlue(220, 220, 220);
            [cell addSubview:view];
            
            }
        else
        {
            RESwitch *switchView = (RESwitch*)[cell viewWithTag:100];
            [switchView removeFromSuperview];
        }
        RESwitch *switchView = [[RESwitch alloc] initWithFrame:CGRectMake(245, 15, 65, 22)];
        [switchView setBackgroundImage:[UIImage imageNamed:@"toggleBg"]];
        [switchView setKnobImage:[UIImage imageNamed:@"switch"]];
        [switchView setOverlayImage:[UIImage imageNamed:@"Overlay"]];
        [switchView setHighlightedKnobImage:nil];
        [switchView setTitle:@"" forLabel:RESwitchLabelOff];
        [switchView setTitle:@"" forLabel:RESwitchLabelOn];
        [switchView setCornerRadius:0];
        [switchView setTag:100];
        switchView.layer.masksToBounds = YES;
        NSString *switchStateStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"switchState"];
        if([switchStateStr isEqualToString:@"NO"])
        {
            switchView.on = NO;
            isOn = NO;
        }else
        {
            switchView.on = YES;
            isOn = YES;
        }
        [switchView addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchView];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    /*
    else if(indexPath.row==3)
    {
        BaseCurrencyTableCell *cell = (BaseCurrencyTableCell *)[tableView1 dequeueReusableCellWithIdentifier:[PinTableCell reuseIdentifier]];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BaseCurrencyTableCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (BaseCurrencyTableCell *)currentObject;
                    break;
                }
            }
        }
        cell.lbl.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        [cell.lbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
        cell.currencyLbl.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        [cell.currencyLbl setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        UIImage *mask = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrencyImage"]];
        cell.currencyLbl.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrency"];
        if (mask)
        {
            cell.flagImgView.backgroundColor = [UIColor clearColor];
            
            mask = [mask resizedImage:CGSizeMake(24, 24) interpolationQuality:kCGInterpolationHigh];
            mask = [mask roundedCornerImage:12.0f borderSize:1];
            cell.flagImgView.image = mask;
        }
        else
        {
            cell.flagImgView.layer.cornerRadius = 12;
            cell.flagImgView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
     */
    else{
        
        SetPinTableCell *cell = (SetPinTableCell *)[tableView1 dequeueReusableCellWithIdentifier:[SetPinTableCell reuseIdentifier]];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SetPinTableCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (SetPinTableCell *)currentObject;
                    break;
                }
            }
        }
        cell.lbl.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        [cell.lbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
        
        if(indexPath.row ==2)
        {
            cell.lbl.text = @"Set PIN";
            
        }
        else if(indexPath.row ==3)
        {
            cell.lbl.text = @"About Caxton FX";
        }
        else if(indexPath.row ==4)
        {
            cell.lbl.text = @"Currency Converter";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==2)
    {
        if(isOn)
        {
            [self setPasscode];
        }else
        {
            NSLog(@"this is not set to add pin security");
        }
    }
    else if(indexPath.row==3)
    {
        AboutVC *aboutVC = [[AboutVC alloc]initWithNibName:@"AboutVC" bundle:nil];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if(indexPath.row==4)
    {
        [self performSelector:@selector(ConverterBtnPressed:) withObject:nil];
    }
}

#pragma mark --------
#pragma mark Other Method

-(void)switchViewChanged:(id)sender
{
    RESwitch *s = (RESwitch*)sender;
    if(s.on)
    {
        isOn = YES;
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"switchState"];
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"setPin"];
        [self setPasscode];
    }else
    {
        isOn = NO;
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"setPin"];
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"switchState"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}


- (void)setPasscode {
    [Flurry logEvent:@"User is setting a PIN"];
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionSet];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    passcodeViewController.skipStr = @"NO";
    passcodeViewController.delegate = self;
    passcodeViewController.simple = YES;
    [self.navigationController pushViewController:passcodeViewController animated:YES];
}

#pragma mark --------
#pragma mark Passcode Delegate Method

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller {
    
    NSString *passcodeStr = controller.passcode;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
    [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    [wrapper setObject:[NSString stringWithFormat:@"%@",@"CFX"] forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:[NSString stringWithFormat:@"%@",passcodeStr] forKey:(__bridge id)kSecValueData];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"setPin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
