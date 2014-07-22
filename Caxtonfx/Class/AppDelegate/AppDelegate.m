  

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
#import "Appirater.h"
#import <Twitter/Twitter.h>
#import "DatabaseHandler.h"
#import <Social/Social.h>
#import "MyCardVC.h"
#import "HistoryVC.h"
#import "SettingVC.h"
#import "MBProgressHUD.h"
#import "GlobalRatesObject.h"
#import <Crashlytics/Crashlytics.h>
#include <sqlite3.h>

@implementation AppDelegate
@synthesize window,tabBarController,customeTabBar,mobileNumNotificationView;
@synthesize mainNavigation;
@synthesize shareTabBar,currentId,_array,topBarView,cameraButton;
@synthesize ratePopUpView;
@synthesize cameraLayoutImgView;
@synthesize locationManager;
@synthesize sentAmount;
@synthesize transferCardId;

-(NSDate *)getDateFromString:(NSString *)pstrDate
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init] ;
    [df1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *dtPostDate = [df1 dateFromString:pstrDate];
    return dtPostDate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"5df1cb41881109b7a9ac7f31d77583109958e239"];
    [[Crashlytics sharedInstance] setDebugMode:YES];
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        User *myUser = [User sharedInstance];
        if ([CommonFunctions reachabiltyCheck]){
            myUser.globalRates = [myUser loadGlobalRatesWithRemote:YES];
            myUser.defaultsArray = [myUser loadDefaultsWithRemote:YES];
        }else{
            myUser.globalRates = [myUser loadGlobalRatesWithRemote:NO];
            myUser.defaultsArray = [myUser loadDefaultsWithRemote:NO];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    DatabasePath = [documentsDir stringByAppendingPathComponent:DatabaseName];
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
            if (hoursBetweenDates >= 12) {
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
//        [topBarView setFrame:CGRectMake(0, -548, 320, CGRectGetHeight(topBarView.frame))];
        [cameraLayoutImgView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
        [cameraLayoutImgView setImage:[UIImage imageNamed:@"camera5.png"]];
    }
    else{
        [customeTabBar setFrame:CGRectMake(0, 419, 320, 61)];
//        [topBarView setFrame:CGRectMake(0, -460, 320, 530)];
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
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    preferredCurrency = @"GBP";
    [userDefs setObject:@"GBP" forKey:@"defaultCurrency"];
    [userDefs setObject:@"flag" forKey:@"defaultCurrencyImage"];
    [userDefs synchronize];
    [self customTabBarBtnTap:btn];
    [self.tabBarController setSelectedIndex:1];
    [self.tabBarController.view addSubview:self.customeTabBar];
    self.tabBarController.view.backgroundColor = [UIColor clearColor];
    [self.tabBarController.view addSubview:self.topBarView];
    [self.window makeKeyAndVisible];
    dispatch_async([[[AppDelegate getSharedInstance] class] sharedQueue], ^(void) {
        [self currencySymbole];            
    });
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleDefault];
        self.window.clipsToBounds = YES;
    }
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"dbUpdated"] isEqualToString:@"NO"] || ![[NSUserDefaults standardUserDefaults] valueForKey:@"dbUpdated"])
    {
        [self updateDatabase];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"dbUpdated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    /***
     *
     * Set any tracking SDK inside this box
     *
     ***/
    
    [Flurry setCrashReportingEnabled:YES];
    
    [Flurry startSession:flurryID];
    
    /***
     *
     * End of tracking SDKs
     *
    ***/
    
    // and, push notification registration and setup
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    
    //LOCATION BASED TESTING 29/01/2014
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    [NSTimer scheduledTimerWithTimeInterval: 600.0 target: self
//                                                      selector: @selector(startLocationTracking) userInfo: nil repeats: YES];
//
//    [self startLocationTracking];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //TO-DO: Notify Back-End System for the device token
    NSLog(@"Device Token=> %@",deviceToken);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
     NSLog(@"Error in registration. Error: %@", error.description);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //TO-DO: Ask Business
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([userInfo valueForKey:@"Rates"] !=nil) {
        NSDictionary *ratesDic =[userInfo valueForKey:@"Rates"];
        NSString *rates=[NSString stringWithFormat:@"Dollar:%@ \n Euro:%@",[ratesDic valueForKey:@"Dollar"],[ratesDic valueForKey:@"Euro"]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Check out the current rates:" message:rates delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    if ([userInfo valueForKey:@"Transfer"] !=nil) {
        NSDictionary *ratesDic =[userInfo valueForKey:@"Transfer"];
        self.sentAmount =[[ratesDic valueForKey:@"Amount"] floatValue];
        NSString *rates=[NSString stringWithFormat:@"Transfered Amount: £%@",[ratesDic valueForKey:@"Amount"]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Funds Transfer Completed" message:rates delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag =1;
        [alert show];
    }
    if ([userInfo valueForKey:@"Promo"] !=nil) {
        NSDictionary *promoDic =[userInfo valueForKey:@"Promo"];
        NSString *promo = [promoDic valueForKey:@"Message"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Caxton Fx" message:promo delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

#pragma mark -
#pragma mark Creating Database if that not exists

-(NSString *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
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
	// Copy the database from the package to the users filesystem
    
	//[fileManager copyItemAtPath:databasePathFromApp toPath:[documentsDirectory stringByAppendingPathComponent:@"cfx.sqlite"] error:nil];
    [fileManager copyItemAtPath:databasePathFromApp toPath:[documentsDirectory stringByAppendingPathComponent:@"cfxNew.sqlite"] error:nil];
    
}
-(void)updateDatabase {
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    @try {
        NSString *query = @"DROP TABLE getHistoryTable;";
        [database executeUpdate:query];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception);
        [Flurry logEvent:@"Drop getHistoryTable Exception"];
    }
    @try {
        NSString *query1 = @"CREATE TABLE getHistoryTable (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , amount DOUBLE  , date DATETIME  , vendor VARCHAR  , currencyId VARCHAR, cardName VARCHAR)";
        [database executeUpdate:query1];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception);
        [Flurry logEvent:@"Create getHistoryTable Exception"];
    }
    [database close];
    [self doLogout];
}

//fetch country name from Google API then select currency code for country name from database
- (void) fetchCountryNameForCountryCode:(NSString*) countryCode
{
    if ([countryCode length] > 0)
    {
        NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [pathsNew objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        FMResultSet *countryResult = [database executeQuery:[NSString stringWithFormat:@"select currency_code FROM country_table where country_code = '%@'",countryCode]];
        while ([countryResult next]) {
            usersLocationCurrency = nil;
            usersLocationCurrency = [countryResult stringForColumn:@"currency_code"];
        }
        [database close];
    }
    else
    {
        usersLocationCurrency = nil;
    }
}

-(void)currencySymbole
{
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyid-symbol-map" ofType:@"csv"];
    NSString *myText = nil;
    if (filePath) {
        myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
        if (myText) {
            [database executeUpdate:@"delete from currencySymbole_table"];
            NSArray *contentArray = [myText componentsSeparatedByString:@"\r"];
            for (NSString *item in contentArray)
            {
                NSArray *itemArray = [item componentsSeparatedByString:@","];
                if ([itemArray count] > 3)
                {
                    NSString *mainSTr = [itemArray objectAtIndex:2];
                    NSString *cId = [itemArray objectAtIndex:0];
                    NSString * cIdStr = [cId stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    NSString *querryStr = [NSString stringWithFormat:@"insert into currencySymbole_table values (\"%@\",\"%@\"); ",cIdStr,mainSTr];
                    [database executeUpdate:querryStr];
                }
            }
            
        }
    }
    [database close];
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
            [userDefaults setBool:YES forKey:@"rateFlag"];
			[userDefaults synchronize];
			break;
		}
		case 2:
        {
			// remind them later
			[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"kAppiraterReminderRequestDate"];
			[userDefaults synchronize];
			break;
        }
        case 3:
		{
			// they don't want to rate it
			[userDefaults setBool:YES forKey:@"rateFlag"];
			[userDefaults synchronize];
			break;
		}
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
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"switchState"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"switchState"];
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
     NSString *setPin = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPin"];
        if([setPin isEqualToString:@"YES"])
        {
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"pss" accessGroup:nil];
            [wrapper setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
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
            if ([rootViewController isKindOfClass:[UITabBarController class]])
                navController =(UINavigationController*)[tabBarController selectedViewController];
            else
                navController = self.mainNavigation;

            [navController pushViewController:passcodeViewController animated:NO];
        }
}
- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller
{
    UINavigationController *navController;
    UIViewController *rootViewController = self.window.rootViewController;
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        navController =(UINavigationController*)[tabBarController selectedViewController];
    else
        navController = self.mainNavigation;

    UIViewController *VC =nil;
    if ([tabBarController selectedIndex]==0) {
        VC = [[HistoryVC alloc]initWithNibName:@"HistoryVC" bundle:nil];
        [navController pushViewController:VC animated:YES];
    }else if ([tabBarController selectedIndex]==1) {
        UINavigationController *navController = (UINavigationController*)[self.tabBarController selectedViewController];
        NSArray *viewArray = navController.viewControllers;
        BOOL found =FALSE;
        for (int i=0; i<viewArray.count; i++) {
            if([[viewArray objectAtIndex:i ]isKindOfClass:[MyCardVC class]])
            {
                MyCardVC *myCardInstance =[viewArray objectAtIndex:i];
                myCardInstance.loadingFromPin = TRUE;
                [navController popToViewController:myCardInstance animated:YES];
                if ([CommonFunctions reachabiltyCheck])
                    [myCardInstance hudRefresh:self];
                found = TRUE;
                break;
            }
        }
        if(!found){
            MyCardVC* myVC = [[MyCardVC alloc]initWithNibName:@"MyCardVC" bundle:nil];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            myVC.loadingFromPin = TRUE;
            if ([CommonFunctions reachabiltyCheck])
                [myVC hudRefresh:self];
            
            [navController pushViewController:myVC animated:YES];
        }
    }else if ([tabBarController selectedIndex]==2) {
        VC = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
        [navController pushViewController:VC animated:YES];
    }
}

-(void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    [self doLogout];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.locationManager stopUpdatingLocation];
    self.locationManager =nil;
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
        
        if (newIndex == 1) {
            NSLog(@"%@",self.tabBarController.viewControllers);
            UINavigationController *myNavC =[self.tabBarController.viewControllers objectAtIndex:newIndex-1];
            for (UIViewController *tempController in myNavC.viewControllers) {
                if ([tempController isKindOfClass:[PAPasscodeViewController class]]) {
                    HistoryVC* VC = [[HistoryVC alloc]initWithNibName:@"HistoryVC" bundle:nil];
                    [myNavC setViewControllers:[NSArray arrayWithObject:VC] animated:YES];
                }
            }
        }
        if (newIndex == 3) {
            NSLog(@"%@",self.tabBarController.viewControllers);
            UINavigationController *myNavC =[self.tabBarController.viewControllers objectAtIndex:newIndex-1];
            for (UIViewController *tempController in myNavC.viewControllers) {
                if ([tempController isKindOfClass:[PAPasscodeViewController class]]) {
                    SettingVC* VC = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
                    [myNavC setViewControllers:[NSArray arrayWithObject:VC] animated:YES];
                }
            }
        }
        
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
            UIButton *btn;
            
            btn = (UIButton*) [self.customeTabBar viewWithTag:1];
            [btn setImage:[UIImage imageNamed:@"historyTab"] forState:UIControlStateNormal];
            btn = (UIButton*) [self.customeTabBar viewWithTag:3];
            [btn setImage:[UIImage imageNamed:@"settingsTab"] forState:UIControlStateNormal];
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
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        navController =(UINavigationController*)[tabBarController selectedViewController];
      else
        navController = self.mainNavigation;
    
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
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        navController =(UINavigationController*)[tabBarController selectedViewController];
    else
        navController = self.mainNavigation;

    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
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
    UINavigationController *navController;
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        navController =(UINavigationController*)[tabBarController selectedViewController];
    else
        navController = self.mainNavigation;
    
    [navController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)fbBtnPressed
{
    UINavigationController *navController;
    
    UIViewController *rootViewController = self.window.rootViewController;
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        navController =(UINavigationController*)[tabBarController selectedViewController];
    else
        navController = self.mainNavigation;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"I’ve just used the Caxton FX travel app that makes holiday spending simple. Convert currency in a snap of a photo and manage a Caxton FX account on the move. Download yours here. https://itunes.apple.com/us/app/caxtonfx-app/id687286642?ls=1&mt=8"];
        
        [navController presentViewController:composeController
                                    animated:YES completion:nil];
        [composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
            [navController dismissViewControllerAnimated:YES completion:nil];
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Post Successful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    
    if ([rootViewController isKindOfClass:[UITabBarController class]])
        navController =(UINavigationController*)[tabBarController selectedViewController];
     else
        navController = self.mainNavigation;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController setInitialText:@"I’ve just used the Caxton FX travel app. Convert currency in a snap of a photo and manage a Caxton FX account on the move. #CaxtonCurrency"];
        
        [navController presentViewController:composeController
                                    animated:YES completion:nil];
        
        [composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            [navController dismissViewControllerAnimated:YES completion:nil];
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Post Successful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    [self.mobileNumNotificationView removeFromSuperview];
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

-(void)callServiceForFetchingHistoryData
{
    NSString *query = [NSString stringWithFormat:@"select CurrencyCardID from myCards"];
    NSMutableArray *currencyIdMA = [kHandler fetchingDataFromTable:query];
    BOOL state = [CommonFunctions reachabiltyCheck];
    if (state)
        [self fetchingHistoryData:currencyIdMA];
}

-(void)fetchingHistoryData:(NSMutableArray *)currencyIdMA
{
    for (int i = 0; i < [currencyIdMA count]; i++)
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

#pragma mark -----
#pragma mark shardemangerDelegate Method

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    if([service isEqualToString:@"GetPromo"])
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
}

-(void)loadingFailedWithError:(NSString *)error  withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]])
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    else
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
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
        CGRect frame = self.topBarView.frame;
        frame.origin.y = startPos.y+translate.y;
        
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
        if (IS_HEIGHT_GTE_568){
            y = -548.0f;
            minScrollY = 180.0f;
        }
        if (translate.y > minScrollY){
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
            [topBarView setFrame:CGRectMake(0, -548, 320, CGRectGetHeight(topBarView.frame))];
        else
            [topBarView setFrame:CGRectMake(0, -460, 320, CGRectGetHeight(topBarView.frame))];
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
        [topBarView setFrame:CGRectMake(0, -548, 320, CGRectGetHeight(topBarView.frame))];
    else
        [topBarView setFrame:CGRectMake(0, -460, 320, CGRectGetHeight(topBarView.frame))];
    
    [UIView commitAnimations];
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

-(void)doLogout
{
    
    NSArray *pathsNew = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [pathsNew objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cfxNew.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"DELETE FROM conversionHistoryTable "];
    [database executeUpdate:@"DELETE FROM getHistoryTable"];
    [database executeUpdate:@"DELETE FROM myCards"];
    [database close];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [documentsDirectory stringByAppendingPathComponent:@"patientPhotoFolder"];
    NSString *dataPath = patientPhotoFolder;
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:dataPath
                           isDirectory:&isDir] && isDir == NO) {
        [fileManager removeItemAtPath:dataPath error:nil];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"khistoryData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"switchState"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstTimeUser"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginAttamp"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"attemp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIButton *tapBtn = (UIButton*)[self.customeTabBar viewWithTag:2];
    [self customTabBarBtnTap:tapBtn];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"stayLogin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UINavigationController *navController = (UINavigationController*)[self.tabBarController selectedViewController];
    NSArray *viewArray = navController.viewControllers;
    BOOL found=NO;
    for (int i=0; i<viewArray.count; i++) {
        if([[viewArray objectAtIndex:i ]isKindOfClass:[HomeVC class]])
        {
            [navController popToViewController:[viewArray objectAtIndex:i] animated:YES];
            found =YES;
            break;
        }
    }
    if (!found) {
        HomeVC *homeViewController = [[HomeVC alloc] init];
        [navController pushViewController:homeViewController animated:YES];
    }
     
}
-(NSInteger )hourSinceNow
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    return hoursBetweenDates;
}
-(NSInteger )minutesSinceNow
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"khistoryData"];
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    double secondsInAnMinute = 60;
    NSInteger minutesBetweenDates = distanceBetweenDates / secondsInAnMinute;
    return minutesBetweenDates;
}
-(NSInteger )minutesSinceNowCardsOnly
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    double secondsInAnMinute = 60;
    NSInteger minutesBetweenDates = distanceBetweenDates / secondsInAnMinute;
    return minutesBetweenDates;
}
-(NSInteger )minutesSinceNowRatesOnly
{
    NSDate* date1 = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updateDateRates"];
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    double secondsInAnMinute = 60;
    NSInteger minutesBetweenDates = distanceBetweenDates / secondsInAnMinute;
    return minutesBetweenDates;
}

//LOCATION BASED TESTS 20/01/2014
-(void)startLocationTracking{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.distanceFilter = 100.0;
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        NSLog(@"cal longitude %f",currentLocation.coordinate.longitude);
        NSLog(@"cal latitude %f", currentLocation.coordinate.latitude);
    }
    [self.locationManager stopUpdatingLocation];
    /*
    NSString *deviceType = [UIDevice currentDevice].model;
    //http://631f3a62.ngrok.com/
    NSString *urlString =[NSString stringWithFormat:@"http://631f3a62.ngrok.com/APNSPhp/locationTrack.php?lat=%f&lon=%f&device=%@",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,deviceType];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    //send it synchronous in a different thread
    [self performSelector:@selector(sendLocation:) withObject:request];
    */
}
-(void)sendLocation: (NSURLRequest*) request{
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // check for an error. If there is a network error, you should handle it here.
    if(!error)
    {
        //log response
        NSLog(@"Response from server = %@", responseString);
    }
}
@end
