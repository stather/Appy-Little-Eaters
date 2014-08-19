//
//  MoreInfoVC.h
//  Caxtonfx
//
//  Created by Sumit on 16/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreInfoVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,sharedDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIView *demoView;
@property (nonatomic, weak) IBOutlet UITextField *firstTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *lastTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *emailTxtFld;
@property (nonatomic, strong) IBOutlet UILabel *wantJoinLbl;
@property (nonatomic, strong) IBOutlet UILabel * textLbl;
@property (nonatomic, weak) IBOutlet UILabel *waringLbl;
@property (nonatomic, weak) IBOutlet UILabel *staticLable;

-(IBAction)sendBtnPressed:(id)sender;

@end
