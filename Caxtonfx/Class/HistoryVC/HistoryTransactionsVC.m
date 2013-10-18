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


-(NSInteger )hourSinceNow
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
    NSDate* date2 =  [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    return hoursBetweenDates;
}

- (void)refresh :(id)sender
{
    
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
     self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    
    if([CommonFunctions reachabiltyCheck])
    {
        if ([self hourSinceNow] < 24)
        {
            [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
        }
        else
        {
            [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
        }
        
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

    [self.table removeConstraint:heightConstraint];
    if(IS_HEIGHT_GTE_568)
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:504];
        [self.table addConstraint:heightConstraint];
    }else
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:416];
        [self.table addConstraint:heightConstraint];
    }
    
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

    UIButton *recieptsBtn = (UIButton*) [appDelegate.bottomView viewWithTag:1];
    [appDelegate BottomButtonTouched:recieptsBtn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [[appDelegate bottomView] setFrame:CGRectMake(0.0f, appDelegate.window.frame.size.height-55.0f, 320.0f, 55.0f)];
    [UIView commitAnimations];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent=NO;
    }
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
    
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 250.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:@"Latest card transactions"];
    [titleLbl.layer setShadowRadius:1.0f];
    [titleLbl.layer setShadowColor:[[UIColor colorWithRed:176.0f/255.0f green:19.0f/255.0f blue:25.0f/255.0f alpha:1.0f] CGColor]];
    [titleLbl.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [titleLbl.layer setShadowOpacity:1.0f];
    [titleLbl setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:titleLbl];
    
    NSMutableDictionary *dict = [historyArray objectAtIndex:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:[dict objectForKey:@"date"]];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *dateIs = [df stringFromDate:date];
    [df setDateFormat:@"HH:mm"];
    
    NSString *timeIs = [df stringFromDate:date];
    
    //set title
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
            cell = [[TransactionCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCustomCell"
                                                         owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    
    NSMutableDictionary *dict = [historyArray objectAtIndex:indexPath.row];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        cell.merchantNameLabel.font = [self fontForBodyTextStyle];
        cell.currencyValueLabel.font = [self fontForBodyTextStyle];
        cell.timeCountryDateLabel.font = [self fontForCaptionTextStyle];
        cell.cardUsedLabel.font = [self fontForCaptionTextStyle];
        
    }
    
    cell.merchantNameLabel.text =[dict objectForKey:@"vendor"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [df setLocale:formatterLocale];
    NSDate *date = [df dateFromString:[dict objectForKey:@"date"]];
    
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *dateIs = [df stringFromDate:date];
    [df setDateFormat:@"HH:mm"];
    
    NSString *timeIs = [df stringFromDate:date];
    
    cell.timeCountryDateLabel.text = [NSString stringWithFormat:@"%@ | %@",timeIs,dateIs];
//    cell.cardUsedLabel.text = [dict objectForKey:@"cardName"];
    cell.currencyValueLabel.text = [NSString stringWithFormat:@"%.02f",[[dict objectForKey:@"amount"] floatValue]];
    
    NSString *cardString ;
    NSString *cardNameString =[dict objectForKey:@"cardName"];
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

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        if (indexPath.section == 0) {
            NSMutableDictionary *dic = [historyArray objectAtIndex:indexPath.row];
            [self deleteFromDB:dic];
            [historyArray removeObjectAtIndex:indexPath.row];
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

//delete from database
- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo
{
    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM getHistoryTable WHERE id = %@",[receiptInfo objectForKey:@"id"]];
    DatabaseHandler *dbHAndler =[[DatabaseHandler alloc] init];
    [dbHAndler executeQuery:sqlStatement];
}



- (IBAction)BottomButtonTouched:(UIButton *)sender
{
    if(sender.tag == 3)
    {
        SettingVC *tempVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
        [[self navigationController] pushViewController:tempVC animated:YES];
    }
}


-(void)callServiceForFetchingHistoryData
{
    NSString *query = [NSString stringWithFormat:@"select CurrencyCardID from myCards"];
    NSMutableArray *currencyIdMA = [kHandler fetchingDataFromTable:query];
    
    BOOL state =         [CommonFunctions reachabiltyCheck];
    if (state)
    {
        [self fetchingHistoryData:currencyIdMA];
    }
}

-(void)fetchingHistoryData:(NSMutableArray *)currencyIdMA
{
    for (int i = 0;  i < [currencyIdMA count]; i++)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchingTransactions:[currencyIdMA objectAtIndex:i]];
            
            
        });
    }
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
   
    [[sharedManager getSharedInstance] callServiceWithRequest:soapMessage methodName:@"GetHistory" andDelegate:self];
    
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
        [[DatabaseHandler getSharedInstance] executeQuery:[NSString stringWithFormat:@"DELETE FROM getHistoryTable where currencyId = '%@'",currentId]];
        for(int i=0;i<self._array.count;i++)
        {
            NSMutableDictionary *dict = [self._array objectAtIndex:i];
            NSString *value = [[DatabaseHandler getSharedInstance] getDataValue:[NSString stringWithFormat:@"select CardCurrencyDescription from myCards where CurrencyCardID = %@",currentId]];
            NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO getHistoryTable('amount','date','vendor','currencyId','cardName') values (%f,\"%@\",\"%@\",\"%@\",\"%@\")",[[dict objectForKey:@"amount"] floatValue],[dict objectForKey:@"date"],[dict objectForKey:@"vendor"],currentId,value];
    
            [[DatabaseHandler getSharedInstance]executeQuery:queryStr];
        }
    }
    else if ([statusIs isEqualToString:@"001"])
    {
        //    001 – card expired
    }
    else if ([statusIs isEqualToString:@"002"])
    {
        //    002 – account blocked
    }
    
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
}

-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]]) {
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    }else{
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    }
     [self.refreshControl endRefreshing];
}

-(void)reloadTable
{
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString *query = @"";
    query = [NSString stringWithFormat:@"SELECT * FROM getHistoryTable order by date DESC"];
    tempArray = [[DatabaseHandler getSharedInstance] fetchingHistoryDataFromTable:query];
    [historyArray removeAllObjects];
    historyArray = [tempArray mutableCopy];
    [[self table] reloadData];
    [self.refreshControl endRefreshing];
    
    NSMutableDictionary *dict = [historyArray objectAtIndex:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:[dict objectForKey:@"date"]];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *dateIs = [df stringFromDate:date];
    [df setDateFormat:@"HH:mm"];
    NSString *timeIs = [df stringFromDate:date];
    [self.titleNameLbl setText:[NSString stringWithFormat:@"%@ | %@",dateIs,timeIs]];
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

