//
//  CommonFunctions.m
//  WhatzzApp
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "CommonFunctions.h"
#import "AppDelegate.h"
#import "Config.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/xattr.h>

@implementation CommonFunctions

+ (NSString *)documentsDirectory {
    NSArray *paths =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
										NSUserDomainMask,
										YES);
    return [paths objectAtIndex:0];
    
    //comment from Amzad
}

+ (void)openEmail:(NSString *)address {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openPhone:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openSms:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openBrowser:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openMap:(NSString *)address {
	NSString *addressText = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


+ (void) hideTabBar:(UITabBarController *) tabbarcontroller {
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			view.hidden = TRUE;
        }
		else
		{
            view.hidden = FALSE;
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 2000)];
        }
    }
	
    [UIView commitAnimations];
}

+ (void) showTabBar:(UITabBarController *) tabbarcontroller {
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			[view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
			
        }
		else
		{
			[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
	
    [UIView commitAnimations];
}


+(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:DatabasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *DatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DatabaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:DatabasePathFromApp toPath:DatabaseName error:nil];
}


//+(void) setNavigationTitle:(NSString *) title ForNavigationItem:(UINavigationItem *) navigationItem
//{
//    float width = 320.0f;
//    
//    if (navigationItem.leftBarButtonItem.customView && navigationItem.rightBarButtonItem.customView)
//    {
//        width = 320 - (navigationItem.leftBarButtonItem.customView.frame.size.width+navigationItem.rightBarButtonItem.customView.frame.size.width);
//    }
//    else if (navigationItem.leftBarButtonItem.customView && !navigationItem.rightBarButtonItem.customView)
//    {
//        width = 320 - (navigationItem.leftBarButtonItem.customView.frame.size.width*2);
//    }
//    else if (!navigationItem.leftBarButtonItem.customView && !navigationItem.rightBarButtonItem.customView)
//    {
//        width = 320 - (2*navigationItem.rightBarButtonItem.customView.frame.size.width);
//    }
//    
//    // find the text width; so that btn width can be calculate
//    CGSize textSize = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]
//                        constrainedToSize:CGSizeMake(320.0f, 32.0f)
//                            lineBreakMode:NSLineBreakByWordWrapping];
//    
//    if (textSize.width < width)
//        width = textSize.width;
//    
//	UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f, width, 44.0f)];
//	
//	UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 6.0f, width,32.0f)];
//    
//    [titleLbl setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
//    
//    [titleLbl setBackgroundColor:[UIColor clearColor]];
//    [titleLbl setTextAlignment:NSTextAlignmentCenter];
//    
//	[titleLbl setTextColor:[UIColor whiteColor]];
//    [titleLbl setShadowColor:[UIColor blackColor]];
//    [titleLbl setShadowOffset:CGSizeMake(0.0f, -1.0f)];
//    
//    [titleLbl setText:title];
//    
//	[view addSubview:titleLbl];
//	
//    [navigationItem setTitleView:view];
//}


+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg withDelegate:(id)delegate{
    [[[UIAlertView alloc] initWithTitle:aTitle
                                message:aMsg
                               delegate:delegate
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg{
    [self alertTitle:aTitle withMessage:aMsg withDelegate:nil];
}


+ (BOOL)isValueNotEmpty:(NSString*)aString{
    if (aString == nil || [aString length] == 0){
        [CommonFunctions alertTitle:@"Server Response Error"
                        withMessage:@"Please try again, server is not responding."];
        return NO;
    }
    return YES;
}

+ (void)showServerNotFoundError{
    [CommonFunctions alertTitle:@"Server Not Found"
                    withMessage:@"Please try again"];
}


+ (BOOL)isRetineDisplay{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return YES;
    } else {
        // not Retine display
        return NO;
    }
}
+ (BOOL)isRetineDisplayForBoth{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
        if(IS_IPAD)
        {
            resloutionType = @"4";
        }
        
        else
        {
            resloutionType = @"2";
        }
        return YES;
    }
    else
    {
        if(IS_IPAD)
        {
            resloutionType = @"3";
        }
        
        else
        {
            resloutionType = @"1";
        }
        
        return NO;
    }
}

+ (NSString*) getImageNameForName:(NSString*) name
{
    NSString *imgName = [NSString stringWithFormat:IS_IPAD?@"%@_iPad.png":@"%@.png",name];
    return imgName;
}

+ (NSString*) getNibNameForName:(NSString*) name
{
    NSString *nibName = [NSString stringWithFormat:IS_IPAD?@"%@_iPad":@"%@",name];
    
    return nibName;
}

+ (void) showAlertWithInfo:(NSDictionary*) infoDic
{
    int tag = 0;
    
    if ([infoDic objectForKey:@"tag"])
        tag = [[infoDic objectForKey:@"tag"] intValue];
    
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:[infoDic objectForKey:@"title"]
                               message:[infoDic objectForKey:@"message"]
                              delegate:[infoDic objectForKey:@"delegate"]
                     cancelButtonTitle:[infoDic objectForKey:@"cancel"]
                     otherButtonTitles:[infoDic objectForKey:@"other"],nil];
    [alertView setTag:tag];
    [alertView show];
}

#pragma mark
#pragma mark ReachabiltyCheck methods

+(BOOL) reachabiltyCheck
{
    NSLog(@"reachabiltyCheck");
    BOOL status =YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    //NSLog(@"status : %d",[reach currentReachabilityStatus]);
    
    if([reach currentReachabilityStatus]==0)
    {
        status = NO;
        //NSLog(@"network not connected");
    }
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // blockLabel.text = @"Block Says Reachable";
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //  blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
    return status;
}

+(BOOL)reachabilityChanged:(NSNotification*)note
{
    BOOL status =YES;
    //NSLog(@"reachabilityChanged");
    
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //notificationLabel.text = @"Notification Says Reachable"
        status = YES;
        //NSLog(@"NetWork is Available");
    }
    else
    {
        status = NO;
        /*
         CustomAlert *alert=[[CustomAlert alloc]initWithTitle:@"There was a small problem" message:@"The network doesn't seem to be responding, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         */
    }
    return status;
}

