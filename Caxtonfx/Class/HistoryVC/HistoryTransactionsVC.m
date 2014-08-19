//
//  HistoryTransactionsVC.m
//  Caxtonfx
//
//  Created by Nishant on 24/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "HistoryTransactionsVC.h"
#import "TransactionCustomCell.h"
#import "SettingVC.h"
#import "User.h"
#import "Transaction.h"

@interface HistoryTransactionsVC ()

@end

@implementation HistoryTransactionsVC

@synthesize bottomView;
@synthesize table;
@synthesize historyArray;
@synthesize receiptsButton;
@synthesize captureButton;
@synthesize settingsButton;
@synthesize titleNameLbl;
@synthesize titletimeDateLbl,currentId,_array;
@synthesize heightConstraint;
@synthesize refreshControl;

- (void)refresh :(id)sender
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    if([CommonFunctions reachabiltyCheck])
    {
        User *myUser = [User sharedInstance];
        myUser.transactions = [myUser loadTransactionsForUSer:myUser.username withRemote:YES];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self.refreshControl endRefreshing];
    }
}
- (void)userTextSizeDidChange {
	[self.table reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    // Configure View Controller
    [self.table addSubview:self.refreshControl];
    [self customizingNavigationBar];
    _tempMA = [[NSMutableArray alloc] init];
    self.table.sectionHeaderHeight = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userTextSizeDidChange)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [AppDelegate getSharedInstance];
    [[appDelegate customeTabBar] setHidden:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [[appDelegate bottomView] setFrame:CGRectMake(0.0f, appDelegate.window.frame.size.height-55.0f, 320.0f, 55.0f)];
    [UIView commitAnimations];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent=NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.table.contentInset = UIEdgeInsetsZero;
    self.table.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate = [AppDelegate getSharedInstance];
    [[appDelegate customeTabBar] setHidden:NO];
}

-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView setBackgroundColor:[UIColor clearColor]];

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 250.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:@"Full transaction history"];
    [titleLbl.layer setShadowRadius:1.0f];
    [titleLbl.layer setShadowColor:[[UIColor colorWithRed:176.0f/255.0f green:19.0f/255.0f blue:25.0f/255.0f alpha:1.0f] CGColor]];
    [titleLbl.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [titleLbl.layer setShadowOpacity:1.0f];
    [titleLbl setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:titleLbl];
    Transaction *dict = [historyArray objectAtIndex:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:dict.txnDate];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *dateIs = [df stringFromDate:date];
    [df setDateFormat:@"HH:mm"];
    NSString *timeIs = [df stringFromDate:date];

    self.titleNameLbl= [[UILabel alloc] initWithFrame:CGRectMake(85, 15.0f, 150.0f, 30.0f)];
    [self.titleNameLbl setBackgroundColor:[UIColor clearColor]];
    [self.titleNameLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:9.0f]];
    [self.titleNameLbl setTextColor:[UIColor whiteColor]];
    [self.titleNameLbl setText:[NSString stringWithFormat:@"%@ | %@",dateIs,timeIs]];
    [self.titleNameLbl.layer setShadowRadius:1.0f];
    [self.titleNameLbl.layer setShadowColor:[[UIColor colorWithRed:176.0f/255.0f green:19.0f/255.0f blue:25.0f/255.0f alpha:1.0f] CGColor]];
    [self.titleNameLbl.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [self.titleNameLbl.layer setShadowOpacity:1.0f];
    [self.titleNameLbl setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:self.titleNameLbl];
    [self.navigationItem setTitleView:titleView];
    /****** add custom left bar button (Back to history Button) at navigation bar  **********/
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(0,0,32,32);
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [historyBtn addTarget:self action:@selector(backToHistoryBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
}

-(void)backToHistoryBtnTouched:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView setBackgroundColor:[UIColor darkGrayColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 200,22)];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:16.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    NSString *sectionName= nil;
    switch (section) {
        case 0:
            sectionName = @"Latest CFX Transactions";
            break;

        default:
            break;
    }
    [titleLabel setText:sectionName];
    [headerView addSubview:titleLabel];
    return nil;
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
    TransactionCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCustomCell"
                                                         owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    Transaction *dict = [historyArray objectAtIndex:indexPath.row];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        cell.merchantNameLabel.font = [self fontForBodyTextStyle];
        cell.currencyValueLabel.font = [self fontForBodyTextStyle];
        cell.timeCountryDateLabel.font = [self fontForCaptionTextStyle];
        cell.cardUsedLabel.font = [self fontForCaptionTextStyle];
    }
    cell.merchantNameLabel.text =dict.vendor;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [df setLocale:formatterLocale];
    NSDate *date = [df dateFromString:dict.txnDate];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *dateIs = [df stringFromDate:date];
    [df setDateFormat:@"HH:mm"];
    NSString *timeIs = [df stringFromDate:date];
    cell.timeCountryDateLabel.text = [NSString stringWithFormat:@"%@ | %@",timeIs,dateIs];
    cell.currencyValueLabel.text = [NSString stringWithFormat:@"%.02f",[dict.txnAmount floatValue]];
    NSString *cardString ;
    NSString *cardNameString =dict.cardName;
    if([cardNameString isEqualToString:@"Euro"])
    {
        cardString = @"Europe Traveller card";
    }else if([cardNameString isEqualToString:@"GB pound"])
    {
        cardString = @"Global Traveller card";
    }else
    {
        cardString = @"Dollar Traveller card";
    }
    cell.cardUsedLabel.text = cardString;
    if (selectedIndex == indexPath.row)
        [cell setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
   else
        [cell setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 83, 320, 1)];
    [lineView setBackgroundColor:UIColorFromRedGreenBlue(220, 220, 220)];
    [cell addSubview:lineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
}
-(void)reloadTable
{
    [self.table reloadData];
    [self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidUnload
{
    [self setReceiptsButton:nil];
    [self setCaptureButton:nil];
    [self setSettingsButton:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

