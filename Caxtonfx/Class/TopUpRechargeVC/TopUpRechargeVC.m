//
//  TopUpRechargeVC.m
//  Caxtonfx
//
//  Created by Sumit on 08/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//errorLable.textColor = UIColorFromRedGreenBlue(213, 32, 39);

#import "TopUpRechargeVC.h"
#import "UIButton+CustomDesign.h"
#import "MyCardVC.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"


@interface TopUpRechargeVC ()

@end

@implementation TopUpRechargeVC

@synthesize scrollView,flagImgView,leftTxtField,rightTxtField,redView,dataDict,indexPath,defaultsArray,sybolString,counveronCurrencyString,counveronCurrencyArray,rightSymbolImgView,leftSymbolImgView,delegate;
@synthesize alertView,titleLable,textLbl,inputAccView;
@synthesize currentId;
@synthesize _array,notMessageView,warningLbl;

@synthesize firstSymbolLbl,scndSymbolLbl,twoTimeLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currentId = @"";
    sybolString = @"";
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self setNavigationTitle:[NSString stringWithFormat:@"Top-Up"]];
    
    UILabel *errorLable = (UILabel*)[self.view viewWithTag:15];
    errorLable.textColor = UIColorFromRedGreenBlue(32, 185, 213);

    firstSymbolLbl.font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:24];
    scndSymbolLbl.font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:24];
    firstSymbolLbl.textColor = UIColorFromRedGreenBlue(221, 139, 141);
    scndSymbolLbl.textColor = UIColorFromRedGreenBlue(221, 139, 141);
    [warningLbl setFont:[UIFont fontWithName:@"OpenSans" size:17]];
    [warningLbl setBackgroundColor:[UIColor clearColor]];
    [warningLbl setTextAlignment:NSTextAlignmentCenter];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.delegate = self;
    [scrollView addGestureRecognizer:gestureRecognizer];
    
    counveronCurrencyArray = [[NSMutableArray alloc]init];
    defaultsArray = [[NSMutableArray alloc]init];
    defaultsArray = [[DatabaseHandler getSharedInstance]getData:[NSString stringWithFormat:@"select * from getDefaults where productID = \"%@\"",[dataDict objectForKey:@"ProductTypeID"]]];

    [self setupPage];
    
    [Flurry logEvent:@"Visited Top-Up"];
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.customeTabBar setHidden:YES];
    appDelegate.topBarView.hidden = YES; 
}

