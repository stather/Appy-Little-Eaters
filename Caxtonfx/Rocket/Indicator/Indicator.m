//
//  Indicator.m
//  cfx
//
//  Created by Ashish Sharma on 25/10/12.
//
//

#import "Indicator.h"
#import "SBJson.h"
#import "Reachability.h"

@implementation Indicator

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        [self setupView];
    }
    
    return self;
}

- (void) setupView
{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(93.0f, 124.0f, 133.0f, 133.0f)];
    [bgImage setBackgroundColor:[UIColor clearColor]];
    [bgImage setImage:[UIImage imageNamed:@"blackTransBg"]];
    [self addSubview:bgImage];
    
    animationImage = [[UIImageView alloc] initWithFrame:CGRectMake(142.0f, 148.0f, 35.0f, 35.0f)];
    [animationImage setBackgroundColor:[UIColor clearColor]];

    //setup custom activity indicator
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 4; i++)
    {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"circle_%d",i]]];
    }
    
    [animationImage setAnimationImages:images];
    [animationImage setAnimationDuration:1.5f];
    [animationImage setAnimationRepeatCount:-1];
    [self addSubview:animationImage];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(108.0f, 208.0f, 105.0f, 25.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont systemFontOfSize:10.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setNumberOfLines:2];
    [titleLbl setTextAlignment:UITextAlignmentCenter];
    [titleLbl setText:@"Checking for the latest exchange rate..."];
    [self addSubview:titleLbl];
}

- (void) startUpdatingRates
{
    //check current network reachability
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach isReachable])
    {
        [animationImage startAnimating];
        
       // [NSThread detachNewThreadSelector:@selector(getLatestCurrencyConversionRates) toTarget:self withObject:nil];
    }
    else
    {
        //call the delegate method
        [self.delegate indicatorDidComplete];
    }
}

//get latest current conversion rates from http://openexchangerates.org
- (void) getLatestCurrencyConversionRates
{
    NSString *urlStr = @"http://openexchangerates.org/api/latest.json?app_id=733837eda00a4b9f9d4287d402dc1ba5";
    
    NSLog(@"currency conversion url = %@",urlStr);
    
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
            
            NSLog(@"conversion rates = %@",ratesDic);
            
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
                
                //call the delegate method
                [self.delegate indicatorDidComplete];
            }
        }
    }
    else
    {
        //call the delegate method
        [self.delegate indicatorDidComplete];
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
    
    if (response)
    {
        
        DatabaseHandler *dbHandler = [[DatabaseHandler alloc] init];
        [dbHandler executeQuery:@"delete from banks_table"];
        
        [dbHandler executeQuery:@"DELETE FROM rates_table"];
        
        NSMutableDictionary *jsonOutput = [response JSONValue];
        
        NSLog(@"banks jsonOutput = %@",jsonOutput);
        
        NSString *timestamp = [jsonOutput objectForKey:@"CRONTIMESTAMP"];
        
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        [defs setObject:timestamp forKey:@"CRONTIMESTAMP"];
        [defs synchronize];
        
        NSMutableArray *banks = [jsonOutput objectForKey:@"Banks"];
        
        NSLog(@"banks jsonOutput = %@",jsonOutput);
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
            NSLog(@"rates : %@",rates);
            
            
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
