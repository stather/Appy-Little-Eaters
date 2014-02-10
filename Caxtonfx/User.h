//
//  User.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 30/01/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString *dateOfBirth;
    NSMutableArray *cards;
    NSString *contactType;
    NSString *mobileNumber;
    NSString *statusCode;
    NSString *username;
    NSString *password;
    NSMutableArray* transactions;
    
}

@property(nonatomic,strong) NSString *dateOfBirth;
@property(nonatomic,strong) NSMutableArray *cards;
@property(nonatomic,strong) NSString *contactType;
@property(nonatomic,strong) NSString *mobileNumber;
@property(nonatomic,strong) NSString *statusCode;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSMutableArray* transactions;

-(id)init;
-(id) initWithUserid:(NSString *)userId andDateOfBirth:(NSString *)userDob andContactType:(NSString *)contactType andMobileNumber:(NSString *)mobileNumber andStatusCode:(NSString *)statusCode andPassword:(NSString *)password andCards:(NSArray *)cardsArray;
+ (id)sharedInstance;
+(NSMutableArray *)loadCardsFromDatabase;
-(NSMutableArray* ) loadTransactionsForUSer:(NSString *)userId withRemote:(BOOL)remote;
-(void)saveUser;
-(void)deletUser;
@end
