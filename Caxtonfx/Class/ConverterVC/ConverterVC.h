//
//  ConverterVC.h
//  Caxtonfx
//
//  Created by George Bafaloukas on 26/02/2014.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseCurrencyVC.h"
#import "MBProgressHUD.h"

@interface ConverterVC : UIViewController <SelectorDelegate>{
    UITextField *baseField;
    UITextField *targetField;
    UIScrollView *myScrollView;
}
@property  MBProgressHUD* HUD;
@property IBOutlet UILabel *targetRate;
@property IBOutlet UIScrollView *myScrollView;
@property IBOutlet UITextField *baseField;
@property IBOutlet UITextField *targetField;
@property IBOutlet UILabel *targetLabel;
@property (nonatomic, strong)  GlobalRatesObject *myGlobj;

@end
