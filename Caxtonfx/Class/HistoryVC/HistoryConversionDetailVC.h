//
//  HistoryConversionDetailVC.h
//  cfx
//
//  Created by Nishant on 10/12/12.
//
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
@interface HistoryConversionDetailVC : UIViewController<UIScrollViewDelegate, NSURLConnectionDelegate>
{
    
}
@property (nonatomic, weak) IBOutlet UILabel *rateLbl;
@property (nonatomic, weak) IBOutlet UILabel *institutionNameLbl;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic , strong) NSMutableData *mutableData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *sourceCurrencyLbl;
@property (strong, nonatomic) IBOutlet UILabel *targetCurrencyLbl;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *targetBtn;
@property (weak, nonatomic) IBOutlet UIButton *preferredBtn;
@property (nonatomic , strong) NSMutableDictionary *detailsDict;
@end
