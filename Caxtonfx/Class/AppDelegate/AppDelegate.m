

//
//  AppDelegate.m
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingVC.h"
#import "ReceiptsVC.h"
#import "SplashVC.h"
#import "ImagePickerVC.h"
#import "AddMobileNoVC.h"
//#import "/usr/include/sqlite3.h"
#include <sqlite3.h>
#import "Appirater.h"
#import <Twitter/Twitter.h>
#import "DatabaseHandler.h"
#import <Social/Social.h>
//#import "TestFlight.h"
//#import <Appsee/Appsee.h>
#import "MyCardVC.h"
#import "HistoryVC.h"
#import "SettingVC.h"
#import "MBProgressHUD.h"



@implementation AppDelegate
@synthesize window,tabBarController,customeTabBar,mobileNumNotificationView;
@synthesize mainNavigation;
@synthesize shareTabBar,currentId,_array,topBarView,cameraButton;
@synthesize ratePopUpView;
@synthesize cameraLayoutImgView;
//@synthesize backgroundQueue;
-(NSDate *)getDateFromString:(NSString *)pstrDate
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init] ;
    [df1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *dtPostDate = [df1 dateFromString:pstrDate];
    return dtPostDate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //backgroundQueue = dispatch_queue_create("com.tri-media.myelane-merchant", NULL);
    
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        if ([CommonFunctions reachabiltyCheck])
        {
            [self callgetGloableRateApi];
        }
        
    });
    
    
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"switchState"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"switchState"];
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"stayLogin"] ||[[[NSUserDefaults standardUserDefaults]objectForKey:@"setPin"] isEqualToString:@"YES"] )
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
    }else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
    }
    
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    DatabasePath = [documentsDir stringByAppendingPathComponent:DatabaseName];
    NSLog(@"DatabasePath = %@",DatabasePath);
    [self checkAndCreateDatabase];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"])
    {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"]) {
            [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
        }
        else
        {
            NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
            NSDate* date2 =  [NSDate date];
            
            NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
            double secondsInAnHour = 3600;
            NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
            if (hoursBetweenDates >=12) {
                [self performSelectorInBackground:@selector(callServiceForFetchingHistoryData) withObject:nil];
            }
        }
    }
    
    UILabel *headingLable = (UILabel *)[self.mobileNumNotificationView viewWithTag:1];
    headingLable.font = [UIFont fontWithName:@"OpenSans" size:16];

    [self aboutCustomeTabbar];
    
    [self.window setRootViewController:self.tabBarController];
    
    [CommonFunctions hideTabBar:tabBarController];
    
    if (IS_HEIGHT_GTE_568)
    {
        [customeTabBar setFrame:CGRectMake(0, 507, 320, 61)];
        
        [self.ratePopUpView setFrame:CGRectMake(0.0f, 0.0f, 320, 568.0f)];
        
        [topBarView setFrame:CGRectMake(0, -548, 320, CGRectGetHeight(topBarView.frame))];
        [cameraLayoutImgView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
        
        [cameraLayoutImgView setImage:[UIImage imageNamed:@"camera5.png"]];
    }
    else{
        
        [customeTabBar setFrame:CGRectMake(0, 419, 320, 61)];
        
        [topBarView setFrame:CGRectMake(0, -460, 320, 530)];
        
        [cameraLayoutImgView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
        
        [cameraLayoutImgView setImage:[UIImage imageNamed:@"camera4.png"]];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    UIButton *btn = (UIButton*)[customeTabBar viewWithTag:2];
    
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        [self fetchCountryNameForCountryCode:countryCode];
    });
    
    
    //[self fetchCountryNameForCountryCode:countryCode];  Deepesh Jain
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    preferredCurrency = @"GBP";
    [userDefs setObject:@"GBP" forKey:@"defaultCurrency"];
    [userDefs setObject:@"flag" forKey:@"defaultCurrencyImage"];
    [userDefs synchronize];
    
//    if (![userDefs objectForKey:@"defaultCurrency"])
//    {
//        preferredCurrency = @"GBP";
//        [userDefs setObject:@"GBP" forKey:@"defaultCurrency"];
//        [userDefs setObject:@"flag" forKey:@"defaultCurrencyImage"];
//        [userDefs synchronize];
//    }
//    else
//    {
//         preferredCurrency = @"GBP";
//        [userDefs setObject:@"GBP" forKey:@"defaultCurrency"];
//    }
//        preferredCurrency = [userDefs objectForKey:@"defaultCurrency"];
//    
    [self customTabBarBtnTap:btn];
    
    [self.tabBarController setSelectedIndex:1];
    
    [self.tabBarController.view addSubview:self.customeTabBar];
    
    self.tabBarController.view.backgroundColor = [UIColor clearColor];
    
    [self.tabBarController.view addSubview:self.topBarView];
    
    [self.window makeKeyAndVisible];
    
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"] isEqualToString:@"Yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"firstTime"];
        //
        //        [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] + 1) forKey:@"ApplaunchCount"];
        //
        //        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        //        [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] + 1) forKey:@"ApplaunchCount"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        if([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] % 3 ==0)
        //        {
        //            [Appirater appLaunched:YES];
        //            [Appirater setAppId:appID];
        //            [Appirater setDaysUntilPrompt:0];
        //            [Appirater setDebug:YES];
        //
        //
        //        }
    }
    
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        [self currencySymbole];           //Deepesh
    });
    
    //    [self performSelectorInBackground:@selector(currencySymbole) withObject:nil];

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleDefault];
        self.window.clipsToBounds =YES;
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        
        //Added on 19th Sep 2013
        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
    }
    
    /***
     *
     * Set any tracking SDK inside this box
     *
     ***/
    
    //Testflight integration
    //[TestFlight takeOff:@"ed314d8d-300d-40d3-a4e5-9c94155c0bd9"];
    
    //[Appsee start:@"22727e51427f41e3a19156a13595c748"];
    
    [Flurry setCrashReportingEnabled:YES];
    
    [Flurry startSession:flurryID];
    
    
    /***
     *
     * End of tracking SDKs
     *
    ***/
    
    return YES;
}
#pragma mark -
#pragma mark Creating Database if that not exists

