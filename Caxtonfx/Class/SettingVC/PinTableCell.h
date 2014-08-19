//
//  PinTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 18/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESwitch.h"

@interface PinTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *textLbl;

@property (nonatomic, weak) IBOutlet UILabel *detailLbl;

//@property (nonatomic, strong) IBOutlet UISwitch *pinSwitch;

@property (nonatomic, weak) IBOutlet RESwitch *customeSwitch;


-(IBAction)stateChanged:(id)sender;

+ (NSString *)reuseIdentifier;

@end
