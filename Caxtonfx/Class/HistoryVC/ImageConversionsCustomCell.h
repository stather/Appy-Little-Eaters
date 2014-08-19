//
//  ImageConversionsCustomCell.h
//  Caxtonfx
//
//  Created by Nishant on 22/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageConversionsCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *globalRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *convertedCurrencyLabel;

@end
