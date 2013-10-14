//
//  SplashVC.m
//  cfx
//
//  Created by Ashish on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashVC.h"
#import "ImagePickerVC.h"
#import "SBJson.h"
#import "sqlite3.h"
#import "AppDelegate.h"

@interface SplashVC ()

@end

@implementation SplashVC

@synthesize activityIndicator;
@synthesize currentStatusLbl;
@synthesize updateStatusLabel;
@synthesize customIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //format elements
    [self.currentStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    [self.currentStatusLbl setTextColor:UIColorFromRedGreenBlue(88.0f, 88.0f, 88.0f)];
    
    [self.updateStatusLabel setFont:[UIFont systemFontOfSize:9.0f]];
    [self.updateStatusLabel setTextColor:UIColorFromRedGreenBlue(163.0f, 163.0f, 163.0f)];
    
    //start activity indicator
    [self.activityIndicator startAnimating];
    
    //set current status
    [self.currentStatusLbl setText:@"Checking for network"];
    
    //setup custom activity indicator
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 4; i++)
    {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"circle_%d",i]]];
    }
    
    [customIndicatorView setAnimationImages:images];
    [customIndicatorView setAnimationDuration:1.5];
    [customIndicatorView setAnimationRepeatCount:-1];
    [customIndicatorView startAnimating];
    
    //check network reachability
    [self setupReachability];
}

#pragma mark -
#pragma mark - Methods

//setup rechability
- (void) setupReachability
{
    //set up a notification for change in network reachability
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    
    //check current network reachability
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach isReachable]) 
    {
        //stop activity indicator
        [self.activityIndicator stopAnimating];
        
        //change current status
        [self.currentStatusLbl setText:@"Checking for the latest exchange rate..."];
        
        //set last update date
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([userDefaults objectForKey:@"lastUpdateDate"])
        {
            NSDate *lastUpdateDate = [userDefaults objectForKey:@"lastUpdateDate"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
            [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
            
            NSString *lastUpdateDateStr = [dateFormatter stringFromDate:lastUpdateDate];
            NSLog(@"last Update Date = %@",lastUpdateDateStr);
            
            [self.updateStatusLabel setText:[NSString stringWithFormat:@"Last updated %@",lastUpdateDateStr]];
        }
        
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        
        if ([defs objectForKey:@"CRONTIMESTAMP"])
        {
            double timeStamp = [[defs objectForKey:@"CRONTIMESTAMP"] doubleValue];
            
            NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
            
            if (currentTimeStamp-timeStamp >= 24*60*60)
            {
                //get conversion rates
                [NSThread detachNewThreadSelector:@selector(getLatestCurrencyConversionRates) toTarget:self withObject:nil];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(gotoImagePickerAfterDelayWithMessage:) withObject:@"Exchange rates are upto date" waitUntilDone:YES];
            }
        }
        else
        {
            //get conversion rates
            [NSThread detachNewThreadSelector:@selector(getLatestCurrencyConversionRates) toTarget:self withObject:nil];
        }
    }
    else 
    {
        int tableCount = [self getTableCount:@"converion_rate_table"];
        
        if (tableCount > 0)
        {
            [self performSelectorOnMainThread:@selector(gotoImagePickerAfterDelayWithMessage:) withObject:@"No network available" waitUntilDone:YES];
        }
        else
        {
            //set network not available status
            [self.currentStatusLbl setText:@"No network available"];
            
            //stop activity indicator
            [self.activityIndicator stopAnimating];
        }
    }
    
    [reach startNotifier];
}

- (void) gotoImagePickerAfterDelayWithMessage:(NSString*) statusMsg
{
    //set network not available status
    [self.currentStatusLbl setText:statusMsg];
    
    //stop activity indicator
    [self.customIndicatorView stopAnimating];
    
    //set last update date
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"lastUpdateDate"])
    {   
        NSDate *lastUpdateDate = [userDefaults objectForKey:@"lastUpdateDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
        [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
        
        NSString *lastUpdateDateStr = [dateFormatter stringFromDate:lastUpdateDate];
        NSLog(@"last Update Date = %@",lastUpdateDateStr);
        
        [self.updateStatusLabel setText:[NSString stringWithFormat:@"Last updated %@",lastUpdateDateStr]];
    }
    
    [self performSelector:@selector(gotoImagePicker) withObject:nil afterDelay:3.0f];
}

//handle change in network rechability
- (void) reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {        
        NSLog(@"NetWork is Available");
    }
    else
    {
        NSLog(@"NetWork is not Available");
    }
}