-(void)setupPage
{
    if([[dataDict objectForKey:@"CardCurrencyDescription"] isEqualToString:@"GB pound"])
    {
        self.flagImgView.image = [UIImage imageNamed:@"GBPFlag"];
        sybolString = @"£";
        counveronCurrencyArray = [[DatabaseHandler getSharedInstance] getData:@"select *from globalRatesTable where CcyCode = \"GBP\" "];
    }
    else if([[dataDict objectForKey:@"CardCurrencyDescription"] isEqualToString:@"Euro"])
    {
        self.flagImgView.image = [UIImage imageNamed:@"topRightFlag"];
        sybolString = @"€";
        counveronCurrencyArray = [[DatabaseHandler getSharedInstance] getData:@"select *from globalRatesTable where CcyCode = \"EUR\" "];
    }
    else
    {
        self.flagImgView.image = [UIImage imageNamed:@"dolloetrvall"];
        sybolString = @"$";
        counveronCurrencyArray = [[DatabaseHandler getSharedInstance] getData:@"select *from globalRatesTable where CcyCode = \"USD\" "];
    }
    
    UILabel *currentBlance = (UILabel *)[self.scrollView viewWithTag:3];
    currentBlance.textColor = UIColorFromRedGreenBlue(39, 39, 39);
    currentBlance.font = [UIFont fontWithName:@"SegoeUI" size:13];
    
    UILabel *blance = (UILabel *)[self.scrollView viewWithTag:4];
    blance.backgroundColor = [UIColor clearColor];
    UIColor *firstColor=UIColorFromRedGreenBlue(102, 102, 102);
    UIColor *secondColor=UIColorFromRedGreenBlue(39, 39, 39);
    UIFont *firstfont=[UIFont fontWithName:@"OpenSans" size:36.0f];
    UIFont *secondfont=[UIFont fontWithName:@"OpenSans" size:65.0f];
    
    NSString *infoString= [NSString stringWithFormat:@"%@%.02f",sybolString,[[dataDict objectForKey:@"CardBalance"] floatValue]];
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:infoString];
    [attString addAttribute:NSFontAttributeName value:firstfont range:NSMakeRange(0, 1)];
    [attString addAttribute:NSFontAttributeName value:secondfont range:NSMakeRange(1, infoString.length-1)];
    [attString addAttribute:NSForegroundColorAttributeName value:firstColor range:NSMakeRange(0, 1)];
    [attString addAttribute:NSForegroundColorAttributeName value:secondColor range:NSMakeRange(1, infoString.length-1)];
    blance.attributedText = attString;
    
    UILabel *enterTopupLable = (UILabel *)[self.scrollView viewWithTag:6];
    enterTopupLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    enterTopupLable.font = [UIFont fontWithName:@"OpenSans" size:12];
    
    UILabel *minLable = (UILabel *)[self.scrollView viewWithTag:7];
    minLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    minLable.font = [UIFont fontWithName:@"OpenSans" size:9];
    minLable.text = [NSString stringWithFormat:@"(Minimum amount accepted is : %@%@)",sybolString,[[defaultsArray objectAtIndex:0]objectForKey:@"minTopUp"]];
    NSLog(@"minLable.text - > %@",minLable.text);
    NSLog(@"min topup %@",[defaultsArray objectAtIndex:0]);
    
    UILabel *rateofLable = (UILabel*)[self.scrollView viewWithTag:11];
    rateofLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    rateofLable.font = [UIFont fontWithName:@"OpenSans" size:12];
    
    UILabel *conversionLable = (UILabel*)[self.scrollView viewWithTag:12];
    conversionLable.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
    conversionLable.text = @"";
    if (counveronCurrencyArray.count > 0)
    {
          double conversn = [[[counveronCurrencyArray objectAtIndex:0]objectForKey:@"Rate" ] doubleValue];
        conversionLable.text = [NSString stringWithFormat:@"£1 = %@%f",sybolString,conversn];
    }
  
    
    
    UILabel *messageLable = (UILabel*)[self.scrollView viewWithTag:14];
    messageLable.font = [UIFont fontWithName:@"OpenSans" size:9];
    messageLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    
    twoTimeLable.font = [UIFont fontWithName:@"OpenSans" size:9];
    twoTimeLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    
    UILabel *equalLable = (UILabel*)[self.scrollView viewWithTag:13];
    equalLable.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:20];
    equalLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
    
    UILabel *checkLable = (UILabel *)[self.scrollView viewWithTag:15];
    checkLable.font = [UIFont fontWithName:@"OpenSans-Bold" size:10];
    
    UIButton *cancelBtn = (UIButton*)[self.scrollView viewWithTag:16];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"TopUpRechargeVCcancelBtn"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"TopUpRechargeVCcancelBtnHover"] forState:UIControlStateHighlighted];
    
    UIButton *topupBtn = (UIButton*)[self.scrollView viewWithTag:17];
    [topupBtn setBackgroundImage:[UIImage imageNamed:@"topUpBtnBg"] forState:UIControlStateNormal];
    [topupBtn setBackgroundImage:[UIImage imageNamed:@"topUpBtnBgHover"] forState:UIControlStateHighlighted];
    
    leftTxtField.textAlignment = NSTextAlignmentCenter;
    leftTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    leftTxtField.placeholder =[NSString stringWithFormat:@"     GBP"];
    
    rightTxtField.placeholder = [NSString stringWithFormat:@"     %@",[dataDict objectForKey:@"CardCurrencySymbol"]];
    
    firstSymbolLbl.text = @"£";
    
    NSString *querrystr = [NSString stringWithFormat:@"select * from currencySymbole_table where cardCurrencyId = %@",[dataDict objectForKey:@"CardCurrencyID"]];
    
    NSMutableArray *CardSymbolArray =[[DatabaseHandler getSharedInstance]getData:querrystr];
    NSDictionary *CardSymbolDict = [CardSymbolArray objectAtIndex:0];
    
    NSString *symboleStr = [CardSymbolDict objectForKey:@"symbol"];
    symboleStr = [symboleStr stringByConvertingHTMLToPlainText];
 
    scndSymbolLbl.text = symboleStr;
    
    UILabel *dataConnectionLbl = (UILabel *)[self.redView viewWithTag:20];
    dataConnectionLbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:10];
    
    rightSymbolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"CardCurrencySymbol"]]];
    
    redView.frame = CGRectMake(12, 235,294 , 55);
}

