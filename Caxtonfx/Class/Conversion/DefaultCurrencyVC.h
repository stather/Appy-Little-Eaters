//
//  DefaultCurrencyVC.h
//  DemoApp
//
//  Created by Amzad on 10/8/12.
//  Copyright (c) 2012 konstant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseHandler.h"
#import "MBProgressHUD.h"

@interface DefaultCurrencyVC : UIViewController <UITableViewDelegate , UITableViewDataSource, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSMutableArray *array;
    
    IBOutlet UILabel *navigationTitle;
    
    int selectedRow;
}

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *receiptsButton;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) NSMutableArray *currencyArray;

@end

