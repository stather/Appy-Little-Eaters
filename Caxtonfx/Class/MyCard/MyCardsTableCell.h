//
//  MyCardsTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 17/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardsTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *errorImgView;
@property (nonatomic, weak) IBOutlet UIImageView *succesImgView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImgView;
@property (nonatomic, weak) IBOutlet UIImageView *flagImgView;
@property (nonatomic, weak) IBOutlet UILabel *accountTypeLable;
@property (nonatomic, weak) IBOutlet UILabel *accountNameLable;
@property (nonatomic, weak) IBOutlet UILabel *currentBlnceLable;
@property (nonatomic, weak) IBOutlet UILabel *blnceLable;
@property (nonatomic, weak) IBOutlet UIButton *topupBtn;

-(IBAction)topupBtnPressed:(id)sender;

@end
