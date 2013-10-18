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
@property (nonatomic, strong) IBOutlet UILabel *rateLbl;
@property (nonatomic, strong) IBOutlet UILabel *institutionNameLbl;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic , strong) NSMutableData *mutableData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *sourceCurrencyLbl;
@property (strong, nonatomic) IBOutlet UILabel *targetCurrencyLbl;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLbl;
@property (strong, nonatomic) IBOutlet UIButton *targetBtn;
@property (strong, nonatomic) IBOutlet UIButton *preferredBtn;
@property (nonatomic , strong) NSMutableDictionary *detailsDict;
@end
