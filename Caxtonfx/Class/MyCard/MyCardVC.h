//
//  MyCardVC.h
//  Caxtonfx
//
//  Created by Sumit on 17/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopUpRechargeVC.h"
@interface MyCardVC : UIViewController<UITableViewDataSource,UITableViewDelegate,TopUpRechargeVCDelegate,MBProgressHUDDelegate>

@property MBProgressHUD* HUD;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) NSMutableArray *cardsArray;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *contentArray;

@property BOOL loadingFromPin;

-(void)topupBtnPressed:(NSIndexPath*)indexPath;

- (void)hudRefresh :(id)sender;

- (void)noRefreshTopupResult:(NSIndexPath*)path dict:(NSMutableDictionary *)dict1;

@end
