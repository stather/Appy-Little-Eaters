//
//  LogoutTableCell.m
//  demoCfx
//
//  Created by Sumit on 17/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "LogoutTableCell.h"
#import "UIColor+Additions.h"
#import "AppDelegate.h"
#import "HomeVC.h"
#import "FMDatabase.h"

@implementation LogoutTableCell

@synthesize lbl,btn,view,logoutView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"CustomCellIdentifier";
}


#pragma mark --------
#pragma mark IBAction Method

-(IBAction)logoutBtnPressed:(id)sender
{
    NSLog(@"logoutBtnPressed");
    [btn setBackgroundImage:[UIImage imageNamed:@"logoutBtn1"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"logoutBtnHover"] forState:UIControlStateHighlighted];
    
    UILabel *logoutLbl = (UILabel*)[self.logoutView viewWithTag:1];
    logoutLbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:16];
    
    UILabel *textLable = (UILabel*)[self.view viewWithTag:2];
    
    textLable.font = [UIFont fontWithName:@"OpenSans" size:14];
    textLable.textColor = UIColorFromRedGreenBlue(255, 255, 255);
    
    [self.superview.superview addSubview:logoutView];

    if(IS_HEIGHT_GTE_568)
    {
         [logoutView setFrame:CGRectMake(11, 105, 298, 245)];
    }else{
        [logoutView setFrame:CGRectMake(11, 61, 298, 245)];
    }

}

-(IBAction)cancelBtnPressed:(id)sender
{
    [logoutView removeFromSuperview];

}

-(IBAction)logoutAlertBtnPressed:(id)sender
{
    /*
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
    
    [logoutView removeFromSuperview];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIButton *tapBtn = (UIButton*)[appDelegate.customeTabBar viewWithTag:2];
    [appDelegate customTabBarBtnTap:tapBtn];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"stayLogin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    
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
     */
    [logoutView removeFromSuperview];
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate doLogout];
    
}


@end