-(NSString *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
//	return [documentsDirectory stringByAppendingPathComponent:@"cfx.sqlite"];
    return [documentsDirectory stringByAppendingPathComponent:@"cfxNew.sqlite"];
}

-(void) checkAndCreateDatabase{
	// check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	//success = [fileManager fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"cfx.sqlite"]];
	success = [fileManager fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"cfxNew.sqlite"]];
	// If the database already exists then return without doing anything
	if(success)
	{
        NSLog(@"documentsDirectory %@",documentsDirectory);
        
		return;
	}
	else
		NSLog(@"Not Existed");
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	//NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cfx.sqlite"];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cfxNew.sqlite"];
	NSLog(@"databasePathFromApp %@",databasePathFromApp);
	// Copy the database from the package to the users filesystem
    
	//[fileManager copyItemAtPath:databasePathFromApp toPath:[documentsDirectory stringByAppendingPathComponent:@"cfx.sqlite"] error:nil];
    [fileManager copyItemAtPath:databasePathFromApp toPath:[documentsDirectory stringByAppendingPathComponent:@"cfxNew.sqlite"] error:nil];
    
}

//fetch country name from Google API then select currency code for country name from database
- (void) fetchCountryNameForCountryCode:(NSString*) countryCode
{
    if ([countryCode length] > 0)
    {
        sqlite3 *database;
        
        NSString *sqlStatement = @"";
        
        if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
        {
            NSString * currencyCode = @"";
            
            sqlStatement = [NSString stringWithFormat:@"select currency_code FROM country_table where country_code = '%@'",countryCode];
            
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    currencyCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                else
                {
                    usersLocationCurrency = nil;
                    return;
                }
            }
            sqlite3_finalize(compiledStatement);
            sqlite3_close(database);
            usersLocationCurrency = nil;
            usersLocationCurrency = [[NSString alloc] initWithString:currencyCode];
        }
    }
    else
    {
        usersLocationCurrency = nil;
    }
}

-(void)currencySymbole
{
    DatabaseHandler *dbHandler = [[DatabaseHandler alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyid-symbol-map" ofType:@"csv"];
    NSString *myText = nil;
    
    if (filePath) {
        /*
         Depracated NSString method changed with the newest one available
         myText = [NSString stringWithContentsOfFile:filePath];
         */
        myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
        if (myText) {
            [dbHandler executeQuery:@"delete from currencySymbole_table"];
            NSArray *contentArray = [myText componentsSeparatedByString:@"\r"];
            for (NSString *item in contentArray)
            {
                NSArray *itemArray = [item componentsSeparatedByString:@","];
                // log first item
                
                if ([itemArray count] > 3)
                {
                    NSString *mainSTr = [itemArray objectAtIndex:2];
                    NSString *cId = [itemArray objectAtIndex:0];
                    NSString * cIdStr = [cId stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    
                    NSString *querryStr = [NSString stringWithFormat:@"insert into currencySymbole_table values (\"%@\",\"%@\"); ",cIdStr,mainSTr];
                    [dbHandler executeQuery:querryStr];
                }
            }
            
        }
    }
}

-(IBAction) ratePopUpBtnPressed:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIButton *btn = (UIButton*) sender;
    
	
	switch (btn.tag) {
		case 1:
		{
			// they want to rate it
			[Appirater rateApp];
			break;
		}
		case 2:
			// remind them later
			[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"kAppiraterReminderRequestDate"];
			[userDefaults synchronize];
			break;
		default:
			break;
    }
    
    [[self ratePopUpView] removeFromSuperview];
    //[AppDelegate sharedAppDelegate].popUpView.superview.alpha=1.0;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSString *setPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPin"];
    if([setPin isEqualToString:@"YES"])
    {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
        [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        //                NSString *suStr = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
        NSString *str =   [wrapper objectForKey :(__bridge id)kSecValueData];
        
        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        passcodeViewController.skipStr = @"YES";
        passcodeViewController.delegate = self;
        passcodeViewController.simple = YES;
        passcodeViewController.passcode = str;
        UINavigationController *navController;
        
        UIViewController *rootViewController = self.window.rootViewController;
        
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            
            navController =(UINavigationController*)[tabBarController selectedViewController];
            
        }else{
            navController = self.mainNavigation;
        }
        
        [navController pushViewController:passcodeViewController animated:NO];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"switchState"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"switchState"];
    }
    NSString *setPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPin"];
    if([setPin isEqualToString:@"YES"])
    {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
        [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        //                NSString *suStr = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
        NSString *str =   [wrapper objectForKey :(__bridge id)kSecValueData];
        
        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        passcodeViewController.skipStr = @"YES";
        passcodeViewController.delegate = self;
        passcodeViewController.simple = YES;
        passcodeViewController.passcode = str;
        UINavigationController *navController;
        
        UIViewController *rootViewController = self.window.rootViewController;
        
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            
            navController =(UINavigationController*)[tabBarController selectedViewController];
            
        }else{
            navController = self.mainNavigation;
        }
        
        [navController pushViewController:passcodeViewController animated:NO];
    }
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"] isEqualToString:@"Yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"firstTime"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] + 1) forKey:@"ApplaunchCount"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"ApplaunchCount"] + 1) forKey:@"ApplaunchCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
     NSString *setPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPin"];
        if([setPin isEqualToString:@"YES"])
        {
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
            [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            //                NSString *suStr = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
            NSString *str =   [wrapper objectForKey :(__bridge id)kSecValueData];
            
            PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                passcodeViewController.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            }
            passcodeViewController.skipStr = @"YES";
            passcodeViewController.delegate = self;
            passcodeViewController.simple = YES;
            passcodeViewController.passcode = str;
            UINavigationController *navController;
            
            UIViewController *rootViewController = self.window.rootViewController;
            
            if ([rootViewController isKindOfClass:[UITabBarController class]]) {
                
                navController =(UINavigationController*)[tabBarController selectedViewController];
                
            }else{
                navController = self.mainNavigation;
            }

            [navController pushViewController:passcodeViewController animated:NO];
        }
}
- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller
{
    UINavigationController *navController;
    
    UIViewController *rootViewController = self.window.rootViewController;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        navController =(UINavigationController*)[tabBarController selectedViewController];
        
    }else{
        navController = self.mainNavigation;
    }
    NSLog(@"%i",[tabBarController selectedIndex]);
    UIViewController *VC =nil;
    if ([tabBarController selectedIndex]==0) {
        VC = [[HistoryVC alloc]initWithNibName:@"HistoryVC" bundle:nil];
    }else if ([tabBarController selectedIndex]==1) {
       MyCardVC* myVC = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
        if ([CommonFunctions reachabiltyCheck])
        {
            [myVC hudRefresh:self];
        }
        [navController pushViewController:myVC animated:YES];
    }else if ([tabBarController selectedIndex]==2) {
        VC = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
    }
    [navController pushViewController:VC animated:YES];
}

