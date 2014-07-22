//
//  DefaultsObject.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 12/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsObject : NSObject{
    NSString *ccy;
    NSString *description;
    NSString *maxTopUp;
    NSString *maxTotalBalance;
    NSString *minTopUp;
    NSString *productId;
}
@property (nonatomic,strong) NSString *ccy;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *maxTopUp;
@property (nonatomic,strong) NSString *maxTotalBalance;
@property (nonatomic,strong) NSString *minTopUp;
@property (nonatomic,strong) NSString *productId;

@end
