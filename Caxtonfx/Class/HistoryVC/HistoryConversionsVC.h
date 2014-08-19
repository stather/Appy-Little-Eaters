//
//  HistoryConversionsVC.h
//  Caxtonfx
//
//  Created by Nishant on 24/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryConversionsVC : UIViewController <UITableViewDelegate , UITableViewDataSource>
{
    
    NSMutableArray *array;
    NSMutableArray *_tempMA;
    IBOutlet UILabel *navigationTitle;
    
    
    int selectedIndex;
}
@property (nonatomic , strong) IBOutlet UILabel *titleNameLbl;
@property (nonatomic , strong) IBOutlet UILabel *titletimeDateLbl;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak , nonatomic) IBOutlet UITableView *table;
@property (nonatomic , strong) NSMutableArray *historyArray;
@property (strong, nonatomic) IBOutlet UIButton *receiptsButton;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;

- (IBAction)BottomButtonTouched:(UIButton *)sender;

- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo;


@end