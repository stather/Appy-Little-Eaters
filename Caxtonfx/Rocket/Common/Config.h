//
//  Config.h
//  WhatzzApp
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CommonFunctions.h"



@interface Config : NSObject {

}

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//configuration section... 
extern  NSString		*SiteURL;
extern  NSString		*SiteAPIURL;

extern  NSString	*DatabaseName;
extern  NSString	*DatabasePath;


extern  NSString	*preferredLang;
extern  NSString *resloutionType;


extern  NSString                *preferredCurrency; // currency in which menus are going to be convert
extern  NSString                *targetCurrency; // currency which is always going to be detect from menu (if no currency detected then user locale based currency will be in use)
extern  NSString                *fromConversionSection;


extern  NSString                *usersLocationCurrency;
extern  NSString                *appID;

extern NSString* dateInString;
extern  BOOL                     redrawWithNewCurrency;
extern  BOOL                     isBanksSettingsChanged;
extern  BOOL                     isCurrencySettingsChanged;
extern  BOOL                     isFacebookRequest;
extern  BOOL                     shouldUpdateRates;
extern  BOOL                     isImageIsUsingForConversionFirstTime;

extern NSString *userDOBStr;
extern NSString *userMobileStr;
extern NSString *userConactTypeStr;

extern NSString *flurryID;

extern int LoginAttamp;




@end
