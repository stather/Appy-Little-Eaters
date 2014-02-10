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
    return self;
}
-(void)saveCard{
    //TO-DO: INSERT OR UPDATE THE CARD OF THIS INSTANCE
    /*
     CurrencyCardID
     CurrencyCardTypeID
     ProductTypeID
     CardCurrencyID
     CardBalance
     CardCurrencyDescription
     CardCurrencySymbol
     CardName
     CardNumber
     CardType
     errorImageView
     successImageView
     */
    NSString *queryStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO myCards (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",self.CurrencyCardIDStr,self.CurrencyCardTypeIDStr,self.ProductTypeIDStr,self.CardCurrencyIDStr,self.cardBalanceStr,self.CardCurrencyDescriptionStr,self.CardCurrencySymbolStr,self.CardNameStr,self.CardNumberStr,self.CardTypeStr,@"NO",@"NO"];
    [[DatabaseHandler getSharedInstance] executeQuery:queryStr];
}
-(void)deleteCard{
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM myCards WHERE CurrencyCardID = \"%@\" ",self.CurrencyCardIDStr];
    [[DatabaseHandler getSharedInstance] executeQuery:queryStr];
}
-(void)deleteAllCards{
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM myCards"];
    [[DatabaseHandler getSharedInstance] executeQuery:queryStr];
}


@end