-(void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    NSString *query  = @"";
    
    query = @"DELETE FROM conversionHistoryTable ";
    DatabaseHandler *dataBaseHandler = [[DatabaseHandler alloc]init];
    [dataBaseHandler executeQuery:query];
    
    query = @"DELETE FROM getHistoryTable";
    [dataBaseHandler executeQuery:query];
    
    query = @"DELETE FROM myCards";
    [dataBaseHandler executeQuery:query ];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [documentsDirectory stringByAppendingPathComponent:@"patientPhotoFolder"];
    
    NSString *dataPath = patientPhotoFolder;
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:dataPath
                           isDirectory:&isDir] && isDir == NO) {
        
    }else
    {
        BOOL success = [fileManager removeItemAtPath:dataPath error:nil];
        NSLog(@"%@",success?@"YES":@"NO");
    }
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultCurrency"];                //deepesh
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultCurrencyImage"];           //deepesh
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"switchState"];                    //deepesh
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPin"];                         //deepesh
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstTimeUser"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginAttamp"];                    //deepesh
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"attemp"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIButton *tapBtn = (UIButton*)[appDelegate.customeTabBar viewWithTag:2];
    [appDelegate customTabBarBtnTap:tapBtn];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"stayLogin"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
    
    UINavigationController *navController = (UINavigationController*)[appDelegate.tabBarController selectedViewController];
    NSArray *viewArray = navController.viewControllers;
    NSLog(@"%@",viewArray);
    for (int i=0; i<viewArray.count; i++) {
        if([[viewArray objectAtIndex:i ]isKindOfClass:[HomeVC class]])
        {
            [navController popToViewController:[viewArray objectAtIndex:i] animated:YES];
            break;
            
        }
    }
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (IBAction) customTabBarBtnTap:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"])
    {
        int newIndex = [(UIButton*) sender tag];
        
        int currentIndex = self.tabBarController.selectedIndex+1;
        
        NSString *imageName;
        
        switch (currentIndex)
        {
            case 1:
                imageName = @"historyTab";
                break;
            case 2:
                imageName = @"myCardTab";
                break;
            case 3:
                imageName = @"settingsTab";
                break;
                
            default:
                break;
        }
        
        UIButton *btn;
        
        btn = (UIButton*) [self.customeTabBar viewWithTag:currentIndex];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        switch (newIndex)
        {
            case 1:
                imageName = @"historyTabHover";
                break;
            case 2:
                imageName = @"myCardTabHover";
                break;
            case 3:
                imageName = @"settingsTabHover";
                break;
                
            default:
                break;
        }
        
        btn = (UIButton*) [self.customeTabBar viewWithTag:newIndex];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        
        [self.tabBarController setSelectedIndex:newIndex-1];
    }
    else
    {
        NSString *imageName = @"myCardTabHover";
        
        int newIndex = [(UIButton*) sender tag];
        
        UIButton *btn;
        
        btn = (UIButton*)sender;
        if (newIndex == 2) {
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }
}

//call to get App Delegate's shared instance
+(AppDelegate*) getSharedInstance
{
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return appDelegate;
}
+ (dispatch_queue_t)sharedQueue
{
    static dispatch_once_t pred;
    static dispatch_queue_t sharedDispatchQueue;
    
    dispatch_once(&pred, ^{
        sharedDispatchQueue = dispatch_queue_create("com.tri-media.myelane-merchant", NULL);
    });
    
    return sharedDispatchQueue;
}
- (void) showBottomBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.bottomView setFrame:CGRectMake(0.0f, self.window.frame.size.height-55.0f, 320.0f, 55.0f)];
    [UIView commitAnimations];
}

