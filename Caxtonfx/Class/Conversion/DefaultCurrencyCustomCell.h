//
//  DefaultCurrencyCustomCell.h
//  Caxtonfx
//
//  Created by Nishant on 26/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultCurrencyCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagIcon;
@property (weak, nonatomic) IBOutlet UILabel *currencyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedStateBtn;
@end
