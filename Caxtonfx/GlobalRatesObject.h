//
//  GlobalRatesObject.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 12/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalRatesObject : NSObject{
    NSString *ccyCode;
    NSNumber *rate;
    NSString *imageName;
    NSString *cardName;
}
@property (nonatomic,strong) NSString *ccyCode;
@property (nonatomic,strong) NSNumber *rate;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *cardName;

-(id) initWithCcyCode: (NSString *)ccyCode;
@end