- (IBAction)BottomButtonTouched:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        UIButton *btn = (UIButton*)[self.bottomView viewWithTag:1];
        [btn setImage:[UIImage imageNamed:@"history_tab_hover"] forState:UIControlStateNormal];
        
        btn = (UIButton*)[self.bottomView viewWithTag:3];
        [btn setImage:[UIImage imageNamed:@"settings_tab"] forState:UIControlStateNormal];
        
        for (UIViewController *tempVC in mainNavigation.viewControllers)
        {
            if ([tempVC isKindOfClass:[ReceiptsVC class]])
            {
                [mainNavigation popToViewController:tempVC animated:YES];
            }
        }
    }
    else if(sender.tag == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [self.bottomView setFrame:CGRectMake(0.0f, self.window.frame.size.height, 320.0f, 55.0f)];
        [UIView commitAnimations];
        
        //push image picker for capturing image
        for (UIViewController *tempVC in mainNavigation.viewControllers)
        {
            if ([tempVC isKindOfClass:[ImagePickerVC class]])
            {
                [mainNavigation popToViewController:tempVC animated:YES];
            }
        }
    }
    else if(sender.tag == 3)
    {
        SettingVC *tempVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
        [mainNavigation pushViewController:tempVC animated:YES];
        
        UIButton *btn = (UIButton*)[self.bottomView viewWithTag:1];
        [btn setImage:[UIImage imageNamed:@"history_tab"] forState:UIControlStateNormal];
        
        btn = (UIButton*)[self.bottomView viewWithTag:3];
        [btn setImage:[UIImage imageNamed:@"settings_tab_hover"] forState:UIControlStateNormal];
        
        BOOL hasSettingAlready = FALSE;
        
        NSArray *arr = mainNavigation.viewControllers;
        
        for (int i = 0; i < [arr count]; i++)
        {
            if ([[arr objectAtIndex:i] isKindOfClass:[SettingVC class]])
            {
                hasSettingAlready = TRUE;
            }
        }
        
        if (!hasSettingAlready)
        {
            SettingVC *tempVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
            [mainNavigation pushViewController:tempVC animated:YES];
        }
    }
}


- (IBAction)shareTabBarBtnPressed:(UIButton *)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 1:
            [self showActionSheet];
            break;
            
        case 2:
            [Appirater appLaunched:YES];
            [Appirater setAppId:appID];
            [Appirater setDaysUntilPrompt:0];
            [Appirater setDebug:YES];
            
            break;
            
        case 3:
            [self sendMail:btn];
            break;
            
        default:
            break;
    }
    
}

- (void)sendMail : (UIButton *)btn{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    UINavigationController *navController;
    
    UIViewController *rootViewController = self.window.rootViewController;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        navController =(UINavigationController*)[tabBarController selectedViewController];
        
    }else{
        navController = self.mainNavigation;
    }
    
    if (messageClass != nil) {
        
        if ([messageClass canSendText]) {
            
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:[NSArray arrayWithObject:@"cards@caxtonfx.com"]];
            [controller setSubject:@"Caxton FX Easy to Spend app feedback"];
            [navController presentViewController:controller animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Setup mail account in email in setting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)shareMail
{
    UINavigationController *navController;
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    UIViewController *rootViewController = self.window.rootViewController;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        navController =(UINavigationController*)[tabBarController selectedViewController];
    }else{
        navController = self.mainNavigation;
    }
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            //            [controller setToRecipients:[NSArray arrayWithObject:@"cards@caxtonfx.com"]];
            [controller setMessageBody:@"I’ve just used the Caxton FX travel app that makes holiday spending simple. Convert currency in a snap of a photo and manage a Caxton FX account on the move. Download yours here. https://itunes.apple.com/us/app/caxtonfx-app/id687286642?ls=1&mt=8" isHTML:NO];
            [navController presentViewController:controller animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Setup mail account in email in setting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
#pragma mark -
#pragma mark Compose Mail

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:@"Success!"
                                    message:@"Your message has been sent. Thanks for sharing the Caxton FX app."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    UIViewController *rootViewController = self.window.rootViewController;
    NSLog(@"RootVC is %@",rootViewController);
    UINavigationController *navController;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        navController =(UINavigationController*)[tabBarController selectedViewController];
        
    }else{
        navController = self.mainNavigation;
        
    }
    
    [navController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)fbBtnPressed
{
    UINavigationController *navController;
    
    UIViewController *rootViewController = self.window.rootViewController;
    NSLog(@"RootVC is %@",rootViewController);
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        navController =(UINavigationController*)[tabBarController selectedViewController];
        
    }else{
        navController = self.mainNavigation;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"I’ve just used the Caxton FX travel app that makes holiday spending simple. Convert currency in a snap of a photo and manage a Caxton FX account on the move. Download yours here. https://itunes.apple.com/us/app/caxtonfx-app/id687286642?ls=1&mt=8"];
        
        [navController presentViewController:composeController
                                    animated:YES completion:nil];
        
        [composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
            [navController dismissViewControllerAnimated:YES completion:nil];
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                {
                    output = @"Post Successfully";
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:output delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

-(void)twitterBtnPressed
{
    UINavigationController *navController;
    
    UIViewController *rootViewController = self.window.rootViewController;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        navController =(UINavigationController*)[tabBarController selectedViewController];
        
    }else{
        navController = self.mainNavigation;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController setInitialText:@"I’ve just used the Caxton FX travel app. Convert currency in a snap of a photo and manage a Caxton FX account on the move. #CaxtonCurrency"];
        
        [navController presentViewController:composeController
                                    animated:YES completion:nil];
        
        [composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            [navController dismissViewControllerAnimated:YES completion:nil];
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                {
                    output = @"Post Successfully";
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:output delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                    break;
                default:
                    break;
                    
            }
        }];
    }
}