-(void)errorMsg : (NSString *)errorStr
{
    UILabel *errorLable = (UILabel*)[self.view viewWithTag:15];
    errorLable.text = errorStr;
    errorLable.textColor = UIColorFromRedGreenBlue(213, 32, 39);
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:17];
    [btn btnWithCrossImage];
}

-(IBAction)cancleBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)topUpBtnPressed:(id)sender
{
    if([CommonFunctions reachabiltyCheck])
    {
        if(rightTxtField.text.floatValue >= [[[defaultsArray objectAtIndex:0]objectForKey:@"minTopUp"]floatValue])
        {
            if(rightTxtField.text.floatValue <=[[[defaultsArray objectAtIndex:0]objectForKey:@"maxTopUp"]floatValue]){
                UIButton *topupBtn = (UIButton*)sender;
                [topupBtn btnWithActivityIndicator];
                [self.view setUserInteractionEnabled:NO];
                [self sendtopuprequest:topupBtn];
            }
            else
            {
                NSString *sessionHeighScorestr = [[defaultsArray objectAtIndex:0]objectForKey:@"maxTopUp"];
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                int highscore  = [sessionHeighScorestr intValue];
                 NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:highscore]];
                [self errorMsg:[NSString stringWithFormat:@"There is a maximum load value of %@%@. Please re-enter correct amount.",sybolString,formatted]];
            }
        }else
        {
            [self errorMsg:[NSString stringWithFormat:@"There is a minimum load value of %@%d. Please re-enter correct amount.",sybolString,[[[defaultsArray objectAtIndex:0]objectForKey:@"minTopUp"] intValue]]];
        }
    }
    else
    {
        
    if(rightTxtField.text.floatValue >= [[[defaultsArray objectAtIndex:0]objectForKey:@"minTopUp"]floatValue])
        {
            if(rightTxtField.text.floatValue <=[[[defaultsArray objectAtIndex:0]objectForKey:@"maxTopUp"]floatValue]){
                titleLable.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
                
                textLbl.font = [UIFont fontWithName:@"OpenSans" size:14];
                textLbl.textColor = UIColorFromRedGreenBlue(255, 255, 255);
                
                [self.view addSubview:alertView];
                
                if(IS_HEIGHT_GTE_568)
                {
                    [alertView setFrame:CGRectMake(11, 105, 298, 282)];
                }else{
                    [alertView setFrame:CGRectMake(11, 61, 298, 282)];
                }

            }else
            {
                NSString *sessionHeighScorestr = [[defaultsArray objectAtIndex:0]objectForKey:@"maxTopUp"];
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                int highscore  = [sessionHeighScorestr intValue];
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:highscore]];
                [self errorMsg:[NSString stringWithFormat:@"There is a maximum load value of %@%@. Please re-enter correct amount.",sybolString,formatted]];
            }
        }else
        {
            
            [self errorMsg:[NSString stringWithFormat:@"There is a minimum load value of %@%d. Please re-enter correct amount.",sybolString,[[[defaultsArray objectAtIndex:0]objectForKey:@"minTopUp"] intValue]]];
        }
    }
}

-(void)callHistoryApi
{
    [self callServiceForFetchingHistoryData];
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
    else
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:17];
        [btn btnWithoutActivityIndicator];
        [btn btnSuccess];
        [self performSelectorOnMainThread:@selector(topupResultget) withObject:nil waitUntilDone:NO];
    }
}

-(void)fetchingHistoryData:(NSMutableArray *)currencyIdMA
{
    for (int i = 0;  i < [currencyIdMA count]; i++)
    {
        dispatch_async(dispatch_queue_create("myGCDqueue",NULL), ^{
            [self fetchingTransactions:[currencyIdMA objectAtIndex:i]];
            
        });
    }
    
     [self performSelectorOnMainThread:@selector(topupResultget) withObject:nil waitUntilDone:NO];
}

-(void)fetchingTransactions:(NSString *)cardId
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"khistoryData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
     [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    sharedManager *manger = [[sharedManager alloc]init];
    manger.delegate = self;
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
    [manger callServiceWithRequest:soapMessage methodName:@"GetHistory" andDelegate:self];
    
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
    
   // [self performSelectorOnMainThread:@selector(topupResultget) withObject:nil waitUntilDone:NO];
}

