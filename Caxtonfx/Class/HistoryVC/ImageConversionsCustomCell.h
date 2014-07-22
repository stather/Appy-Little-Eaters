//
//  ImageConversionsCustomCell.h
//  Caxtonfx
//
//  Created by Nishant on 22/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageConversionsCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UILabel *currencyCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *globalRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *convertedCurrencyLabel;

@end
