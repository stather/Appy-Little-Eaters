  //
//  MyCardVC.m
//  Caxtonfx
//
//  Created by XYZ on 17/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "MyCardVC.h"
#import "MyCardsTableCell.h"
#import "TopUpRechargeVC.h"
#import "AppDelegate.h"
#import "Appirater.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "Card.h"
#import "ImagePickerVC.h"
@interface MyCardVC ()

@end

@implementation MyCardVC

@synthesize tableView,heightConstraint,cardsArray,contentArray;
@synthesize refreshControl;
@synthesize loadingFromPin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -------
#pragma mark view lyf cycle Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] % 3 ==0 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"rateFlag"])
    {
        [Appirater appLaunched:YES];
        [Appirater setAppId:appID];
        [Appirater setDaysUntilPrompt:0];
        [Appirater setDebug:YES];
    }
    self.tableView.delegate = self;
    if(IS_HEIGHT_GTE_568)
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:438];
        [self.tableView addConstraint:heightConstraint];
    }else
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:350];
        [self.tableView addConstraint:heightConstraint];
    }
    
    self.HUD= [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.delegate = self;
    [self.tableView addSubview:self.HUD];
    [self.tableView bringSubviewToFront:self.HUD];
    [Flurry logEvent:@"Visited Cards Screen"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[AppDelegate getSharedInstance] topBarView] setHidden:YES];
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:NO];
    [self customizingNavigationBar];
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        User *myUser = [User sharedInstance];
        if ([CommonFunctions reachabiltyCheck]){
            NSLog(@"Time since latest rate: %i",[[AppDelegate getSharedInstance] minutesSinceNowRatesOnly]);
            if ([[AppDelegate getSharedInstance] minutesSinceNowRatesOnly] > 5)
            {
                myUser.globalRates = [myUser loadGlobalRatesWithRemote:YES];
            }else{
                myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
            }
        }else{
            myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
        }
    });
}
// custome navigtion bar
-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f,320, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f,210.0f,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:@"Cards"];
    [view addSubview:titleLbl];
    [self.navigationItem setTitleView:view];
    
    /****** add custom left bar button (Camera Button) at navigation bar  **********/
    UIButton *conversionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    conversionBtn.frame = CGRectMake(0,0,32,32);
    [conversionBtn setBackgroundImage:[UIImage imageNamed:@"captureTopBtn"] forState:UIControlStateNormal];
    [conversionBtn setBackgroundImage:[UIImage imageNamed:@"captureTopBtn"] forState:UIControlStateHighlighted];
    [conversionBtn addTarget:self action:@selector(imageCaptureButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:conversionBtn];
    [self.navigationItem setLeftBarButtonItem:left];
    
    /****** add custom right bar button (Refresh Button) at navigation bar  **********/
    UIBarButtonItem * doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(hudRefresh:)];
    //TO-DO add custom image that is the same for iOS 6/7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        doneButton.tintColor = [UIColor whiteColor];
    }else{
        doneButton.tintColor =[UIColor colorWithRed:255.0/255.0 green:40.0/255.0 blue:25.0/255.0 alpha:1.0];
    }

    [self.navigationItem setRightBarButtonItem:doneButton];
}

