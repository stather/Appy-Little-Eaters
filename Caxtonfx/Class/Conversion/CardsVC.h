//
//  CardsVC.h
//  cfx
//
//  Created by Ashish Sharma on 15/10/12.
//
//

#import <UIKit/UIKit.h>
#import "ConversionVC.h"

@interface CardsVC : UIViewController <UIScrollViewDelegate>
{
    UIImage *imageToConvert;
    CGRect focusBounds;
    int currentPage;
    NSMutableArray *currencyArr;
    NSMutableArray *bankArr;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


- (id) initWithImageToConvert:(UIImage*) img andCurrencyArr:(NSMutableArray*) arr andBankArr:(NSMutableArray*) arr2 andFocusBounds:(CGRect) bounds andPageNumber:(int) page;

@end
