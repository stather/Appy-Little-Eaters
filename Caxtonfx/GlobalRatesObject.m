//
//  GlobalRatesObject.m
//  Caxtonfx
//
//  Created by George Bafaloukas on 12/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "GlobalRatesObject.h"

@implementation GlobalRatesObject
@synthesize ccyCode;
@synthesize rate;
@synthesize imageName;
@synthesize cardName;

-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.ccyCode = @"";
        self.rate = [NSNumber numberWithInt:1];
        self.imageName = @"";
        self.cardName = @"";
        }
    return self;
}

-(id) initWithCcyCode: (NSString *)ccyCode{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        self.ccyCode = @"";
        self.rate = [NSNumber numberWithInt:1];
        self.imageName = @"";
        self.cardName = @"";
    }
    return self;
}
@end