#pragma mark MobileADDNotifictionView Method

-(IBAction)cancleBtnPressed:(id)sender
{
    if(self.mobileNumNotificationView.tag==1)
    {
        [self.mobileNumNotificationView removeFromSuperview];
    }else
    {
        [self.mobileNumNotificationView removeFromSuperview];
        AddMobileNoVC *addVc = [[AddMobileNoVC alloc]initWithNibName:@"AddMobileNoVC" bundle:nil];
        UINavigationController *navController = (UINavigationController*)[tabBarController selectedViewController];
        
        [navController pushViewController:addVc animated:YES];
    }
}

-(IBAction)okBtnPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.caxtonfx.com/login/"]];
    
    NSString *valueToSave = @"NO";
    [[NSUserDefaults standardUserDefaults]setObject:valueToSave forKey:@"FirstTimeUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)aboutCustomeTabbar
{
    UIButton *shareBtn = (UIButton *)[self.shareTabBar viewWithTag:1];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareTab"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareTabHover"] forState:UIControlStateHighlighted];
    
    UIButton *rateMeButton = (UIButton *)[self.shareTabBar viewWithTag:2];
    [rateMeButton setBackgroundImage:[UIImage imageNamed:@"rateMeTab"] forState:UIControlStateNormal];
    [rateMeButton setBackgroundImage:[UIImage imageNamed:@"rateMeTabHover"] forState:UIControlStateHighlighted];
    
    UIButton *feedbackBtn = (UIButton *)[self.shareTabBar viewWithTag:3];
    [feedbackBtn setBackgroundImage:[UIImage imageNamed:@"feedbackTab"] forState:UIControlStateNormal];
    [feedbackBtn setBackgroundImage:[UIImage imageNamed:@"feedbackTabHover"] forState:UIControlStateHighlighted];
    
}

-(void)callgetGloableRateApi
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetGlobalRates/></soapenv:Body></soapenv:Envelope>";
        
        [manger callServiceWithRequest:soapMessage methodName:@"GetGlobalRates" andDelegate:self];
    }
}

-(void)callServiceForFetchingHistoryData
{
    NSString *query = [NSString stringWithFormat:@"select CurrencyCardID from myCards"];
    
    NSMutableArray *currencyIdMA = [kHandler fetchingDataFromTable:query];
    BOOL state =         [CommonFunctions reachabiltyCheck];
    if (state)
    {
        [self fetchingHistoryData:currencyIdMA];
    }
}

-(void)fetchingHistoryData:(NSMutableArray *)currencyIdMA
{
    for (int i = 0;  i < [currencyIdMA count]; i++)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchingTransactions:[currencyIdMA objectAtIndex:i]];
            
        });
    }
}

-(void)fetchingTransactions:(NSString *)cardId
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"khistoryData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<tem:GetHistory>"
                             "<tem:userName>%@</tem:userName>"
                             "<tem:password>%@</tem:password>"
                             "<tem:currencyCardID>%@</tem:currencyCardID>"
                             "</tem:GetHistory>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>",[keychain objectForKey:(__bridge id)kSecAttrAccount],[keychain objectForKey:(__bridge id)kSecValueData],cardId];
    currentId = cardId;
    
    [[sharedManager getSharedInstance] callServiceWithRequest:soapMessage methodName:@"GetHistory" andDelegate:self];
    
}
-(void)callGetPromoApi
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetPromo/></soapenv:Body></soapenv:Envelope>";
        
        [manger callServiceWithRequest:soapMessage methodName:@"GetPromo" andDelegate:self];
    }
}

-(void)callDefaultsApi
{
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetDefaults/></soapenv:Body></soapenv:Envelope>";
        
        [manger callServiceWithRequest:soapMessage methodName:@"GetDefaults" andDelegate:self];
    }
}

