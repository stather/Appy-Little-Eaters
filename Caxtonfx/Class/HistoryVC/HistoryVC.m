//
//  HistoryVC.m
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "HistoryVC.h"
#import "ImagePickerVC.h"
#import "SettingVC.h"
#import "HistoryConversionDetailVC.h"
#import "TransactionCustomCell.h"
#import "ImageConversionsCustomCell.h"
#import "HistoryTransactionsVC.h"
#import "HistoryConversionsVC.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import "User.h"
#import "Card.h"
#import "Transaction.h"

@interface HistoryVC ()

@end

@implementation HistoryVC

@synthesize bottomView;
@synthesize table;
@synthesize historyArray;
@synthesize receiptsButton;
@synthesize captureButton;
@synthesize settingsButton;
@synthesize titleNameLbl;
@synthesize titletimeDateLbl;
@synthesize conversionArray,currentId,_array;
@synthesize heightConstraint;
@synthesize loadingView;
@synthesize refreshControl;
@synthesize HUD;

#pragma mark ----
#pragma mark View Life Cycle Method
- (void)userTextSizeDidChange {
	[self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizingNavigationBar];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"])
    {
        NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    }
     [self.table removeConstraint:heightConstraint];
    if(IS_HEIGHT_GTE_568)
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:453];
        [self.table addConstraint:heightConstraint];
    }else
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:356];
        [self.table addConstraint:heightConstraint];
    }
   self.table.sectionHeaderHeight = 40.0f;
    _tempMA = [[NSMutableArray alloc] init];
    historyArray = [[NSMutableArray alloc] init];
    conversionArray =[[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userTextSizeDidChange)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
    
    self.HUD= [[MBProgressHUD alloc] initWithView:self.view];
    [self.table addSubview:self.HUD];
    [self.table bringSubviewToFront:self.HUD];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *query = @"";
//    query = [NSString stringWithFormat:@"SELECT * FROM getHistoryTable order by date DESC"];
//    DatabaseHandler *dbHandler = [[DatabaseHandler alloc] init];
//    if(historyArray)
//        [historyArray removeAllObjects];
//    
//     historyArray = [dbHandler fetchingHistoryDataFromTable:query];
    
    if(conversionArray)
        [conversionArray removeAllObjects];
    
    DatabaseHandler *dbHandler = [[DatabaseHandler alloc] init];
    conversionArray = [dbHandler getData:@"select * from conversionHistoryTable order by date desc"];
}
/*
-(void) fetchTheDataFromDB
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.table reloadData];
                       [[self table] setHidden:NO];
                   });
}

*/
-(void)viewDidAppear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = [AppDelegate getSharedInstance];
    [[appDelegate customeTabBar] setHidden:NO];
    UIButton *recieptsBtn = (UIButton*) [appDelegate.bottomView viewWithTag:1];
    [appDelegate BottomButtonTouched:recieptsBtn];
  /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
        [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        AppDelegate *appDelegate = [AppDelegate getSharedInstance];
        [[appDelegate customeTabBar] setHidden:NO];
        UIButton *recieptsBtn = (UIButton*) [appDelegate.bottomView viewWithTag:1];
        [appDelegate BottomButtonTouched:recieptsBtn];
        if([CommonFunctions reachabiltyCheck])
        {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"])
            {
                if ([[self.table subviews] containsObject:self.refreshControl])
                {
                    [self.refreshControl removeFromSuperview];
                }
                [self.view addSubview:self.loadingView];
                isLoadingViewAdded = TRUE;
                [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
            }
            else
            {
                if ([appDelegate minutesSinceNow] > 10)
                {
                    if ([[self.table subviews] containsObject:self.refreshControl])
                    {
                        [self.refreshControl removeFromSuperview];
                    }
                   [self.view addSubview:self.loadingView];
                    isLoadingViewAdded = TRUE;
                    [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
                }
                else
                {
                    if ([[self.table subviews] containsObject:self.refreshControl])
                        [self.refreshControl removeFromSuperview];
                    
                    [self.table addSubview:self.refreshControl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                                  ^{
                                      NSMutableArray *tempArray = [NSMutableArray new];
                                      NSString *query = @"";
                                      query = [NSString stringWithFormat:@"SELECT * FROM getHistoryTable order by date DESC"];
                                      DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
                                      tempArray = [dbHandler fetchingHistoryDataFromTable:query];
                                      dbHandler =  nil;
                                      historyArray = [tempArray mutableCopy];
                                      [table reloadData];
                                  });
                }
            }
        }else
        {
            if ([[self.table subviews] containsObject:self.refreshControl])
                [self.refreshControl removeFromSuperview];

            [self.table addSubview:self.refreshControl];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                          ^{
                              NSMutableArray *tempArray = [NSMutableArray new];
                              NSString *query = @"";
                              query = [NSString stringWithFormat:@"SELECT * FROM getHistoryTable order by date DESC"];
                              DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
                              tempArray = [dbHandler fetchingHistoryDataFromTable:query];
                              dbHandler = nil;
                              historyArray = [tempArray mutableCopy];
                              [table reloadData];
                          });
        }
        DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
        conversionArray = [dbHandler getData:@"select * from conversionHistoryTable order by date desc"];
        dbHandler = nil;
        [[self table] setHidden:NO];
        [self.table reloadData];
    }
    */
    User *myUser = [User sharedInstance];
    if([CommonFunctions reachabiltyCheck])
    {
        if ([[self.table subviews] containsObject:self.refreshControl])
            [self.refreshControl removeFromSuperview];
        
        [self.table addSubview:self.refreshControl];

        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"])
        {
            [self hudRefresh];
        }else{
            if ([appDelegate minutesSinceNow] > 10){
                [self hudRefresh];
            }else{
                if (myUser.transactions.count == 0) {
                    [self hudRefresh];
                }else{
                    User *myUSer = [User sharedInstance];
                    myUSer.transactions = [myUSer loadTransactionsForUSer:myUSer.username withRemote:NO];
                    [self.table reloadData];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            }
        }
    }
    [self.table reloadData];
    [Flurry logEvent:@"Visited History Screen"];
}

- (void)refresh :(id)sender
{
   
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Checking for transactions"];
    [self.refreshControl beginRefreshing];
    if([CommonFunctions reachabiltyCheck])
        [self.HUD showWhileExecuting:@selector(refreshTransactionsinModel) onTarget:self withObject:nil animated:YES];
    
    [self.refreshControl endRefreshing];
    /*
    if([CommonFunctions reachabiltyCheck])
        [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
    else
        [self.refreshControl endRefreshing];
     */
}
- (void)hudRefresh
{
    self.view.userInteractionEnabled = NO;
    if([CommonFunctions reachabiltyCheck])
        [self.HUD showWhileExecuting:@selector(refreshTransactionsinModel) onTarget:self withObject:nil animated:YES];
    else{
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check you internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlert show];
    }
    /*
    if([CommonFunctions reachabiltyCheck])
        [HUD showWhileExecuting:@selector(callServiceForFetchingHistoryData) onTarget:self withObject:nil animated:YES];
    else
        [self.refreshControl endRefreshing];
     */
}
-(void)refreshTransactionsinModel{
    User *myUser = [User sharedInstance];
    myUser.transactions = [myUser loadTransactionsForUSer:@"" withRemote:YES];
    [self.table reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.view.userInteractionEnabled = YES;
     if (![myUser.statusCode isEqualToString:@"000"] && ![myUser.statusCode isEqualToString:@"003"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        alert.delegate = self;
        [alert show];
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
    [titleLbl setText:@"History"];
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
    
    /****** add custom left bar button (Refresh Button) at navigation bar  **********/
    UIBarButtonItem * doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
     target:self
                                                  action:@selector(hudRefresh)];
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        doneButton.tintColor = [UIColor whiteColor];
    }else{
        doneButton.tintColor =[UIColor colorWithRed:255.0/255.0 green:40.0/255.0 blue:25.0/255.0 alpha:1.0];
    }
    //TO-DO add custom image that is the same for iOS 6/7
    //doneButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:doneButton];
}

- (IBAction)imageCaptureButtonTouched:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate window] setRootViewController:[appDelegate mainNavigation]];
    ImagePickerVC *ivc = (ImagePickerVC*) [[[appDelegate mainNavigation] viewControllers] objectAtIndex:0];
    [ivc showCamera];
}

