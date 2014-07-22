//
//  CommonFunctions.h
//  WhatzzApp
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

 
/*
 *  System Versioning Preprocessor Macros
 */ 
 
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface CommonFunctions : NSObject
{
  
}

+ (NSString *)documentsDirectory;
+ (void)openEmail:(NSString *)address;
+ (void)openPhone:(NSString *)number;
+ (void)openSms:(NSString *)number;
+ (void)openBrowser:(NSString *)url;
+ (void)openMap:(NSString *)address;

+ (void) hideTabBar:(UITabBarController *) tabbarcontroller;
+ (void) showTabBar:(UITabBarController *) tabbarcontroller;
+ (void) checkAndCreateDatabase;

+(void) setNavigationTitle:(NSString *) title ForNavigationItem:(UINavigationItem *) navigationItem;

/**
 * Normal Alert view with only Ok btn
 */
+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg withDelegate:(id)delegate;
+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg;

/**
 * user for check that value is empty or not
 * shows a alert : server not responding error
 */
+ (BOOL)isValueNotEmpty:(NSString*)aString;

/**
 * shows a alert : server not found , try again later
 */
+ (void)showServerNotFoundError;

+ (BOOL)isRetineDisplay;

+ (NSString*) getImageNameForName:(NSString*) name;

+ (NSString*) getNibNameForName:(NSString*) name;

+ (void) showAlertWithInfo:(NSDictionary*) infoDic;


+(BOOL) reachabiltyCheck;
+(BOOL)reachabilityChanged:(NSNotification*)note;
+ (BOOL) connectedToNetwork;
+(UIBarButtonItem *)backButton;
+ (void)backBtnPressed:(id)sender;
+ (CAKeyframeAnimation *) attachPopUpAnimation;

+(NSString *)statusOfLastUpdate:(NSDate *)dateHis;

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end

