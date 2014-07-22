//
//  MoreInfoVC.h
//  Caxtonfx
//
//  Created by Sumit on 16/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreInfoVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,sharedDelegate>

@property (nonatomic ,strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@property (nonatomic, strong) IBOutlet UIView *demoView;

@property (nonatomic ,strong) IBOutlet UITextField *firstTxtFld;

@property (nonatomic ,strong) IBOutlet UITextField *lastTxtFld;

@property (nonatomic ,strong) IBOutlet UITextField *emailTxtFld;

@property (nonatomic, strong) IBOutlet UILabel *wantJoinLbl;

@property (nonatomic, strong) IBOutlet UILabel * textLbl;

@property (nonatomic, strong) IBOutlet UILabel *waringLbl;

@property (nonatomic, strong) IBOutlet UILabel *staticLable;

-(IBAction)sendBtnPressed:(id)sender;

@end
