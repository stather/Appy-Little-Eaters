//
//  BaseCurrencyTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 18/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCurrencyTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbl;

@property (nonatomic, strong) IBOutlet UIImageView *arrowImgView;

@property (nonatomic, strong) IBOutlet UILabel *currencyLbl;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UIImageView *flagImgView;


@property (nonatomic, strong) IBOutlet UIView *view;


+ (NSString *)reuseIdentifier;

@end