#pragma mark -----
#pragma mark shardemangerDelegate Method

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    NSLog(@"service -> %@ response ->%@",service,response);
    
    if([service isEqualToString:@"GetGlobalRates"])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyflags_map" ofType:@"csv"];
        NSString *myText = nil;
        
        if (filePath) {
            /*
             Depracated NSString method changed with the newest one available
             myText = [NSString stringWithContentsOfFile:filePath];
             */
            myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
            if (myText) {
                //here
            }
        }
        //NSString *content =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]; unused variable
        NSArray *contentArray = [myText componentsSeparatedByString:@"\r"]; // CSV ends with ACSI 13 CR (if stored on a Mac Excel 2008)
        NSMutableArray *codesMA = [NSMutableArray new];
        
        for (NSString *item in contentArray)
        {
            NSArray *itemArray = [item componentsSeparatedByString:@","];
            // log first item
            
            if ([itemArray count] > 3)
            {
                NSLog(@"%@",[itemArray objectAtIndex:3]);
                [codesMA addObject:[itemArray objectAtIndex:3]];
            }
        }
        
        NSMutableArray *glabalRatesMA  = [[NSMutableArray alloc] init];
        if (![response isEqualToString:@"Response code 404/n"]) {
            TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
            TBXMLElement *root = tbxml.rootXMLElement;
            TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
            
            if(rootItemElem)
            {
                TBXMLElement *subcategoryEle = [TBXML childElementNamed:@"GetGlobalRatesResponse" parentElement:rootItemElem];
                TBXMLElement * GetGlobalRatesResult = [TBXML childElementNamed:@"GetGlobalRatesResult" parentElement:subcategoryEle];
                //TBXMLElement *baseCcy = [TBXML childElementNamed:@"a:baseCcy" parentElement:GetGlobalRatesResult]; unused variable
                TBXMLElement *expiryTime = [TBXML childElementNamed:@"a:expiryTime" parentElement:GetGlobalRatesResult];
                NSString *expiryTimeStr = [TBXML textForElement:expiryTime];
                
                [[NSUserDefaults standardUserDefaults]setObject:expiryTimeStr forKey:@"expiryTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                TBXMLElement *rates = [TBXML childElementNamed:@"a:rates" parentElement:GetGlobalRatesResult];
                if (rates)
                {
                    TBXMLElement *CFXExchangeRate = [TBXML childElementNamed:@"a:CFXExchangeRate" parentElement:rates];
                    while (CFXExchangeRate != nil) {
                        TBXMLElement *currencyCode = [TBXML childElementNamed:@"a:CcyCode" parentElement:CFXExchangeRate];
                        TBXMLElement *rate = [TBXML childElementNamed:@"a:Rate" parentElement:CFXExchangeRate];
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        [dict setObject:[TBXML textForElement:currencyCode] forKey:@"currencyCode"];
                        [dict setObject:[TBXML textForElement:rate] forKey:@"rate"];
                        int index = -1;
                        NSString *imageName = @"";
                        
                        if ([codesMA containsObject:[dict objectForKey:@"currencyCode"]])
                        {
                            index=  [codesMA indexOfObject:[dict objectForKey:@"currencyCode"]];
                            
                        }
                        if(index >=0)
                        {
                            NSString *item = [contentArray objectAtIndex:index];
                            NSArray *itemArray = [item componentsSeparatedByString:@","];
                            if (itemArray.count != 0) {
                                imageName =[[[itemArray objectAtIndex:1] lowercaseString] stringByAppendingFormat:@" - %@",[[itemArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
                            }
                        }
                        [dict setObject:imageName forKey:@"imageName"];
                        
                        if (dict) {
                            [glabalRatesMA addObject:dict];
                        }
                        CFXExchangeRate = [TBXML nextSiblingNamed:@"a:CFXExchangeRate" searchFromElement:CFXExchangeRate];
                        
                    }
                    
                }
                
                NSString *deleteQuerry = [NSString stringWithFormat:@"DELETE FROM globalRatesTable"];
                DatabaseHandler *database = [[DatabaseHandler alloc]init];
                [database executeQuery:deleteQuerry];
                
                for (NSMutableDictionary *dict in glabalRatesMA) {
                    NSString *value = [[DatabaseHandler getSharedInstance] getDataValue:[NSString stringWithFormat:@"select CardCurrencyDescription from myCards where CurrencyCardID = %@",currentId]];
                    NSString *query = [NSString stringWithFormat:@"insert into globalRatesTable ('CcyCode','Rate','imageName','cardName') values ('%@',%f,'%@','%@')",[dict objectForKey:@"currencyCode"] ,[[dict objectForKey:@"rate"] doubleValue],[dict objectForKey:@"imageName"],value];
                    [[DatabaseHandler getSharedInstance] executeQuery:query];
                }
            }
        }
        
        
    }
    else if([service isEqualToString:@"GetPromo"])
    {
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *getPromoResponseEle = [TBXML childElementNamed:@"GetPromoResponse" parentElement:rootItemElem];
        TBXMLElement *GetPromoResult = [TBXML childElementNamed:@"GetPromoResult" parentElement:getPromoResponseEle];
        TBXMLElement *GetPromoHtmlResult = [TBXML childElementNamed:@"html" parentElement:GetPromoResult];
        NSString *str = [TBXML textForElement:GetPromoHtmlResult];
        
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"moreInfoHtml"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if([service isEqualToString:@"GetDefaults"])
    {
        NSMutableArray *getDefaultDataArr  = [[NSMutableArray alloc] init];
        
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *getPromoResponseEle = [TBXML childElementNamed:@"GetDefaultsResponse" parentElement:rootItemElem];
        TBXMLElement *GetPromoResult = [TBXML childElementNamed:@"GetDefaultsResult" parentElement:getPromoResponseEle];
        TBXMLElement *GetPromoHtmlResult = [TBXML childElementNamed:@"a:products" parentElement:GetPromoResult];
        
        TBXMLElement *phoenproduct = [TBXML childElementNamed:@"a:PhoenixProduct" parentElement:GetPromoHtmlResult];
        while (phoenproduct != nil)
        {
            TBXMLElement *ccy = [TBXML childElementNamed:@"a:Ccy" parentElement:phoenproduct];
            TBXMLElement *description = [TBXML childElementNamed:@"a:Description" parentElement:phoenproduct];
            TBXMLElement *maxTopUp = [TBXML childElementNamed:@"a:MaxTopUp" parentElement:phoenproduct];
            TBXMLElement *maxTotalBalance = [TBXML childElementNamed:@"a:MaxTotalBalance" parentElement:phoenproduct];
            TBXMLElement *minTopUp = [TBXML childElementNamed:@"a:MinTopUp" parentElement:phoenproduct];
            TBXMLElement *productID = [TBXML childElementNamed:@"a:ProductID" parentElement:phoenproduct];
            
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
            
            [tempDic setValue:[TBXML textForElement:ccy] forKey:@"ccy"];
            [tempDic setValue:[TBXML textForElement:description] forKey:@"description"];
            [tempDic setValue:[TBXML textForElement:maxTopUp] forKey:@"maxTopUp"];
            [tempDic setValue:[TBXML textForElement:maxTotalBalance] forKey:@"maxTotalBalance"];
            [tempDic setValue:[TBXML textForElement:minTopUp] forKey:@"minTopUp"];
            [tempDic setValue:[TBXML textForElement:productID] forKey:@"productID"];
            
            phoenproduct = [TBXML nextSiblingNamed:@"a:PhoenixProduct" searchFromElement:phoenproduct];
            [getDefaultDataArr addObject:tempDic];
        }
        
        NSString *deleteQuerry = [NSString stringWithFormat:@"DELETE FROM getDefaults"];
        
        DatabaseHandler *database = [[DatabaseHandler alloc]init];
        [database executeQuery:deleteQuerry];
        
        for (int i = 0; i < getDefaultDataArr.count ; i++)
        {
            NSString *query = [NSString stringWithFormat:@"insert into getDefaults values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[getDefaultDataArr objectAtIndex:i] valueForKey:@"ccy"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"description"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"maxTopUp"],[[getDefaultDataArr objectAtIndex:i] valueForKey:@"maxTotalBalance"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"minTopUp"],[[getDefaultDataArr objectAtIndex:i]valueForKey:@"productID"]];
            [database executeQuery:query];
        }
    }
    else if([service isEqualToString:@"GetHistory"])
    {
        
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *checkAuthGetCardsResponseElem = [TBXML childElementNamed:@"GetHistoryResponse" parentElement:rootItemElem];
        TBXMLElement *checkAuthGetCardsResultElem = [TBXML childElementNamed:@"GetHistoryResult" parentElement:checkAuthGetCardsResponseElem];
        
        
        TBXMLElement *statusCode = [TBXML childElementNamed:@"a:statusCode" parentElement:checkAuthGetCardsResultElem];
        
        NSString *statusIs = [TBXML textForElement:statusCode];
        
        self._array = [[NSMutableArray alloc]init];
        
        if ([statusIs isEqualToString:@"000"])
        {
            TBXMLElement *cardsElem = [TBXML childElementNamed:@"a:cardHistory" parentElement:checkAuthGetCardsResultElem];
            if(cardsElem)
            {
                TBXMLElement *CardElm    = [TBXML childElementNamed:@"a:CardHistory" parentElement:cardsElem];
                while (CardElm != nil)
                {
                    
                    TBXMLElement *_amount   = [TBXML childElementNamed:@"a:TxnAmount" parentElement:CardElm];
                    NSString *amount = [TBXML textForElement:_amount];
                    
                    TBXMLElement *_date    = [TBXML childElementNamed:@"a:TxnDate" parentElement:CardElm];
                    NSString *date = [TBXML textForElement:_date];
                    
                    TBXMLElement *_vendor    = [TBXML childElementNamed:@"a:Vendor" parentElement:CardElm];
                    NSString *vendor = [TBXML textForElement:_vendor];
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:amount,@"amount",date,@"date",vendor,@"vendor", nil];
                    
                    [self._array addObject:dict];
                    
                    CardElm = [TBXML nextSiblingNamed:@"a:CardHistory" searchFromElement:CardElm];
                    
                }
            }
            [[DatabaseHandler getSharedInstance] executeQuery:[NSString stringWithFormat:@"DELETE FROM getHistoryTable where currencyId = '%@'",currentId]];
            
            for(int i=0;i<self._array.count;i++)
            {
                NSMutableDictionary *dict = [self._array objectAtIndex:i];
                
                NSString *value = [[DatabaseHandler getSharedInstance] getDataValue:[NSString stringWithFormat:@"select CardCurrencyDescription from myCards where CurrencyCardID = %@",currentId]];
                if (!value | (value.length == 0)) {
                    value = @"";
                }
                NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO getHistoryTable('amount','date','vendor','currencyId','cardName') values (%f,'%@','%@','%@','%@')",[[dict objectForKey:@"amount"] floatValue],[dict objectForKey:@"date"],[dict objectForKey:@"vendor"],currentId,value];
                [[DatabaseHandler getSharedInstance]executeQuery:queryStr];
            }
        }
        else if ([statusIs isEqualToString:@"001"])
        {
            //    001 – card expired
        }
        else if ([statusIs isEqualToString:@"002"])
        {
            //    002 – account blocked
            
        }
        
    }
}

-(void)loadingFailedWithError:(NSString *)error  withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]]) {
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    }else{
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    }
    
}

