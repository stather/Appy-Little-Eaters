//
//  CustomAlertView.m
//  Caxtonfx
//
//  Created by Catalin Demian on 07/08/14.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if (self) {
        // 
    }
    return self;
}


@end
