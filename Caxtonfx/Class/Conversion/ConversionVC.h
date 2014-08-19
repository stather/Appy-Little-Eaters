//
//  ConversionVC.h
//  cfx
//
//  Created by Ashish on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MyPageControl.h"
#import "sharedManager.h"
#import "JJGActionSheet.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface ConversionVC : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate,UITableViewDelegate, sharedDelegate,JJGActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
//	CMocrRecognitionConfiguration* _ocrConfiguration;
//	CMocrRecognitionConfiguration* _bcrConfiguration;
//	
//	CRecognitionService* _recognitionService;
//Saurabh
    NSString* _dataPath;
    NSString* _language;
    NSMutableDictionary* _variables;

    NSMutableArray *currencyArr;
    
    NSMutableArray *bankArr;
    
    NSMutableArray *menuCardViewControllers;
    
    NSString* _pathToData;
    
	BOOL _needToStopRecognition;
    BOOL isCurrencyCodeOrSymbolFound;
    
    MBProgressHUD *HUD;
    
    int kNumberOfPages;
    
    MyPageControl *bankPageControl;
    MyPageControl *menuPageControl;
    
    
    UIActivityIndicatorView *indicatorView;
    UILabel *ProcessingLbl;
}
@property (weak, nonatomic) IBOutlet UIImageView *toolTipImgView;
@property (weak, nonatomic) IBOutlet UILabel *toolTipLbl;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UIButton *targetBtn;
@property (nonatomic, weak) IBOutlet UIButton *preferredBtn;
@property (nonatomic, weak) IBOutlet UIButton *pullViewDownBtn;
@property (nonatomic, weak) IBOutlet UIScrollView *menuScroller;
@property (nonatomic, weak) IBOutlet UIScrollView *bankScroller;
@property (nonatomic, weak) IBOutlet UIView *pullView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *rateLbl;
@property (nonatomic, weak) IBOutlet UILabel *institutionNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *comissionLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;

@property (nonatomic, weak) UIImage *imageToConvert;
@property (nonatomic) CGRect focusBounds;

- (IBAction) currencyPickerBtnTap:(id)sender;
- (IBAction) pullViewBtnTap:(id)sender;
- (IBAction) hidePullViewBtnTap:(id)sender;

/* commented becuase no implementation methods are created
 *
 *
- (void) initializeRecognitionEngine;
- (void) redrawImageWithNewCurrency;
- (void) gotoImagePicker;
 *
 *
*/
- (int) getTableCount:(NSString*) tableName;
- (void) setUpBankScroller;
- (void) setImageForDownArrowBtn;
- (void) setInstitutionInfo:(NSDictionary*) dic;
- (void) getSelectedBanksDetail:(NSArray*) arr;
- (void) addNewBankBtnTap:(id) sender;
- (void) bankBtnTap:(id) sender;
- (void) doSomeImageAdjustment;
- (void) startRecognization:(UIImage*) image;

- (NSString*) pathToData;
- (NSString*) getBaseCurrency;

//- (CMocrRecognitionConfiguration*) ocrConfiguration;
//- (CMocrRecognitionConfiguration*) bcrConfiguration;
//
//
//// Represent CMocrLayout as html string to show in UIWebView.
//- (NSString*) htmlFromMocrLayout:(CMocrLayout*)layout;
//
//- (void) showResults:(NSString*)stringToOutput;
//
//- (void) showMocrError:(TMocrErrorCode)errorCode message:(NSString*)errorMessage;
//
//- (void) recognizeImage:(UIImage*)image;
//
//- (void) processRecognitionOperation:(CRecognitionOperation*)operation;
//Saurabh


- (void) onBeforeRecognition;

- (void) onAfterRecognition;

- (BOOL) isNumericCharacter:(int) unicode;
- (BOOL) isCurrencySymbol:(int) unicode;
- (BOOL) isAlphabet:(int) unicode;
- (BOOL) isCurrencyWord:(NSString*) wordStr;
- (NSString*) getCurrencyCode;
- (NSString*) getConvertedCurrency:(NSString *) currencyStr;
- (NSString*) getCurrencyNameForCurrencyCode:(NSString*) currencyCode;

- (NSString*) addCurrencySymbolToCalculatedCurrency:(NSString*) currency;

//+ (NSString*) stringFromMocrErrorCode:(TMocrErrorCode)errorCode;
//Saurabh

- (IBAction) saveButtonTap:(id) sender;
- (IBAction) shareButtonTap:(id) sender;

- (float) getConversionMultiplier;
- (IBAction) moreInfoButtonTap:(id) sender;

-(void)hideProcessingControls;


// decalre methods
- (void) setupReachability;
- (void) reachabilityChanged:(NSNotification*)note;
- (void) getLatestCurrencyConversionRates;
- (void) fetchingBanksToDisplay;

@end
