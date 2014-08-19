//
//  HistoryVC.h
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AddressBook/AddressBook.h>
#import "MBProgressHUD.h"

typedef int(^CustomBlock)(int number);

@interface HistoryVC : UIViewController <UITableViewDelegate , UITableViewDataSource, UIAlertViewDelegate>
{
    NSMutableArray *array;
    NSMutableArray *_tempMA;
    IBOutlet UILabel *navigationTitle;
    BOOL isLoadingViewAdded;
}
@property  MBProgressHUD* HUD;
@property (nonatomic , copy) CustomBlock block;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic , strong) NSMutableArray *_array;

@property (nonatomic , strong) IBOutlet UILabel *titleNameLbl;
@property (nonatomic , strong) IBOutlet UILabel *titletimeDateLbl;
@property (nonatomic , strong) IBOutlet UIButton *receiptsButton;
@property (nonatomic , strong) IBOutlet UIButton *captureButton;
@property (nonatomic , strong) IBOutlet UIButton *settingsButton;
@property (nonatomic , strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIView *loadingView;

@property (nonatomic , strong) NSMutableArray *conversionArray;
@property (nonatomic , strong) NSString *currentId;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;

//- (IBAction)BottomButtonTouched:(UIButton *)sender;

//- (void) showReceipts;
//- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo;
- (IBAction)imageCaptureButtonTouched:(id)sender;
@end