-(void)sendtopuprequest : (UIButton*)btn
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
     [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
    sharedManager *manger = [[sharedManager alloc]init];
    manger.delegate = self;
    NSString *soapMessage =[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:TopUp><tem:userName>%@</tem:userName><tem:password>%@</tem:password><tem:currencyCardID>%@</tem:currencyCardID><tem:TopUpAmount>%@</tem:TopUpAmount><tem:CardCurrency>%@</tem:CardCurrency></tem:TopUp></soapenv:Body></soapenv:Envelope>",username1,password1,[dataDict objectForKey:@"CurrencyCardID"],leftTxtField.text,[dataDict objectForKey:@"CardCurrencySymbol"]];
    
    NSLog(@"Soap Message: %@",soapMessage);
    
    [manger callServiceWithRequest:soapMessage methodName:@"TopUp" andDelegate:self];
    
}
-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    if([service isEqualToString:@"TopUp"]){
        NSLog(@"Top Up Response: %@", response);
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *TopUpResponse = [TBXML childElementNamed:@"TopUpResponse" parentElement:rootItemElem];
        TBXMLElement *TopUpResult = [TBXML childElementNamed:@"TopUpResult" parentElement:TopUpResponse];
        TBXMLElement *success = [TBXML childElementNamed:@"a:success" parentElement:TopUpResult];
        TBXMLElement *cardBalance = [TBXML childElementNamed:@"a:cardBalance" parentElement:TopUpResult];
        NSString *cardBalanceStr = [TBXML textForElement:cardBalance];
        NSString *successStr = [TBXML textForElement:success];
        if([successStr isEqualToString:@"False"])
        {
            [self.dataDict setObject:@"YES" forKey:@"errorImageView"];
            [self.dataDict setObject:@"NO" forKey:@"successImageView"];
            UIButton *btn = (UIButton *)[self.view viewWithTag:17];
            [btn btnWithoutActivityIndicator];
            [btn btnWithCrossImage];
            [self performSelectorOnMainThread:@selector(topupResultget) withObject:nil waitUntilDone:NO];
        }else
        {
            [self.dataDict setObject:@"YES" forKey:@"successImageView"];
            [self.dataDict setObject:@"NO" forKey:@"errorImageView"];
            [self.dataDict setObject:cardBalanceStr forKey:@"CardBalance"];
            [self callHistoryApi];
        }
    }else if([service isEqualToString:@"GetBalance"])
    {
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *TopUpResponse = [TBXML childElementNamed:@"GetBalanceResponse" parentElement:rootItemElem];
        TBXMLElement *TopUpResult = [TBXML childElementNamed:@"GetBalanceResult" parentElement:TopUpResponse];
        NSString *blanceStr = [TBXML textForElement:TopUpResult];
        [self.dataDict setObject:blanceStr forKey:@"CardBalance"];
    }else
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
            [self performSelectorInBackground:@selector(updatingDatabase) withObject:nil ];
            UIButton *btn = (UIButton *)[self.view viewWithTag:17];
            [btn btnWithoutActivityIndicator];
            [btn btnSuccess];
//            [self performSelectorOnMainThread:@selector(topupResultget) withObject:nil waitUntilDone:NO];
            
        }
        else if ([statusIs isEqualToString:@"001"])
        {
            //    001 – card expired
        }
        else if ([statusIs isEqualToString:@"002"])
        {
            //    002 – account blocked
            
        }
    }
}

-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]]) {
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    }else{
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    }
    self.view.userInteractionEnabled = YES;
    if([service isEqualToString:@"TopUp"])
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:17];
        [btn btnWithoutActivityIndicator];
        [btn btnWithCrossImage];
        [self errorMsg:@"Unfortunately we were unable to load your card. Please try again."];
    }else
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:17];
        [btn btnWithoutActivityIndicator];
        [btn btnSuccess];
        [self performSelectorOnMainThread:@selector(topupResultget) withObject:nil waitUntilDone:NO];
    }
}

-(IBAction)openMsgApp:(id)sender
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil)
    {
        if ([messageClass canSendText])
        {
            [self displaySMSComposerSheet];
        }else
        {
            [self.alertView removeFromSuperview];
            [self.notMessageView setFrame:CGRectMake(11, 150, 298, 130)];
            [self.view addSubview:self.notMessageView];
            
        }
    }
}

