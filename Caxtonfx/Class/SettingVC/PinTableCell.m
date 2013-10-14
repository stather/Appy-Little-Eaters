//
//  PinTableCell.m
//  Caxtonfx
//
//  Created by Sumit on 18/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "PinTableCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation PinTableCell
@synthesize textLbl,detailLbl,customeSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    [customeSwitch setBackgroundImage:[UIImage imageNamed:@"Switch_Background"]];
    [customeSwitch setKnobImage:[UIImage imageNamed:@"Switch_Knob"]];
    [customeSwitch setOverlayImage:nil];
    [customeSwitch setHighlightedKnobImage:nil];
    [customeSwitch setCornerRadius:0];
    [customeSwitch setKnobOffset:CGSizeMake(0, 0)];
    [customeSwitch setTextShadowOffset:CGSizeMake(0, 0)];
    [customeSwitch setFont:[UIFont boldSystemFontOfSize:14]];
    [customeSwitch setTextOffset:CGSizeMake(0, 2) forLabel:RESwitchLabelOn];
    [customeSwitch setTextOffset:CGSizeMake(3, 2) forLabel:RESwitchLabelOff];
    [customeSwitch setTextColor:[UIColor blackColor] forLabel:RESwitchLabelOn];
    [customeSwitch setTextColor:[UIColor colorWithRed:143/255.0 green:19/255.0 blue:24/255.0 alpha:1] forLabel:RESwitchLabelOff];
    
    customeSwitch.layer.cornerRadius = 4;
    customeSwitch.layer.borderColor = [UIColor colorWithRed:224/255.0 green:36/255.0 blue:24/255.0 alpha:1].CGColor;
    customeSwitch.layer.borderWidth = 2;
    customeSwitch.layer.masksToBounds = YES;
    [customeSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
   
    customeSwitch.on = NO;

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)stateChanged:(id)sender
{
    NSLog(@"%d",customeSwitch.state);

}

+ (NSString *)reuseIdentifier {
    return @"CustomCellIdentifier1";
}

@end
