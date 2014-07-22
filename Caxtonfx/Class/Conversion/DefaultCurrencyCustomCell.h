//
//  DefaultCurrencyCustomCell.h
//  Caxtonfx
//
//  Created by Nishant on 26/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultCurrencyCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *flagIcon;
@property (strong, nonatomic) IBOutlet UILabel *currencyTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectedStateBtn;
@end
