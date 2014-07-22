//
//  LogoutTableCell.h
//  demoCfx
//
//  Created by Sumit on 17/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@interface LogoutTableCell : UITableViewCell <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lbl;

@property (nonatomic, strong) IBOutlet UIButton *btn;

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIView *logoutView;

+ (NSString *)reuseIdentifier;

-(IBAction)logoutBtnPressed:(id)sender;

-(IBAction)cancelBtnPressed:(id)sender;

-(IBAction)logoutAlertBtnPressed:(id)sender;

@end