#define shouldUseDelegateExample 1
- (void)showActionSheet {
    
    JJGActionSheet *actionSheet = [[JJGActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"" primaryButtonTitle:@"" destructiveButtonTitle:@"" otherButtonTitles:@"", nil];
    if (shouldUseDelegateExample) {
        actionSheet.delegate = self;
    } else {
        actionSheet.callbackBlock = ^(JJGActionSheetCallbackType type, NSInteger buttonIndex, NSString *buttonTitle) {
            switch (type) {
                case JJGActionSheetCallbackTypeClickedButtonAtIndex:
                    NSLog(@"RDActionSheetCallbackTypeClickedButtonAtIndex %d, title %@", buttonIndex, buttonTitle);
                    break;
                case JJGActionSheetCallbackTypeDidDismissWithButtonIndex:
                    NSLog(@"RDActionSheetCallbackTypeDidDismissWithButtonIndex %d, title %@", buttonIndex, buttonTitle);
                    break;
                case JJGActionSheetCallbackTypeWillDismissWithButtonIndex:
                    NSLog(@"RDActionSheetCallbackTypeWillDismissWithButtonIndex %d, title %@", buttonIndex, buttonTitle);
                    break;
                case JJGActionSheetCallbackTypeDidPresentActionSheet:
                    NSLog(@"RDActionSheetCallbackTypeDidPresentActionSheet");
                    break;
                case JJGActionSheetCallbackTypeWillPresentActionSheet:
                    NSLog(@"RDActionSheetCallbackTypeDidPresentActionSheet");
                    break;
            }
        };
    }
    [actionSheet showFrom:self.window];
}

- (IBAction)cameraButtonTouched:(UIButton *)sender
{
    UIGraphicsBeginImageContext(self.window.bounds.size);
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.window.rootViewController = self.mainNavigation;
    
    ImagePickerVC *ivc = (ImagePickerVC*) [[[self mainNavigation] viewControllers] objectAtIndex:0];
    [ivc showCamera];
    
    UIImageView *screenImgView = [[UIImageView alloc] initWithFrame:self.window.frame];
    [screenImgView setImage:image];
    [self.window addSubview:screenImgView];
    
    UIImageView *cameraImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y-self.window.frame.size.height, self.window.frame.size.width, self.window.frame.size.height)];
    
    if (IS_HEIGHT_GTE_568)
        [cameraImgView setImage:[UIImage imageNamed:@"camera5"]];
    else
        [cameraImgView setImage:[UIImage imageNamed:@"camera4"]];
    
    [self.window addSubview:cameraImgView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [cameraImgView setFrame:self.window.frame];
    [screenImgView setFrame:CGRectMake(0.0f, self.window.frame.size.height, screenImgView.frame.size.width, screenImgView.frame.size.height)];
    [UIView commitAnimations];
}

