//
//  Transaction.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 31/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction
@synthesize txnAmount;
@synthesize txnDate;
@synthesize vendor;
@synthesize cardName;
@synthesize currencyId;
@synthesize transactionId;

-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.txnAmount = @"";
        self.txnDate = @"";
        self.vendor = @"";
        self.cardName= @"";
        self.currencyId= @"";
        }
    return self;
}
-(void)saveTransaction{
    //TO-DO: INSERT OR UPDATE THE TRANSACTION OF THIS INSTANCE
    NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO getHistoryTable('amount','date','vendor','currencyId','cardName') values (%f,\"%@\",\"%@\",\"%@\",\"%@\")",[self.txnAmount floatValue],self.txnDate,self.vendor,self.currencyId,self.cardName];
    
    [[DatabaseHandler getSharedInstance] executeQuery:queryStr];

}
-(void)deleteTransaction{
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM getHistoryTable WHERE id = %i ",self.transactionId];
    [[DatabaseHandler getSharedInstance] executeQuery:queryStr];
}
-(void)deleteAllTransasctions{
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM getHistoryTable "];
    [[DatabaseHandler getSharedInstance] executeQuery:queryStr];
}


@end
