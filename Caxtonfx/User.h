//
//  User.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 30/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalRatesObject.h"

@interface User : NSObject{
    NSString *dateOfBirth;
    NSMutableArray *cards;
    NSString *contactType;
    NSString *mobileNumber;
    NSString *statusCode;
    NSString *username;
    NSString *password;
    NSMutableArray* transactions;
    NSMutableArray *globalRates;
    NSMutableArray *defaultsArray;
    BOOL devMode;
}

@property (nonatomic,strong) NSString *dateOfBirth;
@property (nonatomic,strong) NSMutableArray *cards;
@property (nonatomic,strong) NSString *contactType;
@property (nonatomic,strong) NSString *mobileNumber;
@property (nonatomic,strong) NSString *statusCode;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSMutableArray* transactions;
@property (nonatomic,strong) NSMutableArray *globalRates;
@property (nonatomic,strong) NSMutableArray *defaultsArray;
@property BOOL devMode;
@property (nonatomic , strong) NSMutableData *mutableData;
//@property (nonatomic , strong) NSString *serviceName;


-(id)init;
-(id) initWithUserid:(NSString *)userId andDateOfBirth:(NSString *)userDob andContactType:(NSString *)contactType andMobileNumber:(NSString *)mobileNumber andStatusCode:(NSString *)statusCode andPassword:(NSString *)password andCards:(NSArray *)cardsArray;
+ (id)sharedInstance;
-(NSMutableArray *)loadCardsFromDatabasewithRemote:(BOOL)remote;
-(NSMutableArray* ) loadTransactionsForUSer:(NSString *)userId withRemote:(BOOL)remote;
- (NSMutableArray *)loadGlobalRatesWithRemote:(BOOL)remote;
-(GlobalRatesObject *)loadGlobalRateForCcyCode:(NSString *)ccyCode;
- (NSMutableArray *)loadDefaultsWithRemote:(BOOL)remote;

//Not yet implemented
-(void)saveUser;
-(void)deletUser;
@end
