//
//  Indicator.h
//  cfx
//
//  Created by Ashish Sharma on 25/10/12.
//
//

#import <UIKit/UIKit.h>

@protocol IndicatorDelegate

- (void) indicatorDidComplete;

@end

@interface Indicator : UIView
{
    UIImageView *animationImage;
}

@property (nonatomic, strong) id delegate;

- (void) setupView;
- (void) getLatestCurrencyConversionRates;
- (void) fetchingBanksToDisplay;
- (void) startUpdatingRates;

@end
