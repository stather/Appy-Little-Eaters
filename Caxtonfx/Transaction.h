//
//  Transaction.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 31/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject{
    NSString *txnAmount;
    NSString *txnDate;
    NSString *vendor;
    NSString *cardName;
    NSString *currencyId;
    int transactionId;
}
@property (nonatomic,strong) NSString *txnAmount;
@property (nonatomic,strong) NSString *txnDate;
@property (nonatomic,strong) NSString *vendor;
@property (nonatomic,strong) NSString *cardName;
@property (nonatomic,strong) NSString *currencyId;
@property int transactionId;

-(void)saveTransaction;
-(void)deleteTransaction;
-(void)deleteAllTransasctions;

@end