-(void)displaySMSComposerSheet
{
    KeychainItemWrapper *keychain1 = [[KeychainItemWrapper alloc] initWithIdentifier:@"userDOB" accessGroup:nil];
   [keychain1 setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    NSString *DobStr = [keychain1 objectForKey:(__bridge id)kSecAttrAccount];
   
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"+44 753 740 2025",nil];
	picker.body = [NSString stringWithFormat:@" LOAD %@ %@ %@",[dataDict objectForKey:@"CardNumber"],DobStr,rightTxtField.text];
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[alertView removeFromSuperview];
	
	switch (result)                   // Notifies users about errors associated with the interface
	{
		case MessageComposeResultCancelled:
			NSLog(@"MessageComposeResultCancelled");
			break;
		case MessageComposeResultSent:
			NSLog(@"MessageComposeResultSent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"MessageComposeResultFailed");
			break;
		default:
			break;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)OkBtnPressed:(id)sender
{
    [self.notMessageView removeFromSuperview];
}
-(IBAction)cancelBtnPressed:(id)sender
{
    [alertView removeFromSuperview];
}

-(void)topupResultget
{
    self.view.userInteractionEnabled = YES;
    [delegate topupResult:self.indexPath dict:self.dataDict];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) hideKeyBoard:(id) sender
{
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void) setNavigationTitle:(NSString *) title
{
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f,200.0f, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 200.0f,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:title];
    [view addSubview:titleLbl];
    
    [self.navigationItem setTitleView:view];
}
-(void)createInputAccessoryView{

    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 45.0)];
    [inputAccView setBackgroundColor:[UIColor clearColor]];
    [inputAccView setAlpha: 1.0];

    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(10.0, 0.0f, 77.0f, 42.0f)];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"returnBtn"] forState:UIControlStateNormal];
    
    [inputAccView addSubview:btnDone];
}

-(void)doneBtnPressed
{
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
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
    
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField setInputAccessoryView:inputAccView];
    if(IS_HEIGHT_GTE_568){}else{
        [self scrollViewToCenterOfScreen:textField];
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:17];
    [btn btnWithoutActivityIndicator];
    [btn btnWithOutCheckImage];
    [btn btnWithOutCrossImage];

}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range
replacementString: (NSString*) string {
    NSLog(@"textField.text %@",textField.text);
    NSLog(@"string %@",string);
    UIButton *btn = (UIButton *)[self.view viewWithTag:17];
    [btn btnWithoutActivityIndicator];
    [btn btnWithOutCheckImage];
    [btn btnWithOutCrossImage];


    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength>5)
    {
        
        return NO;
    }
    
    
    if(textField==leftTxtField)
    {
        
        NSString * text = [leftTxtField.text stringByReplacingCharactersInRange:range
                                                                     withString: string];
        if([text length] !=0)
        {
            
            leftTxtField.text = text;
            
            float newprice  = 0.0f;
            
            if (counveronCurrencyArray.count > 0)
            {
                newprice = text.floatValue * [[[counveronCurrencyArray objectAtIndex:0]objectForKey:@"Rate"]floatValue];
                
               
            }
            else{
                newprice = text.floatValue * 0.0f;
            }
            
            rightTxtField.text = [NSString stringWithFormat:@"%.02f",newprice];
            
            NSLog(@"rightTxtField = %@", rightTxtField.text );

            
        }
        else
        {
            leftTxtField.text =@"";
            rightTxtField.text = @"";
        }
        
        return NO;
    }
    else
    {
        NSString * text = [rightTxtField.text stringByReplacingCharactersInRange:range
                                                                      withString: string];
        NSLog(@"%@",text);
        if([text length] !=0){
            
            rightTxtField.text = text;
            float newprice  = 0.0f;
            if (counveronCurrencyArray.count > 0)
            {
                newprice = text.floatValue / [[[counveronCurrencyArray objectAtIndex:0]objectForKey:@"Rate"]floatValue];
                
               
            }
          
            leftTxtField.text = [NSString stringWithFormat:@"%.02f",newprice];
            
            NSLog(@"leftTxtField.text = %@", leftTxtField.text );
            
        }else
        {
            leftTxtField.text = @"";
            rightTxtField.text = @"";
        }
        return  NO;
    }
    
    return  YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

#pragma mark -----
#pragma mark Touch Delegate method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view == self.scrollView)
        [self.view endEditing:YES];
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