- (IBAction) handleTapGesture:(id)sender
{
    shouldShowImgPicker = YES;
    
    CGRect frame = self.topBarView.frame;
    frame.origin.y = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
    self.topBarView.frame = frame;
    [UIView commitAnimations];
}

- (IBAction) handlePanGesture:(id)sender
{
    if ([sender state] == UIGestureRecognizerStateBegan)
    {
        startPos = self.topBarView.frame.origin;
    }
    else if ([sender state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [sender translationInView:self.topBarView.superview];
        
        NSLog(@"%@",NSStringFromCGPoint(translate));
        
        CGRect frame = self.topBarView.frame;
        frame.origin.y = startPos.y+translate.y;
        
        NSLog(@"---------------- %@",NSStringFromCGRect(frame));
        
        float minY = -460.0f;
        
        if (IS_HEIGHT_GTE_568)
        {
            minY = - 548.0f;
        }
        
        if (frame.origin.y >= minY)
        {
            self.topBarView.frame = frame;
        }
    }
    else if ([sender state] == UIGestureRecognizerStateEnded)
    {
        CGPoint translate = [sender translationInView:self.topBarView.superview];
        
        shouldShowImgPicker = NO;
        
        float y = -460.0f;
        float minScrollY = 100.0f;
        
        if (IS_HEIGHT_GTE_568) 
        {
            y = -548.0f;
            minScrollY = 180.0f;
        }
        
        if (translate.y > minScrollY)
        {
            y = 0.0f;
            shouldShowImgPicker = YES;
        }
        
        CGRect frame = self.topBarView.frame;
        frame.origin.y = y;
        
        CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.topBarView].y);
        
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
        self.topBarView.frame = frame;
        [UIView commitAnimations];
    }
}

- (void) animationDidFinish
{
    if (shouldShowImgPicker)
    {
        shouldShowImgPicker = NO;
        
        self.window.rootViewController = self.mainNavigation;
        
        ImagePickerVC *ivc = (ImagePickerVC*) [[[self mainNavigation] viewControllers] objectAtIndex:0];
        [ivc showCamera];
        
        if (IS_HEIGHT_GTE_568)
        {
            [topBarView setFrame:CGRectMake(0, -548, 320, CGRectGetHeight(topBarView.frame))];
        }
        else
        {
            [topBarView setFrame:CGRectMake(0, -460, 320, CGRectGetHeight(topBarView.frame))];
        }
    }
}

-(IBAction) autoAnimation
{
    CGRect frame = self.topBarView.frame;
    frame.origin.y = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.00f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinish)];
    self.topBarView.frame = frame;
    [UIView commitAnimations];
    
}

-(void) animationFinish
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.00f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    
    if (IS_HEIGHT_GTE_568)
    {
        [topBarView setFrame:CGRectMake(0, -548, 320, CGRectGetHeight(topBarView.frame))];
    }
    else
    {
        [topBarView setFrame:CGRectMake(0, -460, 320, CGRectGetHeight(topBarView.frame))];
    }
    
    [UIView commitAnimations];
}

-(void)actionSheet:(JJGActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"didDismissWithButtonIndex %d", buttonIndex);
}

-(void)actionSheet:(JJGActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"willDismissWithButtonIndex %d", buttonIndex);
}

-(void)willPresentActionSheet:(JJGActionSheet *)actionSheet {
    NSLog(@"willPresentActionSheet");
}

-(void)didPresentActionSheet:(JJGActionSheet *)actionSheet {
    NSLog(@"didPresentActionSheet");
}

-(void)actionSheet:(JJGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            
            [self fbBtnPressed];
            break;
        case 2:
            
            [self twitterBtnPressed];
            break;
        case 3:
            
            [self shareMail];
            break;
            
        case 0:
            
            break;
        default:
            break;
    }
    
}

@end
