//
//  SplashVC.h
//  cfx
//
//  Created by Ashish on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"

@interface SplashVC : UIViewController

// decalre properties
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *currentStatusLbl;
@property (nonatomic, weak) IBOutlet UILabel *updateStatusLabel;
@property (nonatomic, weak) IBOutlet UIImageView *customIndicatorView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImg;

// decalre methods
- (void) setupReachability;
- (void) reachabilityChanged:(NSNotification*)note;
- (void) getLatestCurrencyConversionRates;
- (void) gotoImagePicker;
- (void) fetchingBanksToDisplay;
- (int) getTableCount:(NSString*) tableName;

// decalre IBActions

@end