+ (BOOL) connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
    
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

+(void) setNavigationTitle:(NSString *) title ForNavigationItem:(UINavigationItem *) navigationItem
{    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f, 230, 44.0f)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 230,30.0f)];
    
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:title];
    [view addSubview:titleLbl];
    [navigationItem setTitleView:view];
}


+(UIBarButtonItem *)backButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return leftBtn;

}


+ (void)backBtnPressed:(id)sender
{       AppDelegate *app =(AppDelegate*) [[UIApplication sharedApplication]delegate];
    UITabBarController *tabbarcontroller = app.tabBarController;
    UINavigationController *navController = (UINavigationController*)[tabbarcontroller selectedViewController];
    //NSLog(@"controllers  : %@",navController.viewControllers);
    
    [navController popViewControllerAnimated:YES];
    
    
}

#pragma mark -
#pragma mark - Other Methods
//add alert like animation

+ (CAKeyframeAnimation *) attachPopUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .5;
    return animation;
}


+(NSString *)statusOfLastUpdate:(NSDate *)dateHis
{
    // The time interval
    NSTimeInterval theTimeInterval ;//= hour*3600;

    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    //NSDate *date1 = [[NSDate alloc] init];
    NSDate *date1 = [NSDate date];
    
    theTimeInterval = [date1 timeIntervalSinceDate:dateHis];
    //NSLog(@"timeinterval : %f",theTimeInterval);
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:[NSDate date]];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    //NSLog(@"Break down: %d min : %d hours : %d days : %d months",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
    
    // edit by Sumit mundra
    
    NSInteger timeInMins = [breakdownInfo month]*30*24*60+[breakdownInfo day] *24*60 +[breakdownInfo hour] * 60 + [breakdownInfo minute];
    
   // NSString *weekdayString = [[[NSDateFormatter alloc] weekdaySymbols] objectAtIndex:[breakdownInfo day]];
    
    NSString *string = @"";
    
    int min = [breakdownInfo minute];//hour*60;
    if (timeInMins < 2) {
        string = @"About a minute ago";
    }
    else if(timeInMins >2 && timeInMins < 60) {
        string = [NSString stringWithFormat:@"%d minutes ago",min];
    }
    else if(timeInMins >60 && timeInMins < 120) {
        string = [NSString stringWithFormat:@"About an hour ago"];
    }
    else if(timeInMins >120 && timeInMins < 24*60) {
        string = [NSString stringWithFormat:@"%d hours ago",[breakdownInfo hour]];
    }
    else if(timeInMins >24*60 && timeInMins < 48*60) {
        string = [NSString stringWithFormat:@"Yesterday"];
    }
    else
    {
        // edit by sumit
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"EEEE"];
        //NSLog(@"[dateFormatter stringFromDate:date2]  ->%@", [dateFormatter stringFromDate:date2]);
        
        string = [NSString stringWithFormat:@"On %@",[dateFormatter stringFromDate:date2]];
    }
    NSString *finalStr = [@"Last updated: " stringByAppendingString:string];
    return finalStr;
}

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    if (&NSURLIsExcludedFromBackupKey == nil)
    { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
        return result == 0;
    }
    else
    { // iOS >= 5.1
        
        
        NSError *error = nil;
        
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
        
        if(!success)
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
        return success;;
    }
}

@end
