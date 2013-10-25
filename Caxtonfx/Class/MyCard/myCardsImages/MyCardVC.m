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

-(NSInteger )hourSinceNow
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    NSDate* date2 =  [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"[dateFormatter stringFromDate:date2]  ->%@", [dateFormatter stringFromDate:date2]);
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date1];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    return hoursBetweenDates;
}

#pragma mark -------
#pragma mark view lyf cycle Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] % 3 ==0)
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
    
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        [self getDataFromDataBse];
    });
    
//    [self getDataFromDataBse];  Deepesh
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[AppDelegate getSharedInstance] topBarView] setHidden:NO];
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:NO];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[AppDelegate getSharedInstance] topBarView] setHidden:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:NO];
}

#pragma mark other Method

-(void)getDataFromDataBse
{
    
    if(self.cardsArray.count > 0)
    {
        [self.cardsArray removeAllObjects];
    }else
    {
        self.cardsArray = [[NSMutableArray alloc]init];
    }
    self.cardsArray = [[DatabaseHandler getSharedInstance] getData:@"select * from myCards"];
    
    NSLog(@"%@", cardsArray);
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.tableView.userInteractionEnabled = YES;
                       
                       [self.tableView reloadData];
                   });
}

- (void)refresh :(id)sender
{
    self.tableView.userInteractionEnabled = NO;
    
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[CommonFunctions statusOfLastUpdate:date1]];
    
    if([CommonFunctions reachabiltyCheck])
    {
        [self performSelectorInBackground:@selector(fetchTheData) withObject:self];
    }else
    {
        [self.refreshControl endRefreshing];
        self.tableView.userInteractionEnabled = YES;
    }
}

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


-(void)topupBtnPressed:(NSIndexPath*)indexPath;
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userConactType"]isEqualToString:@"1"])
    {
        TopUpRechargeVC *topupVC = [[TopUpRechargeVC alloc]initWithNibName:@"TopUpRechargeVC" bundle:nil];
        topupVC.delegate = self;
        topupVC.dataDict = [[self.cardsArray objectAtIndex:indexPath.row] mutableCopy];
        topupVC.indexPath = indexPath;
        [self.navigationController pushViewController:topupVC animated:YES];
    }
}

#pragma mark ShareMangerDelagte

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
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
    if([statusCodeStr intValue]!= 001 || [statusCodeStr intValue]!= 002 )
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
            [[DatabaseHandler getSharedInstance] executeQuery:@"DELETE FROM myCards" ];
            for(int i=0;i<array.count;i++)
            {
                dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void)
                               {
                    NSMutableDictionary *dict = [array objectAtIndex:i];
                    NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO myCards values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[dict objectForKey:@"CurrencyCardIDStr"],[dict objectForKey:@"CurrencyCardTypeIDStr"],[dict objectForKey:@"ProductTypeIDStr"],[dict objectForKey:@"CardCurrencyIDStr"],[dict objectForKey:@"cardBalanceStr"],[dict objectForKey:@"CardCurrencyDescriptionStr"],[dict objectForKey:@"CardCurrencySymbolStr"],[dict objectForKey:@"CardNameStr"],[dict objectForKey:@"CardNumberStr"],[dict objectForKey:@"CardTypeStr"],@"NO",@"NO"];
                    
                    [[DatabaseHandler getSharedInstance]executeQuery:queryStr];
                });
            }
            
            NSDate *today = [NSDate date];
            dateInString = [today description];
            [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDate"];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }
    }
//    [self performSelectorOnMainThread:@selector(fetchTheValueFromDataBase) withObject:nil waitUntilDone:NO];
    
    [self fetchTheValueFromDataBase];
    
}
-(void) fetchTheValueFromDataBase
{
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void)
                   {
                       [self getDataFromDataBse];
                       
                       [self.refreshControl endRefreshing];
                   });
    
    
    
    
}

-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    
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

#pragma mark -------
#pragma mark TableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.cardsArray.count==0)
    {
        return 1;
    }
    else
    {
        return [self.cardsArray count];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 173;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.cardsArray.count==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textLabel setText:@"No cards currently active for this user."];
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = UIColorFromRedGreenBlue(204, 204, 204);
        return cell;
    }else
    {
        static NSString *cellIdentifier = @"currencyCellIdentifier";
        
        MyCardsTableCell *cell = [tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell = [[MyCardsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyCardsTableCell"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
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
        
        NSDictionary *dict = [self.cardsArray objectAtIndex:indexPath.row];
        
        NSLog(@"cardsArray dict %@",dict);
        
        if([[dict objectForKey:@"CardCurrencyDescription"] isEqualToString:@"GB pound"])
        {
            cell.flagImgView.image = [UIImage imageNamed:@"GBPFlag"];
            
        }else  if([[dict objectForKey:@"CardCurrencyDescription"] isEqualToString:@"Euro"])
        {
            cell.flagImgView.image = [UIImage imageNamed:@"euroFlag"];
        }else
        {
            cell.flagImgView.image = [UIImage imageNamed:@"dolloeFlag"];
        }
        
        [NSThread detachNewThreadSelector:@selector(setSymbolValue:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"dict",cell.blnceLable,@"lbl", nil]];
        
        cell.accountNameLable.text = [dict objectForKey:@"CardName"];
        cell.accountTypeLable.text = [dict objectForKey:@"CardNumber"];//@"MAIN ACCOUNT CARD";
        cell.currentBlnceLable.text = @"Your current balance is";

        if([[dict objectForKey:@"errorImageView"] isEqualToString:@"YES"])
            cell.errorImgView.hidden= NO;
        else
            cell.errorImgView.hidden= YES;
        
        if([[dict objectForKey:@"successImageView"] isEqualToString:@"YES"])
            cell.succesImgView.hidden = NO;
        else
            cell.succesImgView.hidden = YES;
        
        return cell;
    }
}

-(void) setSymbolValue:(NSDictionary*) dic
{
    NSString *querrystr = [NSString stringWithFormat:@"select * from currencySymbole_table where cardCurrencyId = %@",[[dic objectForKey:@"dict"] objectForKey:@"CardCurrencyID"]];
    
    NSLog(@"querrystr = %@",querrystr );
    
    NSString *symbolStr = @"";
    NSString *CardCurrencyID =   [[dic objectForKey:@"dict"] objectForKey:@"CardCurrencyID"];
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
    
    NSString *blncLblStr = [NSString stringWithFormat:@"%@%.02f",symbolStr,[[[dic objectForKey:@"dict"] objectForKey:@"CardBalance"] floatValue]];
    
    [self performSelectorOnMainThread:@selector(seTheLbl:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:blncLblStr,@"blncLblStr",[dic objectForKey:@"lbl"],@"lbl", nil] waitUntilDone:NO];
    
}

-(void) seTheLbl:(NSDictionary *) dic
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    [self.cardsArray replaceObjectAtIndex:path.row  withObject:dict];
    [self.tableView reloadData];
}


@end
