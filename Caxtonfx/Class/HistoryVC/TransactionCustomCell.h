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
@property (strong, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeCountryDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardUsedLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyValueLabel;
@end
