//
//  CurrencyPickerVC.m
//  cfx
//
//  Created by Ashish on 04/09/12.
//
//

#import "CurrencyPickerVC.h"
#import "sqlite3.h"

@interface CurrencyPickerVC ()

@end

@implementation CurrencyPickerVC

@synthesize headingLbl;
@synthesize subHeadingLbl;
@synthesize pickerView;
@synthesize pickerType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //hide back button
    [self.navigationItem setHidesBackButton:TRUE];
    
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont systemFontOfSize:20.0f]];
    [titleLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
    [titleLbl setShadowColor:[UIColor whiteColor]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    
    //check for picker type
    if (pickerType == 1) //preferredCurrency
    {
        [titleLbl setText:@"Preferred Currency"];
        [subHeadingLbl setText:@"Please select the currency you would like to convert to."];
    }
    else if (pickerType == 2) //targetCurrency
    {
        [titleLbl setText:@"Target Currency"];
        [subHeadingLbl setText:@"Please select the currency you would like to convert from."];
    }
    [self.navigationItem setTitleView:titleLbl];
    
    HUD               = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate      = self;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(fetchCurrenciesFromDatabase) onTarget:self withObject:nil animated:YES];
}

#pragma mark -
#pragma mark - IBActions

- (IBAction) cancelBtnTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction) doneBtnTap:(id)sender
{
    NSMutableDictionary *dic;
    
    if (pickerType == 1) //preferredCurrency
    {
        preferredCurrency = nil;
        
        if ([recentCurrencyArray count]>0)
        {
            if ([pickerView selectedRowInComponent:0]<[recentCurrencyArray count])
            {
                dic = [recentCurrencyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            }
            else
            {
                dic = [currencyArray objectAtIndex:[pickerView selectedRowInComponent:0]-[recentCurrencyArray count]];
            }
        }
        else
        {
            dic = [currencyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        }
        
        preferredCurrency = [dic objectForKey:@"code"];
        
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        
        [userDefs setObject:[dic objectForKey:@"code"] forKey:@"preferredCurrency"];
        [userDefs synchronize];
    }
    else if (pickerType == 2) //targetCurrency
    {
        targetCurrency = nil;
        
        if ([recentCurrencyArray count]>0)
        {
            if ([pickerView selectedRowInComponent:0]<[recentCurrencyArray count])
            {
                dic = [recentCurrencyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            }
            else
            {
                dic = [currencyArray objectAtIndex:[pickerView selectedRowInComponent:0]-[recentCurrencyArray count]];
            }
        }
        else
        {
            dic = [currencyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        }
        
        targetCurrency = [dic objectForKey:@"code"];
    }
    
    //update time stamp
    [self updateTimeStampForCurrencyId:[dic objectForKey:@"id"]];
    
    isCurrencySettingsChanged = TRUE;
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void) updateTimeStampForCurrencyId:(NSString *) ID
{
    sqlite3 *database;
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"UPDATE currency_table SET timestamp = %.0f WHERE id = %@",[[NSDate date] timeIntervalSince1970],ID];
        
    if (sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"record updated successfully!!");
            NSLog(@"%@",DatabasePath);
        }
        
        sqlite3_close(database);
    }
}

- (void) fetchCurrenciesFromDatabase
{
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
    currencyArray = nil;
    currencyArray = [[NSMutableArray alloc] init];
    
    recentCurrencyArray = nil;
    recentCurrencyArray = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        //fetch recent currencies
        sqlStatement = @"SELECT * FROM currency_table WHERE timestamp != 0 ORDER BY timestamp DESC";
        sqlite3_stmt *compStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(compStatement) == SQLITE_ROW)
            {
                NSString *currencyID = [NSString stringWithFormat:@"%d",sqlite3_column_int(compStatement, 0)];
                NSString *currencyName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compStatement, 1)];
                NSString *codeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compStatement, 2)];
                NSString *currencySymbol = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compStatement, 3)];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:currencyID,@"id",currencyName,@"name",codeName,@"code",currencySymbol,@"symbol",nil];
                
                [recentCurrencyArray addObject:dic];
                
                if ([recentCurrencyArray count] == 5)
                    break;
            }
            
        }
        
        sqlite3_finalize(compStatement);
        
        sqlStatement = @"select * FROM currency_table ORDER BY name ASC";
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *currencyID = [NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement, 0)];
                NSString *currencyName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *codeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *currencySymbol = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:currencyID,@"id",currencyName,@"name",codeName,@"code",currencySymbol,@"symbol",nil];
                
                [currencyArray addObject:dic];
            }
            
        }
        sqlite3_finalize(compiledStatement);
        
        sqlite3_close(database);
    }
}

#pragma mark -
#pragma mark PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [recentCurrencyArray count] + [currencyArray count];
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *currency;
    
    if ([recentCurrencyArray count] > 0) //recent currencies
    {
        NSMutableDictionary *dic;
        
        if (row < [recentCurrencyArray count])
        {
            dic = [recentCurrencyArray objectAtIndex:row];
        }
        else
        {
            dic = [currencyArray objectAtIndex:row-[recentCurrencyArray count]];
        }
        
        NSString *symbol = [dic objectForKey:@"symbol"];
        
        if (symbol.length > 0)
            currency = [NSString stringWithFormat:@"%@ %C",[dic objectForKey:@"name"],(unichar)[[dic objectForKey:@"symbol"] intValue]];
        else
            currency = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    else
    {
        NSMutableDictionary *dic = [currencyArray objectAtIndex:row];
        
        NSString *symbol = [dic objectForKey:@"symbol"];
        
        if (symbol.length > 0)
            currency = [NSString stringWithFormat:@"%@ %C",[dic objectForKey:@"name"],(unichar)[[dic objectForKey:@"symbol"] intValue]];
        else
            currency = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    
    return currency;
}

#pragma mark - 
#pragma mark - MBProgressHUD Delegate

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    
    [pickerView reloadAllComponents];
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
