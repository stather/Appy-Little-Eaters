//
//  MyCardVC.h
//  Caxtonfx
//
//  Created by Sumit on 17/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopUpRechargeVC.h"
@interface MyCardVC : UIViewController<UITableViewDataSource,UITableViewDelegate,sharedDelegate,TopUpRechargeVCDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) NSMutableArray *cardsArray;

@property (nonatomic, strong)UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *contentArray;

-(void)topupBtnPressed:(NSIndexPath*)indexPath;

@end
