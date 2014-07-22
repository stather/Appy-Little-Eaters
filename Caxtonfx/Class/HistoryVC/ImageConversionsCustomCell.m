//
//  ImageConversionsCustomCell.m
//  Caxtonfx
//
//  Created by Nishant on 22/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "ImageConversionsCustomCell.h"

@implementation ImageConversionsCustomCell
@synthesize currencyCodeLabel,globalRateLabel,dateLabel;

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

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.currencyCodeLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [self.globalRateLabel setTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    [self.dateLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [self.convertedCurrencyLabel setTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];

    [self.currencyCodeLabel setFont:[UIFont fontWithName:@"OpenSans" size:20.0f]];
    [self.globalRateLabel setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
    [self.convertedCurrencyLabel setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
    [self.dateLabel setFont:[UIFont fontWithName:@"OpenSans" size:13.0f]];
}

-(void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        for (UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
            {
                UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 35)];
                [deleteBtn setImage:[UIImage imageNamed:@"whiteDeleteBtn.png"]];
                [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
            }
        }
    }
}


@end
