//
//  TransactionCustomCell.h
//  Caxtonfx
//
//  Created by Nishant on 22/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCustomCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCountryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardUsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyValueLabel;
@end
