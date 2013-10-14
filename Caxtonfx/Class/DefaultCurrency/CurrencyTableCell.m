//
//  baseCurrencyTableCell.m
//  Caxtonfx
//
//  Created by Sumit on 06/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "CurrencyTableCell.h"


@implementation CurrencyTableCell

@synthesize flagBGImageView,flagImageView,textLbl,radio,lineView;

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

@end
