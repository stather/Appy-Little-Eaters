//
//  SettingVC.h
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESwitch.h"
#import "PAPasscodeViewController.h"
#import "KeychainItemWrapper.h"
#import "LogoutTableCell.h"

@interface SettingVC : UIViewController <UITableViewDataSource,UITableViewDelegate,PAPasscodeViewControllerDelegate>
{
    BOOL isOn;
    UILabel *pinLable;
    UILabel *pinSecLable;
    LogoutTableCell *logoutTableCell;
    BOOL needsHeight;
}
@property (nonatomic, strong) LogoutTableCell *logoutTableCell;
@property (nonatomic, strong) IBOutlet UILabel *pinLable;
@property (nonatomic, strong) IBOutlet UILabel *pinSecLable;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *defaultconDic;

@end
