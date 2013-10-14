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

@interface SettingVC : UIViewController <UITableViewDataSource,UITableViewDelegate,PAPasscodeViewControllerDelegate>
{
    BOOL isOn;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *defaultconDic;

@end