//================================== *********  FetchImage  ************ =================================
-(UIImage *)FetchImage:(NSString *)name
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [dataPath stringByAppendingPathComponent:@"patientPhotoFolder"];
    NSString *workSpacePath = [patientPhotoFolder stringByAppendingPathComponent:name];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
}


#pragma mark -
#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count =0;
    User *myUser = [User sharedInstance];
    if (isLoadingViewAdded)
        return 0;
    
    if (myUser.transactions.count == 0 && conversionArray.count==0)
        return 1;
    
    else{
        if(myUser.transactions.count>0)
            count+=1;
        
        if(conversionArray.count>0)
            count+=1;
    }
	return count;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    User *myUser = [User sharedInstance];
    if (myUser.transactions.count !=0 && conversionArray.count !=0)
    {
        if (section == 0) {
            return ([myUser.transactions count]>3)?3:[myUser.transactions count];
        }
        else
        {
            return ([conversionArray count]>3)?3:[conversionArray count];
        }
    }
    else
    {
        if (myUser.transactions.count !=0)
        {
            if (section == 0)
            {
                return ([myUser.transactions count]>3)?3:[historyArray count];
            }
        }
        else if((myUser.transactions.count == 0) && (conversionArray.count != 0))
        {
            if (section == 0)
            {
                return ([conversionArray count]>3)?3:[conversionArray count];
            }
        }
    }
    if (myUser.transactions.count ==0 && conversionArray.count ==0){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *myUser = [User sharedInstance];
    
    if (myUser.transactions.count !=0 && conversionArray.count !=0)
    {
        if (indexPath.section == 0) {
            return 84.0f;
        }
        else
        {
            return 82.0f;
        }
    }
    else
    {
        if (myUser.transactions.count !=0)
        {
            if (indexPath.section == 0)
            {
                return 84.0f;
            }
        }
        else if((myUser.transactions.count == 0) && (conversionArray.count != 0))
        {
            if (indexPath.section == 0)
            {
                return 82.0f;
            }
        }
    }
    if (myUser.transactions.count ==0 && conversionArray.count ==0){
        return 82.0f;
    }
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    User *myUser = [User sharedInstance];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 9, 200,22)];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorWithRed:101.0f/255.0f green:101.0f/255.0f blue:101.0f/255.0f alpha:1.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(301, 11, 10, 14)];
    [rightArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    [headerView addSubview:rightArrow];
    NSString *sectionName= @"Full transaction history";
    UIButton *headerBtn = [[UIButton alloc] initWithFrame:headerView.frame];
    if (myUser.transactions.count !=0 && conversionArray.count !=0)
    {
        if (section == 0) {
            sectionName = @"Full transaction history";
            [headerBtn addTarget:self action:@selector(switchToTransactionVC) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            sectionName = @"Caxton FX photo album";
            [headerBtn addTarget:self action:@selector(switchToTransactionHistory) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else
    {
        if (myUser.transactions.count !=0)
        {
            if (section == 0)
            {
                sectionName = @"Full transaction history";
                [headerBtn addTarget:self action:@selector(switchToTransactionVC) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if((myUser.transactions.count == 0) && (conversionArray.count != 0))
        {
            if (section == 0)
            {
                sectionName = @"Caxton FX photo album";
                [headerBtn addTarget:self action:@selector(switchToTransactionHistory) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    [titleLabel setText:sectionName];
    [headerView addSubview:headerBtn];
    [headerView addSubview:titleLabel];
    return headerView;
}
- (UIFont*)fontForBodyTextStyle {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}
- (UIFont*)fontForCaptionTextStyle {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TransactionCustomCellIdentifier";
    static NSString * cellIdentifier1 = @"ImageConversionsCustomCellIdentifier";
    User *myUser = [User sharedInstance];
    if((myUser.transactions.count == 0) && (conversionArray.count == 0)){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textLabel setText:@"No transactions have been made in the past 2 months."];
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = UIColorFromRedGreenBlue(204, 204, 204);
        return cell;
    }else{
        if (indexPath.section == 0){
            if (myUser.transactions.count != 0){
                Transaction *myTrans = [myUser.transactions objectAtIndex:indexPath.row];
                TransactionCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                // If no cell is available, create a new one using the given identifier.
                if (cell == nil)
                {
                    cell = [[TransactionCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCustomCell"
                                                                 owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                //NSMutableDictionary *dict = [historyArray objectAtIndex:indexPath.row];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                    cell.merchantNameLabel.font = [self fontForBodyTextStyle];
                    cell.currencyValueLabel.font = [self fontForBodyTextStyle];
                    cell.timeCountryDateLabel.font = [self fontForCaptionTextStyle];
                    cell.cardUsedLabel.font = [self fontForCaptionTextStyle];
                }

                cell.merchantNameLabel.text =myTrans.vendor;
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                [df setLocale:formatterLocale];
                NSDate *date = [df dateFromString:myTrans.txnDate];
                [df setDateFormat:@"dd/MM/yyyy"];
                NSString *dateIs = [df stringFromDate:date];
                [df setDateFormat:@"HH:mm"];
                NSString *timeIs = [df stringFromDate:date];
                cell.timeCountryDateLabel.text = [NSString stringWithFormat:@"%@ | %@",timeIs,dateIs];
                NSString *cardString ;
                NSString *cardNameString =myTrans.cardName;
                if([cardNameString isEqualToString:@"Euro"])
                    cardString = @"Europe Traveller card";
                else if([cardNameString isEqualToString:@"GB pound"])
                    cardString = @"Global Traveller card";
                else
                    cardString = @"Dollar Traveller card";
                
                cell.cardUsedLabel.text = cardString;
                cell.currencyValueLabel.text = [NSString stringWithFormat:@"%.02f",[myTrans.txnAmount floatValue]];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 83, 320, 1)];
                [lineView setBackgroundColor:UIColorFromRedGreenBlue(220, 220, 220)];
                [cell addSubview:lineView];
                return cell;
            }else{
                ImageConversionsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                if (cell == nil)
                {
                    cell = [[ImageConversionsCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageConversionsCustomCell"
                                                                 owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                NSMutableDictionary *dict = [conversionArray objectAtIndex:indexPath.row];
                UIImage *mask = [self FetchImage:[dict objectForKey:@"imageName"]];
                mask = [mask resizedImage:CGSizeMake(73, 73) interpolationQuality:kCGInterpolationHigh];
                NSString *base =@"";
                if ([dict objectForKey:@"base"])
                    base = [dict objectForKey:@"base"] ;
                else
                    base = @"()";
                
                cell.thumbnailImageView.image = mask;
                cell.currencyCodeLabel.text= [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"target"],base];
                cell.globalRateLabel.text = @"Caxton FX Global Traveller Rate";
                cell.dateLabel.text= [dict objectForKey:@"date"];
                cell.convertedCurrencyLabel.text= [dict objectForKey:@"conversionValue"];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, 320, 1)];
                [lineView setBackgroundColor:UIColorFromRedGreenBlue(220, 220, 220)];
                [cell addSubview:lineView];
                return cell;
            }
        }else if (indexPath.section == 1){
            ImageConversionsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell == nil)
            {
                cell = [[ImageConversionsCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageConversionsCustomCell"
                                                             owner:self options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            NSMutableDictionary *dict = [conversionArray objectAtIndex:indexPath.row];
            UIImage *mask = [self FetchImage:[dict objectForKey:@"imageName"]];
            mask = [mask resizedImage:CGSizeMake(73, 73) interpolationQuality:kCGInterpolationHigh];
            NSString *base =@"";
            if ([dict objectForKey:@"base"])
                base = [dict objectForKey:@"base"] ;
            else
                base = @"()";
            
            cell.thumbnailImageView.image = mask;
            cell.currencyCodeLabel.text= [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"target"],base];
            cell.globalRateLabel.text = @"Caxton FX Global Traveller Rate";
            cell.dateLabel.text= [dict objectForKey:@"date"];
            cell.convertedCurrencyLabel.text= [dict objectForKey:@"conversionValue"];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, 320, 1)];
            [lineView setBackgroundColor:UIColorFromRedGreenBlue(220, 220, 220)];
            [cell addSubview:lineView];
            return cell;
        }
    }
    return nil;
}

-(void)switchToTransactionVC
{
    User *myUser =[User sharedInstance];
    if(myUser.transactions.count>0)
    {
        HistoryTransactionsVC *tempController = [[HistoryTransactionsVC alloc] initWithNibName:@"HistoryTransactionsVC" bundle:nil];
        tempController.historyArray = myUser.transactions;
        [[self navigationController] pushViewController:tempController animated:YES];
    }
}

-(void)switchToTransactionHistory
{
    HistoryConversionsVC *tempController = [[HistoryConversionsVC alloc] initWithNibName:@"HistoryConversionsVC" bundle:nil];
    tempController.historyArray = conversionArray;
    [[self navigationController] pushViewController:tempController animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *myUser =[User sharedInstance];
    if (myUser.transactions.count !=0 && conversionArray.count !=0)
    {
        if (indexPath.section == 0) {
            return ;
        }
        else
        {
            NSMutableDictionary *dict = [conversionArray objectAtIndex:indexPath.row];
            HistoryConversionDetailVC *temp = [[HistoryConversionDetailVC alloc] initWithNibName:@"HistoryConversionDetailVC" bundle:nil];
            temp.detailsDict = dict;
            [[self navigationController] pushViewController:temp animated:YES];        }
    }else
    {
        if (myUser.transactions.count !=0)
        {
            if (indexPath.section == 0)
            {
                return ;
            }
            
        }
        else if((myUser.transactions.count == 0) && (conversionArray.count != 0))
        {
            if (indexPath.section == 0)
            {
                NSMutableDictionary *dict = [conversionArray objectAtIndex:indexPath.row];
                HistoryConversionDetailVC *temp = [[HistoryConversionDetailVC alloc] initWithNibName:@"HistoryConversionDetailVC" bundle:nil];
                temp.detailsDict = dict;
                [[self navigationController] pushViewController:temp animated:YES];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *myUser =[User sharedInstance];
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        if (myUser.transactions.count !=0 && conversionArray.count !=0)
        {
            if (indexPath.section == 0) {
                [aTableView beginUpdates];
                [myUser.transactions removeObjectAtIndex:indexPath.row];
                [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
                [aTableView endUpdates];
                [aTableView reloadData];
            }
            else
            {
                return;
            }
        }
        else
        {
            if (myUser.transactions.count !=0)
            {
                if (indexPath.section == 0)
                {
                    [aTableView beginUpdates];
                    [myUser.transactions removeObjectAtIndex:indexPath.row];
                    [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
                    [aTableView endUpdates];
                    [aTableView reloadData];
                }
            }
            else if((myUser.transactions.count == 0) && (conversionArray.count != 0))
            {
                if (indexPath.section == 0)
                {
                    return;
                }
            }
        }
    }
}

- (IBAction)BottomButtonTouched:(UIButton *)sender
{
    if(sender.tag == 3)
    {
        SettingVC *tempVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
        [[self navigationController] pushViewController:tempVC animated:YES];
    }
}

/*
-(void)callServiceForFetchingHistoryData
{
    BOOL state =         [CommonFunctions reachabiltyCheck];
    if (state)
    {
        self.table.userInteractionEnabled = NO;
        NSString *query = [NSString stringWithFormat:@"select CurrencyCardID from myCards"];
        NSMutableArray *currencyIdMA = [kHandler fetchingDataFromTable:query];
        [self fetchingHistoryData:currencyIdMA];
    }
}

-(void)fetchingHistoryData:(NSMutableArray *)currencyIdMA
{
    DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
    NSString *query = [NSString stringWithFormat:@"DELETE FROM getHistoryTable"];
    [dbHandler executeQuery:query];
    dbHandler= nil;
    NSLog(@"currencyIdMA.count ->%d",currencyIdMA.count);
    for (int i = 0;  i < [currencyIdMA count]; i++)
    {
        [self fetchingTransactions:[currencyIdMA objectAtIndex:i]];
    }
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
}

-(void)fetchingTransactions:(NSString *)cardId
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"khistoryData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<tem:GetHistory>"
                             "<tem:userName>%@</tem:userName>"
                             "<tem:password>%@</tem:password>"
                             "<tem:currencyCardID>%@</tem:currencyCardID>"
                             "</tem:GetHistory>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>",[keychain objectForKey:(__bridge id)kSecAttrAccount],[keychain objectForKey:(__bridge id)kSecValueData],cardId];
    
    currentId = cardId;
    sharedManager *shmanger = [[sharedManager alloc]init];
    [shmanger callServiceWithRequest:soapMessage methodName:@"GetHistory" andDelegate:self];
}

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{    
    TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
    TBXMLElement *root = tbxml.rootXMLElement;
    TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
    TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"GetHistoryResponse" parentElement:rootItemElem];
    TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"GetHistoryResult" parentElement:checkAuthGetCardsResponseElem];
    TBXMLElement *statusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
    NSString *statusIs = [TBXML textForElement:statusCode];
    self._array = [[NSMutableArray alloc]init];
    if ([statusIs isEqualToString:@"000"])
    {
        TBXMLElement *cardsElem = [TBXML childElementNamed:@"a:cardHistory" parentElement:checkAuthGetCardsResultElem];
        if(cardsElem)
        {
            TBXMLElement *CardElm    = [TBXML childElementNamed:@"a:CardHistory" parentElement:cardsElem];
            while (CardElm != nil)
            {
                TBXMLElement *_amount   = [TBXML childElementNamed:@"a:TxnAmount" parentElement:CardElm];
                NSString *amount = [TBXML textForElement:_amount];
                TBXMLElement *_date    = [TBXML childElementNamed:@"a:TxnDate" parentElement:CardElm];
                NSString *date = [TBXML textForElement:_date];
                TBXMLElement *_vendor    = [TBXML childElementNamed:@"a:Vendor" parentElement:CardElm];
                NSString *vendor = [TBXML textForElement:_vendor];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:amount,@"amount",date,@"date",vendor,@"vendor", nil];
                [self._array addObject:dict];
                CardElm = [TBXML nextSiblingNamed:@"a:CardHistory" searchFromElement:CardElm];
            }
        }
        [self updatingDatabase];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }     
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appDelegate doLogout];
    }
}
-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]]) {
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    }else{
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    }
    if (isLoadingViewAdded)
    {
        isLoadingViewAdded = FALSE;
        [self.loadingView removeFromSuperview];
        [self.table setUserInteractionEnabled:YES];
    }
    else
        [self.refreshControl endRefreshing];
}

-(void)updatingDatabase
{
    DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
    [dbHandler executeQuery:[NSString stringWithFormat:@"DELETE FROM getHistoryTable where currencyId = '%@'",currentId]];
    for(int i=0;i<self._array.count;i++)
    {
        NSMutableDictionary *dict = [self._array objectAtIndex:i];
        NSString *value = [dbHandler getDataValue:[NSString stringWithFormat:@"select CardCurrencyDescription from myCards where CurrencyCardID = %@",currentId]];
        NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO getHistoryTable('amount','date','vendor','currencyId','cardName') values (%f,\"%@\",\"%@\",\"%@\",\"%@\")",[[dict objectForKey:@"amount"] floatValue],[dict objectForKey:@"date"],[dict objectForKey:@"vendor"],currentId,value];
        [dbHandler executeQuery:queryStr];
    }
    dbHandler = nil;
}

-(void)reloadTable
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"])
    {
        NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
        NSLog(@"------------%@",[[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]]);
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
          [self.refreshControl endRefreshing];
    }
    if (historyArray.count > 0) 
          [historyArray removeAllObjects];
    
    historyArray = [[DatabaseHandler getSharedInstance] fetchingHistoryDataFromTable:@"SELECT * FROM getHistoryTable order by date DESC"];
    if (isLoadingViewAdded)
    {
        isLoadingViewAdded = FALSE;
        self.table.hidden = NO;
        [self.loadingView removeFromSuperview];
        [[self table] reloadData];
        [self.table addSubview:self.refreshControl];
    }
    else
    {
        [[self table] reloadData];
        [self.refreshControl endRefreshing];
    }
    self.table.userInteractionEnabled = YES;
}
*/
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setReceiptsButton:nil];
    [self setCaptureButton:nil];
    [self setSettingsButton:nil];
    [self setBottomView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

