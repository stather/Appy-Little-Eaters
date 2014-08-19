//
//  CurrencyPickerVC.h
//  cfx
//
//  Created by Ashish on 04/09/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CurrencyPickerVC : UIViewController <UIPickerViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSMutableArray *currencyArray;
    NSMutableArray *recentCurrencyArray;
}

//properties (IBOutlet)
@property (nonatomic, strong) IBOutlet UILabel *headingLbl;
@property (nonatomic, weak) IBOutlet UILabel *subHeadingLbl;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

//properties
@property (nonatomic) int pickerType;

//IBActions
- (IBAction) cancelBtnTap:(id)sender;
- (IBAction) doneBtnTap:(id)sender;

//methods
- (void) fetchCurrenciesFromDatabase;

@end