- (IBAction)imageCaptureButtonTouched:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate window] setRootViewController:[appDelegate mainNavigation]];
    ImagePickerVC *ivc = (ImagePickerVC*) [[[appDelegate mainNavigation] viewControllers] objectAtIndex:0];
    [ivc showCamera];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[AppDelegate getSharedInstance] topBarView] setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:NO];
    User *myUser = [User sharedInstance];
    myUser.cards =[myUser loadCardsFromDatabasewithRemote:NO];
    if ([[AppDelegate getSharedInstance] minutesSinceNowCardsOnly] > 10)
    {
        [self performSelector:@selector(hudRefresh:) withObject:self afterDelay:5.0];
    }
}
- (void)refresh :(id)sender
{
    MBProgressHUD* HUD= [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    self.tableView.userInteractionEnabled = NO;
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    if([CommonFunctions reachabiltyCheck])
    {
        [self performSelectorInBackground:@selector(updateCards) withObject:self];
    }else
    {
        [self.refreshControl endRefreshing];
        self.tableView.userInteractionEnabled = YES;
    }
}
- (void)hudRefresh :(id)sender
{
    
    self.tableView.userInteractionEnabled = NO;
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    self.view.userInteractionEnabled = NO;
    if([CommonFunctions reachabiltyCheck])
    {
        [self.HUD showWhileExecuting:@selector(updateCards) onTarget:self withObject:self animated:YES];
        [self performSelector:@selector(refreshTheTable) withObject:nil afterDelay:2.0f];
    }else
    {
        [self.refreshControl endRefreshing];
        self.tableView.userInteractionEnabled = YES;
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check you internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlert show];
    }
    
}
-(void) updateCards{
    User *myUser = [User sharedInstance];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *keychain1 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userDOB" accessGroup:nil];
    [keychain1 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userMobile" accessGroup:nil];
    [keychain2 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    myUser.username =[keychain objectForKey:(__bridge id)kSecAttrAccount];
    myUser.password =[keychain objectForKey:(__bridge id)kSecValueData];
    myUser.contactType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userConactType"];
    myUser.dateOfBirth = [keychain1 objectForKey:(__bridge id)kSecValueData];
    myUser.mobileNumber = [keychain2 objectForKey:(__bridge id)kSecValueData];
    myUser.cards = [myUser loadCardsFromDatabasewithRemote:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (([myUser.statusCode intValue] != 000) && ([myUser.statusCode intValue] != 003)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        alert.delegate = self;
        [alert show];
    }
}
-(void)refreshTheTable{
    self.view.userInteractionEnabled = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.tableView reloadData];
}

-(void)topupBtnPressed:(NSIndexPath*)indexPath;
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userConactType"]isEqualToString:@"1"])
    {
        User * myUser = [User sharedInstance];
        TopUpRechargeVC *topupVC = [[TopUpRechargeVC alloc]initWithNibName:@"TopUpRechargeVC" bundle:nil];
        topupVC.delegate = self;
        topupVC.dataDict = [myUser.cards objectAtIndex:indexPath.row];
        topupVC.indexPath = indexPath;
        [self.navigationController pushViewController:topupVC animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 ){
        if (buttonIndex == 0)
        {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appDelegate doLogout];
        }
    }
}

#pragma mark -------
#pragma mark TableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    User *myUser = [User sharedInstance];
    if(myUser.cards.count==0)
    {
        return 1;
    }
    else
    {
        return myUser.cards.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 173;
}

-(UITableViewCell *)emptyCell {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (!self.loadingFromPin) {
        [cell.textLabel setText:@"No cards currently active for this user. \nPlease Refresh."];
    }else{
        [cell.textLabel setText:@"Loading your information..."];
        self.loadingFromPin = FALSE;
    }
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = UIColorFromRedGreenBlue(204, 204, 204);
    return cell;

}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *myUser = [User sharedInstance];
    if(myUser.cards.count==0)
    {
        return [self emptyCell];
    }else
    {
        MyCardsTableCell *cell;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyCardsTableCell"
                                                     owner:self options:nil];
        if (nib.count >0) {
            cell = [nib objectAtIndex:0];
        }else{
            return [self emptyCell];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accountNameLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        [cell.accountNameLable setFont:[UIFont fontWithName:@"OpenSans" size:19]];
        [cell.accountTypeLable setFont:[UIFont fontWithName:@"OpenSans" size:10]];
        cell.accountTypeLable.textColor = UIColorFromRedGreenBlue(204, 204, 204);
        [cell.currentBlnceLable setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        cell.currentBlnceLable.textColor = UIColorFromRedGreenBlue(39, 39, 39);
        [cell.blnceLable setFont:[UIFont fontWithName:@"OpenSans" size:25]];
        cell.blnceLable.textColor = UIColorFromRedGreenBlue(39, 39, 39);
        [cell.topupBtn setBackgroundImage:[UIImage imageNamed:@"topUpBtn"] forState:UIControlStateNormal];
        [cell.topupBtn setBackgroundImage:[UIImage imageNamed:@"topUpBtnSelected"] forState:UIControlStateHighlighted];
        Card *myCard;
        if (myUser.cards.count >0) {
            myCard = [myUser.cards objectAtIndex:indexPath.row];
        }else{
            return [self emptyCell];
        }
        if([myCard.CardCurrencyDescriptionStr isEqualToString:@"GB pound"])
        {
            cell.flagImgView.image = [UIImage imageNamed:@"GBPFlag"];
            
        }else  if([myCard.CardCurrencyDescriptionStr isEqualToString:@"Euro"])
        {
            cell.flagImgView.image = [UIImage imageNamed:@"euroFlag"];
        }else
        {
            cell.flagImgView.image = [UIImage imageNamed:@"dolloeFlag"];
        }
        [NSThread detachNewThreadSelector:@selector(setSymbolValue:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:myCard,@"dict",cell.blnceLable,@"lbl", nil]];
        cell.accountNameLable.text = myCard.CardNameStr;
        cell.accountTypeLable.text = myCard.CardNumberStr;//@"MAIN ACCOUNT CARD";
        cell.currentBlnceLable.text = @"Your current balance is";
        if([myCard.failImage isEqualToString:@"YES"])
            cell.errorImgView.hidden= NO;
        else
            cell.errorImgView.hidden= YES;
        
        if([myCard.successImage isEqualToString:@"YES"])
            cell.succesImgView.hidden = NO;
        else
            cell.succesImgView.hidden = YES;
        
        if([myUser.contactType isEqualToString:@"0"]){
            cell.topupBtn.hidden =TRUE;
        }
        
        return cell;
    }
}

-(void) setSymbolValue:(NSDictionary*) dic
{
    NSString *symbolStr = @"";
    Card *myCard =[dic objectForKey:@"dict"];
    NSString *CardCurrencyID =   myCard.CardCurrencyIDStr;
    switch ([CardCurrencyID intValue]) {
        case 2:
            symbolStr = @"£";
            break;
        case 3:
            symbolStr = @"$";
            break;
        case 4:
            symbolStr = @"€";
            break;
        default:
            break;
    }
    NSString *blncLblStr = [NSString stringWithFormat:@"%@%.02f",symbolStr,[myCard.cardBalanceStr floatValue]];
    [self performSelectorOnMainThread:@selector(setTheLbl:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:blncLblStr,@"blncLblStr",[dic objectForKey:@"lbl"],@"lbl", nil] waitUntilDone:NO];
}

-(void) setTheLbl:(NSDictionary *) dic
{
    UILabel *lbl = (UILabel *)[dic objectForKey:@"lbl"];
    lbl.text = @"";
    NSString *blncLblStr = [dic objectForKey:@"blncLblStr"];
    UIColor *firstColor=UIColorFromRedGreenBlue(102, 102, 102);
    UIColor *secondColor=UIColorFromRedGreenBlue(39, 39, 39);
    UIFont *firstfont=[UIFont fontWithName:@"OpenSans" size:25.0f];
    UIFont *secondfont=[UIFont fontWithName:@"OpenSans" size:25.0f];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:blncLblStr];
    [attString addAttribute:NSFontAttributeName value:firstfont range:NSMakeRange(0, 1)];
    [attString addAttribute:NSFontAttributeName value:secondfont range:NSMakeRange(1, blncLblStr.length-1)];
    [attString addAttribute:NSForegroundColorAttributeName value:firstColor range:NSMakeRange(0, 1)];
    [attString addAttribute:NSForegroundColorAttributeName value:secondColor range:NSMakeRange(1, blncLblStr.length-1)];
    lbl.attributedText = attString;
}

- (void)topupResult:(NSIndexPath*)path dict:(NSMutableDictionary *)dict1
{
    @try {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
        [self.cardsArray replaceObjectAtIndex:path.row  withObject:dict];
        [self performSelector:@selector(refreshTheTable) withObject:nil afterDelay:2.0];
        [self performSelector:@selector(hudRefresh:) withObject:self afterDelay:10.0];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
- (void)topupResult:(NSIndexPath*)path WithCard :(Card*)myCard{
    @try {
        [self refreshTheTable];
        }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
- (void)noRefreshTopupResult:(NSIndexPath*)path dict:(NSMutableDictionary *)dict1
{
    @try {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
        [self.cardsArray replaceObjectAtIndex:path.row  withObject:dict];
        [self performSelector:@selector(refreshTheTable) withObject:nil afterDelay:2.0];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


@end
