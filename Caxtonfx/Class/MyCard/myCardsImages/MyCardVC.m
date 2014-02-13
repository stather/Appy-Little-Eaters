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
@interface MyCardVC ()

@end

@implementation MyCardVC

@synthesize tableView,heightConstraint,cardsArray,contentArray;
@synthesize refreshControl;

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
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    // Configure View Controller
    [self.tableView addSubview:self.refreshControl];
    [self.tableView removeConstraint:heightConstraint];
    if(IS_HEIGHT_GTE_568)
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:438];
        [self.tableView addConstraint:heightConstraint];
    }else
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:350];
        [self.tableView addConstraint:heightConstraint];
    }
    [Flurry logEvent:@"Visited Cards Screen"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[AppDelegate getSharedInstance] topBarView] setHidden:YES];
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:NO];
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self customizingNavigationBar];
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
    
    /****** add custom left bar button (Refresh Button) at navigation bar  **********/
    UIBarButtonItem * doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(hudRefresh:)];
    //TO-DO add custom image that is the same for iOS 6/7
    doneButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:doneButton];
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
    NSLog(@"TIME: %ld",(long)[[AppDelegate getSharedInstance] minutesSinceNow]);
    User *myUser = [User sharedInstance];
    myUser.cards =[myUser loadCardsFromDatabasewithRemote:NO];
    if ([[AppDelegate getSharedInstance] minutesSinceNowCardsOnly] > 10)
    {
        [self performSelector:@selector(hudRefresh:) withObject:self afterDelay:5.0];
    }
}


/*
-(void)getDataFromDataBse
{
    if(self.cardsArray.count > 0)
    {
        [self.cardsArray removeAllObjects];
    }else
    {
        self.cardsArray = [[NSMutableArray alloc] init];
    }
    self.cardsArray = [[DatabaseHandler getSharedInstance] getData:@"select * from myCards;"];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.tableView.userInteractionEnabled = YES;
                       [self.tableView reloadData];
                   });
}
*/
- (void)refresh :(id)sender
{
    self.tableView.userInteractionEnabled = NO;
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    if([CommonFunctions reachabiltyCheck])
    {
        //[self performSelectorInBackground:@selector(fetchTheData) withObject:self];
        [self performSelectorInBackground:@selector(updateCards) withObject:nil];
    }else
    {
        [self.refreshControl endRefreshing];
        self.tableView.userInteractionEnabled = YES;
    }
}
- (void)hudRefresh :(id)sender
{
    MBProgressHUD* HUD= [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    self.tableView.userInteractionEnabled = NO;
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    if([CommonFunctions reachabiltyCheck])
    {
        //[HUD showWhileExecuting:@selector(fetchTheData) onTarget:self withObject:self animated:YES];
        [HUD showWhileExecuting:@selector(updateCards) onTarget:self withObject:self animated:YES];
    }else
    {
        [self.refreshControl endRefreshing];
        self.tableView.userInteractionEnabled = YES;
    }
}
-(void) updateCards{
    User *myUser = [User sharedInstance];
    [myUser loadCardsFromDatabasewithRemote:YES];
    [self.refreshControl endRefreshing];
    self.tableView.userInteractionEnabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
/*
-(void) fetchTheData
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
    NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
    sharedManager *manger = [[sharedManager alloc]init];
    manger.delegate = self;
    NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",username1,password1];
    [manger callServiceWithRequest:soapMessage methodName:@"CheckAuthGetCards" andDelegate:self];
}
*/

-(void)topupBtnPressed:(NSIndexPath*)indexPath;
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userConactType"]isEqualToString:@"1"])
    {
        User * myUser = [User sharedInstance];
        TopUpRechargeVC *topupVC = [[TopUpRechargeVC alloc]initWithNibName:@"TopUpRechargeVC" bundle:nil];
        topupVC.delegate = self;
        //topupVC.dataDict = [[self.cardsArray objectAtIndex:indexPath.row] mutableCopy];
        topupVC.dataDict = [myUser.cards objectAtIndex:indexPath.row];
        topupVC.indexPath = indexPath;
        [self.navigationController pushViewController:topupVC animated:YES];
    }
}

#pragma mark ShareMangerDelagte
/*
-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    NSLog(@"CheckAuthGetCards - > %@",response);
    NSMutableArray *array = [[NSMutableArray alloc] init];
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
            for(int i=0;i<array.count;i++)
            {
                dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void)
                               {
                    NSMutableDictionary *dict = [array objectAtIndex:i];
                    NSString *queryStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO myCards values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[dict objectForKey:@"CurrencyCardIDStr"],[dict objectForKey:@"CurrencyCardTypeIDStr"],[dict objectForKey:@"ProductTypeIDStr"],[dict objectForKey:@"CardCurrencyIDStr"],[dict objectForKey:@"cardBalanceStr"],[dict objectForKey:@"CardCurrencyDescriptionStr"],[dict objectForKey:@"CardCurrencySymbolStr"],[dict objectForKey:@"CardNameStr"],[dict objectForKey:@"CardNumberStr"],[dict objectForKey:@"CardTypeStr"],@"NO",@"NO"];
                    [[DatabaseHandler getSharedInstance]executeQuery:queryStr];
                });
            }
            NSDate *today = [NSDate date];
            dateInString = [today description];
            [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
    //[self fetchTheValueFromDataBase];
}
 -(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
 {
 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Communication Error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
 alert.tag = 1;
 [alert show];
 if ([error isKindOfClass:[NSString class]]) {
 NSLog(@"Service: %@ | Response is  : %@",service,error);
 }else{
 NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
 }
 [self.refreshControl endRefreshing];
 self.tableView.userInteractionEnabled = YES;
 [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDate"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 }
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 ){
        if (buttonIndex == 0)
        {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appDelegate doLogout];
        }
    }
}
/*
-(void) fetchTheValueFromDataBase
{
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void)
                   {
                       [self getDataFromDataBse];
                       [self.refreshControl endRefreshing];
                   });
}
*/


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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell.textLabel setText:@"No cards currently active for this user. \nPull down to refresh."];
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
        static NSString *cellIdentifier = @"currencyCellIdentifier";
        MyCardsTableCell *cell = [tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[MyCardsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
            //dict = [self.cardsArray objectAtIndex:indexPath.row];
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
        [self.tableView reloadData];
        [self performSelector:@selector(hudRefresh:) withObject:self afterDelay:10.0];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
- (void)topupResult:(NSIndexPath*)path WithCard :(Card*)myCard{
    @try {
        [self.tableView reloadData];
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
        [self.tableView reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


@end
