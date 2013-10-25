//
//  HistoryTransactionsVC.h
//  Caxtonfx
//
//  Created by Nishant on 24/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTransactionsVC : UIViewController <UITableViewDelegate , UITableViewDataSource,sharedDelegate>
{
    
NSMutableArray *array;
NSMutableArray *_tempMA;
IBOutlet UILabel *navigationTitle;


    int selectedIndex;

}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic , strong) NSMutableArray *_array;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic , strong) NSString *currentId;
@property (nonatomic , strong) IBOutlet UILabel *titleNameLbl;
@property (nonatomic , strong) IBOutlet UILabel *titletimeDateLbl;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong , nonatomic) IBOutlet UITableView *table;
@property (nonatomic , strong) NSMutableArray *historyArray;
@property (strong, nonatomic) IBOutlet UIButton *receiptsButton;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;

- (IBAction)BottomButtonTouched:(UIButton *)sender;

- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo;

@end