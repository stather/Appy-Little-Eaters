//
//  TopUpRechargeVC.h
//  Caxtonfx
//
//  Created by Sumit on 08/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "sharedManager.h"
@class TopUpRechargeVC;

@protocol TopUpRechargeVCDelegate
- (void)topupResult:(NSIndexPath*)path dict :(NSMutableDictionary*)dict1;
@end


@interface TopUpRechargeVC : UIViewController<UIGestureRecognizerDelegate,sharedDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIImageView *flagImgView;

@property (nonatomic, strong) IBOutlet UIImageView *leftSymbolImgView;

@property (nonatomic, strong) IBOutlet UIImageView *rightSymbolImgView;

@property (nonatomic, strong) IBOutlet UITextField *leftTxtField;

@property (nonatomic, strong) IBOutlet UITextField *rightTxtField;

@property (nonatomic, strong) IBOutlet UIView *redView;

@property (nonatomic, strong) IBOutlet UILabel *twoTimeLable;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSMutableArray *defaultsArray;

@property (nonatomic, strong) NSString *sybolString;

@property (nonatomic, strong) NSString *counveronCurrencyString;

@property (nonatomic, strong) NSMutableArray *counveronCurrencyArray;

@property(nonatomic,strong)id <TopUpRechargeVCDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIView *alertView;

@property (nonatomic, strong) IBOutlet UILabel *titleLable;

@property (nonatomic, strong) IBOutlet UILabel *textLbl;

@property (nonatomic, strong)  UIView *inputAccView;

@property (nonatomic, strong)  IBOutlet UILabel *firstSymbolLbl,*warningLbl;

@property (nonatomic, strong)  IBOutlet UILabel *scndSymbolLbl;

@property (nonatomic , strong) NSString *currentId;

@property (nonatomic , strong) NSMutableArray *_array;

@property (nonatomic, strong) IBOutlet UIView *notMessageView;

-(IBAction)cancleBtnPressed:(id)sender;

-(IBAction)topUpBtnPressed:(id)sender;

-(IBAction)openMsgApp:(id)sender;

-(IBAction)cancelBtnPressed:(id)sender;

-(IBAction)OkBtnPressed:(id)sender;

@end
