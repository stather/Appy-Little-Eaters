//
//  SetPinTableCell.m
//  Caxtonfx
//
//  Created by Sumit on 18/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "SetPinTableCell.h"

@implementation SetPinTableCell

@synthesize lbl,imgView,view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"CustomCellIdentifier3";
}

@end
