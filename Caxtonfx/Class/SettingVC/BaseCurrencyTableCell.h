//
//  BaseCurrencyTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 18/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCurrencyTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbl;

@property (nonatomic, weak) IBOutlet UIImageView *arrowImgView;

@property (nonatomic, weak) IBOutlet UILabel *currencyLbl;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIImageView *flagImgView;


@property (nonatomic, strong) IBOutlet UIView *view;


+ (NSString *)reuseIdentifier;

@end
