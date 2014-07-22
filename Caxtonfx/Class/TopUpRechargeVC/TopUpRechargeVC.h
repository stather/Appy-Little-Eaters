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
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MBProgressHUD.h"
#import "Card.h"
#import "GlobalRatesObject.h"
#import "User.h"
#import "DefaultsObject.h"

@class TopUpRechargeVC;

@protocol TopUpRechargeVCDelegate
- (void)topupResult:(NSIndexPath*)path dict :(NSMutableDictionary*)dict1;
- (void)topupResult:(NSIndexPath*)path WithCard :(Card*)myCard;
- (void)noRefreshTopupResult:(NSIndexPath*)path dict:(NSMutableDictionary *)dict1;
@end


@interface TopUpRechargeVC : UIViewController<UIGestureRecognizerDelegate,sharedDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,CBPeripheralManagerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIImageView *flagImgView;

@property (nonatomic, strong) IBOutlet UIImageView *leftSymbolImgView;

@property (nonatomic, strong) IBOutlet UIImageView *rightSymbolImgView;

@property (nonatomic, strong) IBOutlet UITextField *leftTxtField;

@property (nonatomic, strong) IBOutlet UITextField *rightTxtField;

@property (nonatomic, strong) IBOutlet UIView *redView;

@property (nonatomic, strong) IBOutlet UILabel *twoTimeLable;

@property (nonatomic, strong) Card *dataDict;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSString *sybolString;

@property (nonatomic, strong) NSString *counveronCurrencyString;

//@property (nonatomic, strong) NSMutableArray *defaultsArray;

//@property (nonatomic, strong) NSMutableArray *counveronCurrencyArray;

@property (nonatomic, strong)  DefaultsObject *myDefObj;

@property (nonatomic, strong)  GlobalRatesObject *myGlobj;

@property(nonatomic,strong)id <TopUpRechargeVCDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIView *alertView;

@property (nonatomic, strong) IBOutlet UILabel *titleLable;

@property (nonatomic, strong) IBOutlet UILabel *textLbl;

@property (nonatomic, strong)  IBOutlet UILabel *firstSymbolLbl;

@property (nonatomic, strong)  IBOutlet UILabel *warningLbl;

@property (nonatomic, strong)  IBOutlet UILabel *scndSymbolLbl;

@property (nonatomic , strong) NSString *currentId;

@property (nonatomic , strong) NSMutableArray *_array;

@property (nonatomic, strong) IBOutlet UIView *notMessageView;

-(IBAction)cancleBtnPressed:(id)sender;

-(IBAction)topUpBtnPressed:(id)sender;

-(IBAction)openMsgApp:(id)sender;

-(IBAction)cancelBtnPressed:(id)sender;

-(IBAction)OkBtnPressed:(id)sender;


//Testing iBeacons functionalituy for Caxton Fx app
@property (nonatomic, weak)  UIButton *sendMoney;

@property (nonatomic, weak)  UIButton *recieveMoney;

-(IBAction)recieveMoney:(id)sender;

-(IBAction)sendMoney:(id)sender;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MBProgressHUD* HUD;

@end
