//
//  SetPinTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 18/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPinTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbl;

@property (nonatomic, weak) IBOutlet UIImageView *imgView;

@property (nonatomic, weak) IBOutlet UIView *view;

+ (NSString *)reuseIdentifier;

@end
