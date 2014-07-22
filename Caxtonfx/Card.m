//
//  Cards.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 31/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "Card.h"
#import "User.h"
@implementation Card

@synthesize CardCurrencyDescriptionStr;
@synthesize CardCurrencyIDStr ;
@synthesize CardCurrencySymbolStr;
@synthesize CardNameStr;
@synthesize CardNumberStr;
@synthesize CardTypeStr;
@synthesize CurrencyCardIDStr;
@synthesize CurrencyCardTypeIDStr;
@synthesize ProductTypeIDStr;
@synthesize cardBalanceStr;
@synthesize successImage;
@synthesize failImage;

-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.CardCurrencyDescriptionStr = @"";
        self.CardCurrencyIDStr = @"";
        self.CardCurrencySymbolStr = @"";
        self.CardNameStr = @"";
        self.CardNumberStr = @"";
        self.CardTypeStr = @"";
        self.CurrencyCardIDStr = @"";
        self.CurrencyCardTypeIDStr = @"";
        self.ProductTypeIDStr = @"";
        self.cardBalanceStr = @"";
        self.successImage =@"NO";
        self.failImage =@"NO";
    }
    return self;
}
-(id) initWithDicticonary:(NSDictionary *)cardValues{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        if ([cardValues valueForKey:@"CardCurrencyDescription"] == nil) {
            self.CardCurrencyDescriptionStr = [cardValues valueForKey:@"CardCurrencyDescriptionStr"];
            self.CardCurrencyIDStr = [cardValues valueForKey:@"CardCurrencyIDStr"];
            self.CardCurrencySymbolStr = [cardValues valueForKey:@"CardCurrencySymbolStr"];
            self.CardNameStr = [cardValues valueForKey:@"CardNameStr"];
            self.CardNumberStr = [cardValues valueForKey:@"CardNumberStr"];
            self.CardTypeStr = [cardValues valueForKey:@"CardTypeStr"];
            self.CurrencyCardIDStr = [cardValues valueForKey:@"CurrencyCardIDStr"];
            self.CurrencyCardTypeIDStr = [cardValues valueForKey:@"CurrencyCardTypeIDStr"];
            self.ProductTypeIDStr = [cardValues valueForKey:@"ProductTypeIDStr"];
            self.cardBalanceStr = [cardValues valueForKey:@"cardBalanceStr"];
            self.successImage =@"NO";
            self.failImage =@"NO";
        }else{
            self.CardCurrencyDescriptionStr = [cardValues valueForKey:@"CardCurrencyDescription"];
            self.CardCurrencyIDStr = [cardValues valueForKey:@"CardCurrencyID"];
            self.CardCurrencySymbolStr = [cardValues valueForKey:@"CardCurrencySymbol"];
            self.CardNameStr = [cardValues valueForKey:@"CardName"];
            self.CardNumberStr = [cardValues valueForKey:@"CardNumber"];
            self.CardTypeStr = [cardValues valueForKey:@"CardType"];
            self.CurrencyCardIDStr = [cardValues valueForKey:@"CurrencyCardID"];
            self.CurrencyCardTypeIDStr = [cardValues valueForKey:@"CurrencyCardTypeID"];
            self.ProductTypeIDStr = [cardValues valueForKey:@"ProductTypeID"];
            self.cardBalanceStr = [cardValues valueForKey:@"CardBalance"];
            self.successImage =[cardValues valueForKey:@"successImageView"];
            self.failImage =[cardValues valueForKey:@"errorImageView"];
        }
    }
    return self;
}
-(void)saveCard{
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSString *queryStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO myCards VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",self.CurrencyCardIDStr,self.CurrencyCardTypeIDStr,self.ProductTypeIDStr,self.CardCurrencyIDStr,self.cardBalanceStr,self.CardCurrencyDescriptionStr,self.CardCurrencySymbolStr,self.CardNameStr,self.CardNumberStr,self.CardTypeStr,@"NO",@"NO"];
    [database executeUpdate:queryStr];
    [database close];
}
-(void)deleteCard{
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM myCards WHERE CurrencyCardID = \"%@\" ",self.CurrencyCardIDStr];
    [database executeUpdate:queryStr];
    [database close];
}
-(void)deleteAllCards{
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM myCards"];
    [database executeUpdate:queryStr];
    [database close];
}


@end
