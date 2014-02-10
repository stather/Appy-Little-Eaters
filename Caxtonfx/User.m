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

@implementation User
@synthesize dateOfBirth;
@synthesize cards;
@synthesize contactType;
@synthesize mobileNumber;
@synthesize statusCode;
@synthesize username;
@synthesize password;
@synthesize transactions;
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
        self.transactions =[NSMutableArray array];
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
+(NSMutableArray *)loadCardsFromDatabase{
    NSArray *cardsArray= [[DatabaseHandler getSharedInstance] getData:@"select * from myCards;"];
    NSMutableArray *userCards = [[NSMutableArray alloc] init];
    for (NSDictionary* cardDic in cardsArray) {
        Card *myCard = [[Card alloc] initWithDicticonary:cardDic];
        [userCards addObject:myCard];
    }
    return userCards;
}
-(NSMutableArray* ) loadTransactionsForUSer:(NSString *)userId withRemote:(BOOL)remote{
    NSMutableArray *transArrayFinal = [[NSMutableArray alloc] init];
    //To-Do Local database doesn't store the transaction along with the foreign key cardID
    if (remote) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"khistoryData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
        [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        
        for (Card *myCard in cards) {
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
            for (NSDictionary *trans in transArray) {
                Transaction *new = [[Transaction alloc] init];
                new.txnAmount = [trans valueForKey:@"amount"];
                new.txnDate = [trans valueForKey:@"date"];
                new.vendor = [trans valueForKey:@"vendor"];
                new.currencyId = myCard.CurrencyCardIDStr;
                new.cardName = myCard.CardNameStr;
                new.transactionId = Nil;
                [transArrayFinal addObject:new];
            }
        }
    }else{
        NSArray *transArray= [[DatabaseHandler getSharedInstance] getData:@"SELECT * FROM getHistoryTable order by date DESC"];
        for (NSDictionary *trans in transArray) {
            Transaction *new = [[Transaction alloc] init];
            new.txnAmount = [trans valueForKey:@"amount"];
            new.txnDate = [trans valueForKey:@"date"];
            new.vendor = [trans valueForKey:@"vendor"];
            new.currencyId = [trans valueForKey:@"currencyId"];
            new.cardName = [trans valueForKey:@"cardName"];
            new.transactionId = [[trans valueForKey:@"id"] intValue];
            [transArrayFinal addObject:new];
        }
    }
    return transArrayFinal;
}
-(void)saveUser{
    //TO-DO: INSERT OR UPDATE THE USER OF THIS INSTANCE
    
}
-(void)deletUser{
    
}
-(NSMutableArray *)callWebServiceWithSoapRequest:(NSString* )soapRequest andMethodName:(NSString* )methodName{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // test url
    NSString *urlString = [NSString stringWithFormat:@"https://mobiledev.caxtonfx.com/Service.svc"];
    // live Url
    //   NSString *urlString = [NSString stringWithFormat:@"https://mobileapi.caxtonfx.com/service.svc"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest;
            theRequest = [NSMutableURLRequest
                      requestWithURL:url
                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapRequest length]];
    [theRequest addValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    // TEST
    [theRequest addValue:@"mobiledev.caxtonfx.com" forHTTPHeaderField:@"Host"];
    
    //Live
    //  [theRequest addValue:@"mobileapi.caxtonfx.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue:@"Apache-HttpClient/4.1.1 (java 1.5)" forHTTPHeaderField:@"User-Agent"];
    [theRequest addValue:[NSString  stringWithFormat:@"http://tempuri.org/IPhoenixTestService/%@",methodName] forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [theRequest setHTTPBody: [soapRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    TBXML *tbxml =[TBXML tbxmlWithXMLString:responseString];
    TBXMLElement *root = tbxml.rootXMLElement;
    TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
    TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"GetHistoryResponse" parentElement:rootItemElem];
    TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"GetHistoryResult" parentElement:checkAuthGetCardsResponseElem];
    TBXMLElement *responceStatusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
    
    NSString *statusIs = [TBXML textForElement:responceStatusCode];
    
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    
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
        /*
        [[DatabaseHandler getSharedInstance] executeQuery:[NSString stringWithFormat:@"DELETE FROM getHistoryTable where currencyId = '%@'",currentId]];
        for(int i=0;i<transArray.count;i++)
        {
            NSMutableDictionary *dict = [self._array objectAtIndex:i];
            NSString *value = [[DatabaseHandler getSharedInstance] getDataValue:[NSString stringWithFormat:@"select CardCurrencyDescription from myCards where CurrencyCardID = %@",currentId]];
            NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO getHistoryTable('amount','date','vendor','currencyId','cardName') values (%f,\"%@\",\"%@\",\"%@\",\"%@\")",[[dict objectForKey:@"amount"] floatValue],[dict objectForKey:@"date"],[dict objectForKey:@"vendor"],currentId,value];
            
            [[DatabaseHandler getSharedInstance]executeQuery:queryStr];
        }
        */
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Session Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
    return transArray;
}
@end
