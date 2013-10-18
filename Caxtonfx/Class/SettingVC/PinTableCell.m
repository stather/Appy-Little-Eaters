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
    [self.customeSwitch setBackgroundImage:[UIImage imageNamed:@"Switch_Background"]];
    [self.customeSwitch setKnobImage:[UIImage imageNamed:@"Switch_Knob"]];
    [self.customeSwitch setOverlayImage:nil];
    [self.customeSwitch setHighlightedKnobImage:nil];
    [self.customeSwitch setCornerRadius:0];
    [self.customeSwitch setKnobOffset:CGSizeMake(0, 0)];
    [self.customeSwitch setTextShadowOffset:CGSizeMake(0, 0)];
    [self.customeSwitch setFont:[UIFont boldSystemFontOfSize:14]];
    [self.customeSwitch setTextOffset:CGSizeMake(0, 2) forLabel:RESwitchLabelOn];
    [self.customeSwitch setTextOffset:CGSizeMake(3, 2) forLabel:RESwitchLabelOff];
    [self.customeSwitch setTextColor:[UIColor blackColor] forLabel:RESwitchLabelOn];
    [self.customeSwitch setTextColor:[UIColor colorWithRed:143/255.0 green:19/255.0 blue:24/255.0 alpha:1] forLabel:RESwitchLabelOff];
    
    self.customeSwitch.layer.cornerRadius = 4;
    self.customeSwitch.layer.borderColor = [UIColor colorWithRed:224/255.0 green:36/255.0 blue:24/255.0 alpha:1].CGColor;
    self.customeSwitch.layer.borderWidth = 2;
    self.customeSwitch.layer.masksToBounds = YES;
    [self.customeSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
   
    self.customeSwitch.on = NO;

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
