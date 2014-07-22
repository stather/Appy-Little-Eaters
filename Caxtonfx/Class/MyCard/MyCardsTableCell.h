//
//  MyCardsTableCell.h
//  Caxtonfx
//
//  Created by Sumit on 17/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardsTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *errorImgView;

@property (nonatomic, strong) IBOutlet UIImageView *succesImgView;

@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;

@property (nonatomic, strong) IBOutlet UIImageView *flagImgView;

@property (nonatomic, strong) IBOutlet UILabel *accountTypeLable;

@property (nonatomic, strong) IBOutlet UILabel *accountNameLable;

@property (nonatomic, strong) IBOutlet UILabel *currentBlnceLable;

@property (nonatomic, strong) IBOutlet UILabel *blnceLable;

@property (nonatomic, strong) IBOutlet UIButton *topupBtn;

-(IBAction)topupBtnPressed:(id)sender;

@end
