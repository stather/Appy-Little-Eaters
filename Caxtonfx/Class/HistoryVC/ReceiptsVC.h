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
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong , nonatomic) IBOutlet UITableView *table;
@property (nonatomic , strong) NSMutableArray *historyArray;
@property (strong, nonatomic) IBOutlet UIButton *receiptsButton;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

- (IBAction)BottomButtonTouched:(UIButton *)sender;

- (void) showReceipts;
- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo;

@end

