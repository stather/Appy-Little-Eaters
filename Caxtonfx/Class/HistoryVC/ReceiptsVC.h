//
//  ReceiptsVC.h
//  cfx
//
//  Created by Amzad on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ReceiptsVC : UIViewController <UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray *array;
    NSMutableArray *_tempMA;
    IBOutlet UILabel *navigationTitle;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak , nonatomic) IBOutlet UITableView *table;
@property (nonatomic , strong) NSMutableArray *historyArray;
@property (weak, nonatomic) IBOutlet UIButton *receiptsButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

- (IBAction)BottomButtonTouched:(UIButton *)sender;

//- (void) showReceipts;
- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo;

@end

