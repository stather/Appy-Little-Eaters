//
//  User.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 30/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "User.h"
#import "Card.h"
#import "AppDelegate.h"
#import "Transaction.h"
#import "DefaultsObject.h"

@implementation User
@synthesize dateOfBirth;
@synthesize cards;
@synthesize contactType;
@synthesize mobileNumber;
@synthesize statusCode;
@synthesize username;
@synthesize password;
@synthesize transactions;
@synthesize mutableData;
@synthesize globalRates;
@synthesize defaultsArray;
@synthesize devMode;

-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.dateOfBirth=@"";
        self.cards=[NSMutableArray array];
        self.contactType=@"";
        self.mobileNumber=@"";
        self.statusCode=@"";
        self.username=@"";
        self.password=@"";
        self.transactions = [NSMutableArray array];
        self.globalRates  = [NSMutableArray array];
        self.defaultsArray = [NSMutableArray array];
        self.devMode = TRUE ;
    }
    return self;
}
+(id)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

-(id)initWithUserid:(NSString *)userId andDateOfBirth:(NSString *)userDob andContactType:(NSString *)userContactType andMobileNumber:(NSString *)userMobileNumber andStatusCode:(NSString *)userStatusCode andPassword:(NSString *)userPassword andCards:(NSMutableArray *)userCardsArray{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.dateOfBirth=userDob;
        self.cards=userCardsArray;
        self.contactType=userContactType;
        self.mobileNumber=userMobileNumber;
        self.statusCode=userStatusCode;
        self.username=userId;
        self.password=userPassword;
    }
    return self;
}
- (NSMutableArray *)loadDefaultsWithRemote:(BOOL)remote{
    
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];

    NSMutableArray *defaultsFinal = [[NSMutableArray alloc] init];
    if (remote) {
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetDefaults/></soapenv:Body></soapenv:Envelope>";
        NSArray *getDefaultDataArr= [self callWebServiceWithSoapRequest:soapMessage andMethodName:@"GetDefaults"];
        if (getDefaultDataArr.count>0) {
            [database executeUpdate:@"DELETE FROM getDefaults"];
            for (int i = 0; i < getDefaultDataArr.count ; i++)
            {
                NSString *query = [NSString stringWithFormat:@"insert into getDefaults values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[getDefaultDataArr objectAtIndex:i] valueForKey:@"ccy"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"description"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"maxTopUp"],[[getDefaultDataArr objectAtIndex:i] valueForKey:@"maxTotalBalance"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"minTopUp"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"productID"]];
                [database executeUpdate:query];
            }
            
            FMResultSet *defaultsArrayNew = [database executeQuery:@"select * from getDefaults"];
            while ([defaultsArrayNew next]) {
                DefaultsObject *myDef = [[DefaultsObject alloc] init];
                myDef.ccy = [defaultsArrayNew stringForColumn:@"ccy"];
                myDef.description = [defaultsArrayNew stringForColumn:@"description"];
                myDef.maxTopUp = [defaultsArrayNew stringForColumn:@"maxTopUp"];
                myDef.maxTotalBalance = [defaultsArrayNew stringForColumn:@"maxTotalBalance"];
                myDef.minTopUp = [defaultsArrayNew stringForColumn:@"minTopUp"];
                myDef.productId = [defaultsArrayNew stringForColumn:@"productID"];
                [defaultsFinal addObject:myDef];
            }
        }
    }else{
        FMResultSet *defaultsArrayNew = [database executeQuery:@"select * from getDefaults"];
        while ([defaultsArrayNew next]) {
            DefaultsObject *myDef = [[DefaultsObject alloc] init];
            myDef.ccy = [defaultsArrayNew stringForColumn:@"ccy"];
            myDef.description = [defaultsArrayNew stringForColumn:@"description"];
            myDef.maxTopUp = [defaultsArrayNew stringForColumn:@"maxTopUp"];
            myDef.maxTotalBalance = [defaultsArrayNew stringForColumn:@"maxTotalBalance"];
            myDef.minTopUp = [defaultsArrayNew stringForColumn:@"minTopUp"];
            myDef.productId = [defaultsArrayNew stringForColumn:@"productID"];
            [defaultsFinal addObject:myDef];
        }
    }
    [database close];
    return defaultsFinal;
}
-(GlobalRatesObject *)loadGlobalRateForCcyCode:(NSString *)ccyCode{
    GlobalRatesObject *myGlObj= [[GlobalRatesObject alloc] init];
    for (GlobalRatesObject *temp in self.globalRates) {
        if ([temp.ccyCode isEqualToString:ccyCode]) {
            myGlObj = temp;
            break;
        }
    }
    return myGlObj;
}
- (NSMutableArray *)loadGlobalRatesWithRemote:(BOOL)remote{
    
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray *globalRatesFinal = [[NSMutableArray alloc] init];
    if (remote) {
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetGlobalRates/></soapenv:Body></soapenv:Envelope>";
        NSArray *tempRates= [self callWebServiceWithSoapRequest:soapMessage andMethodName:@"GetGlobalRates"];
        if (tempRates.count>0) {
            [database executeUpdate:@"DELETE FROM globalRatesTable"];
            [database executeUpdate:@"DELETE FROM converion_rate_table"];
            for (NSDictionary* dict in tempRates) {
                NSString *sqlStatement = [NSString stringWithFormat:@"insert into converion_rate_table (currency_code,multiplier) values ('%@','%@') ",[dict objectForKey:@"currencyCode"],[dict objectForKey:@"rate"]];
                [database executeUpdate:sqlStatement];
                NSString *query = [NSString stringWithFormat:@"insert into globalRatesTable ('CcyCode','Rate','imageName') values ('%@',%f,'%@')",[dict objectForKey:@"currencyCode"] ,[[dict objectForKey:@"rate"] doubleValue],[dict objectForKey:@"imageName"]];
                [database executeUpdate:query];
            }
        }
        FMResultSet *globalRatesTempArray = [database executeQuery:@"select * from globalRatesTable"];
        while ([globalRatesTempArray next]) {
            GlobalRatesObject *myGlObj = [[GlobalRatesObject alloc] init];
            myGlObj.ccyCode = [globalRatesTempArray stringForColumn:@"CcyCode"];
            myGlObj.rate = [NSNumber numberWithDouble:[globalRatesTempArray doubleForColumn:@"Rate"]];
            myGlObj.imageName = [globalRatesTempArray stringForColumn:@"imageName"];
            myGlObj.cardName = [globalRatesTempArray stringForColumn:@"cardName"];
            [globalRatesFinal addObject:myGlObj];
        }
    }else{
        FMResultSet *globalRatesTempArray = [database executeQuery:@"select * from globalRatesTable"];
        while ([globalRatesTempArray next]) {
            GlobalRatesObject *myGlObj = [[GlobalRatesObject alloc] init];
            myGlObj.ccyCode = [globalRatesTempArray stringForColumn:@"CcyCode"];
            myGlObj.rate = [NSNumber numberWithDouble:[globalRatesTempArray doubleForColumn:@"Rate"]];
            myGlObj.imageName = [globalRatesTempArray stringForColumn:@"imageName"];
            myGlObj.cardName = [globalRatesTempArray stringForColumn:@"cardName"];
            [globalRatesFinal addObject:myGlObj];
        }
    }
    
    [database close];
    return globalRatesFinal;
}

