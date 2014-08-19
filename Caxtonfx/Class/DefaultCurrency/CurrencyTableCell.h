//
//  baseCurrencyTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 06/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyTableCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;
@property (nonatomic, weak) IBOutlet UILabel *textLbl;
@property (nonatomic, weak) IBOutlet UIImageView *radio;
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (nonatomic, weak) IBOutlet UIImageView *flagBGImageView;

@end
