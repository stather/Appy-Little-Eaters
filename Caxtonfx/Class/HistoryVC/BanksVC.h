//
//  BanksVC.h
//  cfx
//
//  Created by Nishant on 10/11/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseHandler.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface BanksVC : UIViewController <UITableViewDelegate , UITableViewDataSource,EGORefreshTableHeaderDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *array;
    NSMutableArray *_tempMA;
    int indexIs;
    IBOutlet UILabel *navigationTitle;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak , nonatomic) IBOutlet UITableView *table;
@property (nonatomic , strong) NSMutableArray *banksArray;
@property (strong, nonatomic) IBOutlet UIButton *receiptsButton;

@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (nonatomic) BOOL addOrRemoveBank;

-(void)fetchingBanksToDisplay;

@end