-(NSMutableArray *)loadCardsFromDatabasewithRemote:(BOOL)remote{
    
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray *userCards = [[NSMutableArray alloc] init];
    mutableData = [[NSMutableData alloc] init];
    if (remote) {
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
        NSString *username1 = [keychain objectForKey:(__bridge id)kSecAttrAccount];
        NSString *password1 = [keychain objectForKey:(__bridge id)kSecValueData];
        NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:CheckAuthGetCards><tem:UserName>%@</tem:UserName><tem:Password>%@</tem:Password></tem:CheckAuthGetCards></soapenv:Body></soapenv:Envelope>",username1,password1];
        NSMutableArray *cardsArray= [self callWebServiceWithSoapRequest:soapMessage andMethodName:@"CheckAuthGetCards"];
        for (NSDictionary* cardDic in cardsArray) {
            Card *myCard = [[Card alloc] initWithDicticonary:cardDic];
            [userCards addObject:myCard];
        }
    }else{
        FMResultSet *transArrayNew = [database executeQuery:@"select * from myCards;"];
        while ([transArrayNew next]) {
            Card *myCard = [[Card alloc] init];
            myCard.CardCurrencyDescriptionStr = [transArrayNew stringForColumn:@"CardCurrencyDescription"];
            myCard.CardCurrencyIDStr = [transArrayNew stringForColumn:@"CardCurrencyID"];
            myCard.CardCurrencySymbolStr = [transArrayNew stringForColumn:@"CardCurrencySymbol"];
            myCard.CardNameStr = [transArrayNew stringForColumn:@"CardName"];
            myCard.CardNumberStr = [transArrayNew stringForColumn:@"CardNumber"];
            myCard.CardTypeStr = [transArrayNew stringForColumn:@"CardType"];
            myCard.CurrencyCardIDStr = [transArrayNew stringForColumn:@"CurrencyCardID"];
            myCard.CurrencyCardTypeIDStr = [transArrayNew stringForColumn:@"CurrencyCardTypeID"];
            myCard.ProductTypeIDStr = [transArrayNew stringForColumn:@"ProductTypeID"];
            myCard.cardBalanceStr = [transArrayNew stringForColumn:@"cardBalance"];
            myCard.successImage =[transArrayNew stringForColumn:@"successImageView"];
            myCard.failImage =[transArrayNew stringForColumn:@"errorImageView"];
            [userCards addObject:myCard];
        }
    }
    [database close];
    return userCards;
}
-(NSMutableArray* ) loadTransactionsForUSer:(NSString *)userId withRemote:(BOOL)remote{
    
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray *transArrayFinal = [[NSMutableArray alloc] init];
    //To-Do Local database doesn't store the transaction along with the foreign key cardID
    if (remote) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"khistoryData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
        [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        for (Card *myCard in self.cards) {
            NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                     "<soapenv:Header/>"
                                     "<soapenv:Body>"
                                     "<tem:GetHistory>"
                                     "<tem:userName>%@</tem:userName>"
                                     "<tem:password>%@</tem:password>"
                                     "<tem:currencyCardID>%@</tem:currencyCardID>"
                                     "</tem:GetHistory>"
                                     "</soapenv:Body>"
                                     "</soapenv:Envelope>",[keychain objectForKey:(__bridge id)kSecAttrAccount],[keychain objectForKey:(__bridge id)kSecValueData],myCard.CurrencyCardIDStr];
            
            NSArray *transArray= [self callWebServiceWithSoapRequest:soapMessage andMethodName:@"GetHistory"];
            [database executeUpdate:[NSString stringWithFormat:@"DELETE FROM getHistoryTable where currencyId = '%@'",myCard.CurrencyCardIDStr]];
             for (NSDictionary *trans in transArray) {
                 NSString *value;
                 FMResultSet *valueSet = [database executeQuery:[NSString stringWithFormat:@"select CardCurrencyDescription from myCards where CurrencyCardID = %@",myCard.CurrencyCardIDStr]];
                 if ([valueSet next]) {
                     value = [valueSet stringForColumnIndex:0];
                 }
                 NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO getHistoryTable('amount','date','vendor','currencyId','cardName') values (%f,\"%@\",\"%@\",\"%@\",\"%@\")",[[trans objectForKey:@"amount"] floatValue],[trans objectForKey:@"date"],[trans objectForKey:@"vendor"],myCard.CurrencyCardIDStr,value];
                 [database executeUpdate:queryStr];
             }
        }
        FMResultSet *transArrayNew = [database executeQuery:@"SELECT * FROM getHistoryTable order by date DESC"];
        while ([transArrayNew next]) {
            Transaction *new = [[Transaction alloc] init];
            new.txnAmount = [transArrayNew stringForColumn:@"amount"];
            new.txnDate = [transArrayNew stringForColumn:@"date"];
            new.vendor = [transArrayNew stringForColumn:@"vendor"];
            new.currencyId = [transArrayNew stringForColumn:@"currencyId"];
            new.cardName = [transArrayNew stringForColumn:@"cardName"];
            new.transactionId = [[transArrayNew stringForColumn:@"id"] intValue];
            [transArrayFinal addObject:new];
        }
    }else{
        FMResultSet *transArrayNew = [database executeQuery:@"SELECT * FROM getHistoryTable order by date DESC"];
        while ([transArrayNew next]) {
            Transaction *new = [[Transaction alloc] init];
            new.txnAmount = [transArrayNew stringForColumn:@"amount"];
            new.txnDate = [transArrayNew stringForColumn:@"date"];
            new.vendor = [transArrayNew stringForColumn:@"vendor"];
            new.currencyId = [transArrayNew stringForColumn:@"currencyId"];
            new.cardName = [transArrayNew stringForColumn:@"cardName"];
            new.transactionId = [[transArrayNew stringForColumn:@"id"] intValue];
            [transArrayFinal addObject:new];
        }
    }
    [database close];
    return transArrayFinal;
}
-(NSMutableArray *)callWebServiceWithSoapRequest:(NSString* )soapRequest andMethodName:(NSString* )methodName{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString;
    if (self.devMode) {
        urlString = [NSString stringWithFormat:@"https://mobiledev.caxtonfx.com/Service.svc"];
    }else{
        urlString = [NSString stringWithFormat:@"https://mobileapi.caxtonfx.com/service.svc"];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest;
            theRequest = [NSMutableURLRequest
                      requestWithURL:url
                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapRequest length]];
    [theRequest addValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    if (self.devMode) {
        // TEST
        [theRequest addValue:@"mobiledev.caxtonfx.com" forHTTPHeaderField:@"Host"];
    }else{
        //Live
        [theRequest addValue:@"mobileapi.caxtonfx.com" forHTTPHeaderField:@"Host"];
    }
    [theRequest addValue:@"Apache-HttpClient/4.1.1 (java 1.5)" forHTTPHeaderField:@"User-Agent"];
    [theRequest addValue:[NSString  stringWithFormat:@"http://tempuri.org/IPhoenixTestService/%@",methodName] forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [theRequest setHTTPBody: [soapRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    
    if ([methodName isEqualToString:@"GetHistory"]) {
        transArray = [self requestHistoryServicewithRequest:theRequest];
    }
    if ([methodName isEqualToString:@"CheckAuthGetCards"]) {
        transArray = [self requestCardsServicewithRequest:theRequest];
    }
    if ([methodName isEqualToString:@"GetGlobalRates"]) {
        transArray = [self requestGlobalRatesServicewithRequest:theRequest];
    }
    if ([methodName isEqualToString:@"GetDefaults"]) {
        transArray = [self requestDefaultsServicewithRequest:theRequest];
    }
    return transArray;
}
-(NSMutableArray *) requestDefaultsServicewithRequest:(NSMutableURLRequest*) theRequest{
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSMutableArray *getDefaultDataArr  = [[NSMutableArray alloc] init];
    if (!error){
        if ([responseString rangeOfString:@"<s:Envelope"].location != NSNotFound ) {
            TBXML *tbxml =[TBXML tbxmlWithXMLString:responseString];
            TBXMLElement *root = tbxml.rootXMLElement;
            TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
            TBXMLElement *getPromoResponseEle = [TBXML childElementNamed:@"GetDefaultsResponse" parentElement:rootItemElem];
            TBXMLElement *GetPromoResult = [TBXML childElementNamed:@"GetDefaultsResult" parentElement:getPromoResponseEle];
            TBXMLElement *GetPromoHtmlResult = [TBXML childElementNamed:@"a:products" parentElement:GetPromoResult];
            TBXMLElement *phoenproduct = [TBXML childElementNamed:@"a:PhoenixProduct" parentElement:GetPromoHtmlResult];
            while (phoenproduct != nil)
            {
                TBXMLElement *ccy = [TBXML childElementNamed:@"a:Ccy" parentElement:phoenproduct];
                TBXMLElement *description = [TBXML childElementNamed:@"a:Description" parentElement:phoenproduct];
                TBXMLElement *maxTopUp = [TBXML childElementNamed:@"a:MaxTopUp" parentElement:phoenproduct];
                TBXMLElement *maxTotalBalance = [TBXML childElementNamed:@"a:MaxTotalBalance" parentElement:phoenproduct];
                TBXMLElement *minTopUp = [TBXML childElementNamed:@"a:MinTopUp" parentElement:phoenproduct];
                TBXMLElement *productID = [TBXML childElementNamed:@"a:ProductID" parentElement:phoenproduct];
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                [tempDic setValue:[TBXML textForElement:ccy] forKey:@"ccy"];
                [tempDic setValue:[TBXML textForElement:description] forKey:@"description"];
                [tempDic setValue:[TBXML textForElement:maxTopUp] forKey:@"maxTopUp"];
                [tempDic setValue:[TBXML textForElement:maxTotalBalance] forKey:@"maxTotalBalance"];
                [tempDic setValue:[TBXML textForElement:minTopUp] forKey:@"minTopUp"];
                [tempDic setValue:[TBXML textForElement:productID] forKey:@"productID"];
                phoenproduct = [TBXML nextSiblingNamed:@"a:PhoenixProduct" searchFromElement:phoenproduct];
                [getDefaultDataArr addObject:tempDic];
            }
        }
    }
    return getDefaultDataArr;
}
-(NSMutableArray *) requestGlobalRatesServicewithRequest:(NSMutableURLRequest*) theRequest{
    NSMutableArray *glRatesArray = [[NSMutableArray alloc] init];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (!error) {
        if ([responseString rangeOfString:@"<s:Envelope"].location != NSNotFound ) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyflags_map" ofType:@"csv"];
            NSString *myText = nil;
            if (filePath) {
                myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
            }
            NSArray *contentArray = [myText componentsSeparatedByString:@"\r"]; // CSV ends with ACSI 13 CR
            NSMutableArray *codesMA = [NSMutableArray new];
            for (NSString *item in contentArray)
            {
                NSArray *itemArray = [item componentsSeparatedByString:@","];
                if ([itemArray count] > 3)
                {
                    [codesMA addObject:[itemArray objectAtIndex:3]];
                }
            }
            NSMutableArray *glabalRatesMA  = [[NSMutableArray alloc] init];
            TBXML *tbxml =[TBXML tbxmlWithXMLString:responseString];
            TBXMLElement *root = tbxml.rootXMLElement;
            TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
            if(rootItemElem)
            {
                TBXMLElement *subcategoryEle = [TBXML childElementNamed:@"GetGlobalRatesResponse" parentElement:rootItemElem];
                TBXMLElement * GetGlobalRatesResult = [TBXML childElementNamed:@"GetGlobalRatesResult" parentElement:subcategoryEle];
                TBXMLElement *expiryTime = [TBXML childElementNamed:@"a:expiryTime" parentElement:GetGlobalRatesResult];
                NSString *expiryTimeStr = [TBXML textForElement:expiryTime];
                [[NSUserDefaults standardUserDefaults]setObject:expiryTimeStr forKey:@"expiryTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                TBXMLElement *rates = [TBXML childElementNamed:@"a:rates" parentElement:GetGlobalRatesResult];
                if (rates)
                {
                    TBXMLElement *CFXExchangeRate = [TBXML childElementNamed:@"a:CFXExchangeRate" parentElement:rates];
                    while (CFXExchangeRate != nil) {
                        TBXMLElement *currencyCode = [TBXML childElementNamed:@"a:CcyCode" parentElement:CFXExchangeRate];
                        TBXMLElement *rate = [TBXML childElementNamed:@"a:Rate" parentElement:CFXExchangeRate];
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        [dict setObject:[TBXML textForElement:currencyCode] forKey:@"currencyCode"];
                        [dict setObject:[TBXML textForElement:rate] forKey:@"rate"];
                        int index = -1;
                        NSString *imageName = @"";
                        if ([codesMA containsObject:[dict objectForKey:@"currencyCode"]])
                        {
                            index=  [codesMA indexOfObject:[dict objectForKey:@"currencyCode"]];
                        }
                        if(index >=0)
                        {
                            NSString *item = [contentArray objectAtIndex:index];
                            NSArray *itemArray = [item componentsSeparatedByString:@","];
                            if (itemArray.count != 0) {
                                imageName =[[[itemArray objectAtIndex:1] lowercaseString] stringByAppendingFormat:@" - %@",[[itemArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
                            }
                        }
                        [dict setObject:imageName forKey:@"imageName"];
                        if (dict)
                        {
                            [glabalRatesMA addObject:dict];
                            [glRatesArray addObject:dict];
                        }
                        CFXExchangeRate = [TBXML nextSiblingNamed:@"a:CFXExchangeRate" searchFromElement:CFXExchangeRate];
                    }
                }
            }

        }
    }
    NSDate *today = [NSDate date];
    dateInString = [today description];
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDateRates"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return glRatesArray;
}
-(NSMutableArray *) requestCardsServicewithRequest:(NSMutableURLRequest*) theRequest{
    
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray *cardsArray = [[NSMutableArray alloc] init];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (!error) {
        if ([responseString rangeOfString:@"<s:Envelope"].location != NSNotFound ) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            TBXML *tbxml =[TBXML tbxmlWithXMLString:responseString];
            TBXMLElement *root = tbxml.rootXMLElement;
            TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
            TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"CheckAuthGetCardsResponse" parentElement:rootItemElem];
            TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"CheckAuthGetCardsResult" parentElement:checkAuthGetCardsResponseElem];
            TBXMLElement *status = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
            NSString *statusCodeStr = [TBXML textForElement:status];
            self.statusCode = statusCodeStr;
            if([statusCodeStr intValue]== 000 || [statusCodeStr intValue]== 003)
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
                            [cardsArray addObject:dict];
                            CardElm = [TBXML nextSiblingNamed:@"a:card" searchFromElement:CardElm];
                        }
                    }
                    [database executeUpdate:@"DELETE FROM myCards"];
                    for(int i=0;i<array.count;i++)
                    {
                        NSMutableDictionary *dict = [array objectAtIndex:i];
                        NSString *queryStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO myCards values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[dict objectForKey:@"CurrencyCardIDStr"],[dict objectForKey:@"CurrencyCardTypeIDStr"],[dict objectForKey:@"ProductTypeIDStr"],[dict objectForKey:@"CardCurrencyIDStr"],[dict objectForKey:@"cardBalanceStr"],[dict objectForKey:@"CardCurrencyDescriptionStr"],[dict objectForKey:@"CardCurrencySymbolStr"],[dict objectForKey:@"CardNameStr"],[dict objectForKey:@"CardNumberStr"],[dict objectForKey:@"CardTypeStr"],@"NO",@"NO"];
                        [database executeUpdate:queryStr];
                    }
                    
                }
                NSDate *today = [NSDate date];
                dateInString = [today description];
                [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"updateDate"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
    }
   [database close];
    return cardsArray;
}
-(NSMutableArray *) requestHistoryServicewithRequest:(NSMutableURLRequest*) theRequest{
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([responseString rangeOfString:@"<s:Envelope"].location != NSNotFound ) {
        if (!error) {
            TBXML *tbxml =[TBXML tbxmlWithXMLString:responseString];
            TBXMLElement *root = tbxml.rootXMLElement;
            TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
            TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"GetHistoryResponse" parentElement:rootItemElem];
            TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"GetHistoryResult" parentElement:checkAuthGetCardsResponseElem];
            TBXMLElement *responceStatusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
            
            NSString *statusIs = [TBXML textForElement:responceStatusCode];
            self.statusCode = statusIs;
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
                        [transArray addObject:dict];
                        CardElm = [TBXML nextSiblingNamed:@"a:CardHistory" searchFromElement:CardElm];
                    }
                }
            }
        }
    }
    return transArray;
}

-(void)saveUser{
    //TO-DO: INSERT OR UPDATE THE USER OF THIS INSTANCE
    
}
-(void)deletUser{
    
}
@end