//get latest current conversion rates from http://openexchangerates.org
- (void) getLatestCurrencyConversionRates
{
    NSString *urlStr = @"http://openexchangerates.org/api/latest.json?app_id=733837eda00a4b9f9d4287d402dc1ba5";

    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:0 timeoutInterval:60];
    
    NSURLResponse *urlResponse=nil;
    
    NSError* error=nil;
    
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"currency conversion url response = %@",response);
    
    if (response && [response length] > 0)
    {
        NSDictionary *jsonOutput = [response JSONValue];
        
        if ([jsonOutput count] > 0)
        {
            NSDictionary *ratesDic = [jsonOutput objectForKey:@"rates"];
            
            NSArray *allKeys = [ratesDic allKeys];
            
            if ([allKeys count] > 0)
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSDate date] forKey:@"lastUpdateDate"];
                [userDefaults synchronize];
                
                sqlite3 *database;
                
                NSString *sqlStatement = @"";
                
                if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
                {
                    sqlStatement = @"DELETE FROM converion_rate_table";
                    
                    NSLog(@"%@",sqlStatement);
                    
                    if (sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
                    {
                        NSLog(@"record deleted successfully!!");
                        NSLog(@"%@",DatabasePath);
                    }
                    
                    sqlite3_close(database);
                }
                
                for (int i = 0; i < [allKeys count]; i++)
                {
                    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
                    {
                        NSString *key = [allKeys objectAtIndex:i];
                        
                        float mutiplier = [[ratesDic objectForKey:key] floatValue];
                        NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
                        [nf setPositiveFormat:@"0.##"];
                        
                        sqlStatement = [NSString stringWithFormat:@"insert into converion_rate_table (currency_code,multiplier) values ('%@','%@') ",key,[nf stringFromNumber:[NSNumber numberWithFloat:mutiplier]]];
                        
                        NSLog(@"%@",sqlStatement);
                        
                        if (sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
                        {
                            NSLog(@"record inserted successfully!!");
                            NSLog(@"%@",DatabasePath);
                        }
                        
                        sqlite3_close(database);
                    }
                }
                
                [self fetchingBanksToDisplay];
                
                [self performSelectorOnMainThread:@selector(gotoImagePicker) withObject:nil waitUntilDone:YES];
            }
        }
    }
    else
    {
        int tableCount = [self getTableCount:@"converion_rate_table"];
        
        if (tableCount > 0)
        {
            [self performSelectorOnMainThread:@selector(gotoImagePicker) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self getLatestCurrencyConversionRates];
        }
    }
}

//fetch banks detail from server
- (void) fetchingBanksToDisplay
{
    NSURL *url = [NSURL URLWithString:@"http://php4.konstantwork.com/snapx/banks/getbankjson"];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:60];
    
    NSURLResponse *urlResponse=nil;
    
    NSError* error=nil;
    
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"banks response = %@",response);
    
    DatabaseHandler *dbHandler = [[DatabaseHandler alloc] init];
    
    [dbHandler executeQuery:@"delete from banks_table"];
    
    [dbHandler executeQuery:@"DELETE FROM rates_table"];
    
    if (response && [response length] > 0)
    {
        NSMutableDictionary *jsonOutput = [response JSONValue];
        
        NSLog(@"banks jsonOutput = %@",jsonOutput);
        
        NSString *timestamp = [jsonOutput objectForKey:@"CRONTIMESTAMP"];
        
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        [defs setObject:timestamp forKey:@"CRONTIMESTAMP"];
        [defs synchronize];
        
        NSMutableArray *banks = [jsonOutput objectForKey:@"Banks"];
        
        for (int i = 0; i < [banks count]; i++)
        {
            NSMutableDictionary *dict = [banks objectAtIndex:i];
            NSString *ID = [dict objectForKey:@"id"];
            NSString *institution_name = [dict objectForKey:@"institution_name"];
            NSString *Country = [dict objectForKey:@"Country"];
            NSString *base = [dict objectForKey:@"base"];
            NSString *conversion_fee = [dict objectForKey:@"conversion_fee"];
            NSString *logo = [dict objectForKey:@"logo"];
            NSString *one_off_fee = [dict objectForKey:@"one_off_fee"];
            NSString *product_name = [dict objectForKey:@"product_name"];
            NSString *timestamp = [dict objectForKey:@"timestamp"];
            NSString *transaction_fee = [dict objectForKey:@"transaction_fee"];
            NSString *account_id = [dict objectForKey:@"account_id"];
            
            NSMutableDictionary *rates = [dict objectForKey:@"rates"];
            
            NSString *query = [NSString stringWithFormat:@"insert into banks_table (id,institution_name,product_name,transaction_fee,conversion_fee,one_off_fee,account_id,Country,logo,base,timestamp,is_selected) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','0')",ID,institution_name,product_name,transaction_fee,conversion_fee,one_off_fee,account_id,Country,logo,base,timestamp];
            [dbHandler executeQuery:query];
        
            NSArray *allKeys = [rates allKeys];
            
            for (int i = 0; i < [allKeys count]; i++)
            {
                NSString *key = [allKeys objectAtIndex:i];
                
                query = [NSString stringWithFormat:@"insert into rates_table (bank_id,currency_code,multiplier) values (%@,'%@','%@')",ID,key,[rates objectForKey:key]];
                [dbHandler executeQuery:query];
               
                
            }  
        }
    }
}

//push image picker for capturing image
- (void) gotoImagePicker
{
    //push image picker
    ImagePickerVC *ipvc = [[ImagePickerVC alloc] init];
    [self.navigationController pushViewController:ipvc animated:TRUE];
    
    AppDelegate *appDelegate = [AppDelegate getSharedInstance];
    [appDelegate performSelector:@selector(checkAndShowRateAppAlert) withObject:nil afterDelay:0.5f];
}

- (int) getTableCount:(NSString*) tableName
{
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
    NSString *count = @"0";
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",tableName];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            }
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(compiledStatement);
        
        sqlite3_close(database);
    }
    
    return [count intValue];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
