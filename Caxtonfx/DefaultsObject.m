//
//  DefaultsObject.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 12/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "DefaultsObject.h"

@implementation DefaultsObject
@synthesize ccy;
@synthesize description;
@synthesize maxTopUp;
@synthesize maxTotalBalance;
@synthesize minTopUp;
@synthesize productId;

-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.ccy = @"";
        self.description = @"";
        self.maxTopUp = @"";
        self.maxTotalBalance= @"";
        self.minTopUp= @"";
        self.productId= @"";
    }
    return self;
}
@end
