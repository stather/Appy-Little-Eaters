//
//  Cards.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 31/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 CardCurrencyDescriptionStr = Euro;
 CardCurrencyIDStr = 4;
 CardCurrencySymbolStr = EUR;
 CardNameStr = "C Estera";
 CardNumberStr = 7526;
 CardTypeStr = 0;
 CurrencyCardIDStr = 358649;
 CurrencyCardTypeIDStr = 1;
 ProductTypeIDStr = 201;
 cardBalanceStr = "4006.56";
 */

@interface Card : NSObject{
    NSString* CardCurrencyDescriptionStr;
    NSString* CardCurrencyIDStr ;
    NSString* CardCurrencySymbolStr;
    NSString* CardNameStr;
    NSString* CardNumberStr;
    NSString* CardTypeStr;
    NSString* CurrencyCardIDStr;
    NSString* CurrencyCardTypeIDStr;
    NSString* ProductTypeIDStr;
    NSString* cardBalanceStr;
    NSString *successImage;
    NSString *failImage;
}
@property (nonatomic,strong) NSString* CardCurrencyDescriptionStr;
@property (nonatomic,strong) NSString* CardCurrencyIDStr ;
@property (nonatomic,strong) NSString* CardCurrencySymbolStr;
@property (nonatomic,strong) NSString* CardNameStr;
@property (nonatomic,strong) NSString* CardNumberStr;
@property (nonatomic,strong) NSString* CardTypeStr;
@property (nonatomic,strong) NSString* CurrencyCardIDStr;
@property (nonatomic,strong) NSString* CurrencyCardTypeIDStr;
@property (nonatomic,strong) NSString* ProductTypeIDStr;
@property (nonatomic,strong) NSString* cardBalanceStr;
@property (nonatomic,strong) NSString* successImage;
@property (nonatomic,strong) NSString* failImage;

-(id) init;
-(id) initWithDicticonary:(NSDictionary *)cardValues;

-(void)saveCard;
-(void)deleteCard;
-(void)deleteAllCards;

@end
