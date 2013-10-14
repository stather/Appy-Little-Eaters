//
//  baseCurrencyTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 06/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyTableCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UIImageView *flagImageView;
@property (nonatomic, strong) IBOutlet UILabel *textLbl;
@property (nonatomic, strong) IBOutlet UIImageView *radio;
@property (nonatomic, strong) IBOutlet UIView *lineView;
@property (nonatomic ,strong) IBOutlet UIImageView *flagBGImageView;

@end
