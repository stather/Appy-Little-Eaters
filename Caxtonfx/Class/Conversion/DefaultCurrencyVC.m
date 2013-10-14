//
//  DefaultCurrencyVC.m
//  DemoApp
//
//  Created by Amzad on 10/8/12.
//  Copyright (c) 2012 konstant. All rights reserved.
//

#import "DefaultCurrencyVC.h"
#import "DefaultCurrencyCustomCell.h"


@interface DefaultCurrencyVC ()

@end

@implementation DefaultCurrencyVC

@synthesize bottomView;
@synthesize table;
@synthesize currencyArray;
@synthesize receiptsButton;
@synthesize captureButton;
@synthesize settingsButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizingNavigationBar];
    
    [navigationTitle setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:20.0f]];
    
    HUD               = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate      = self;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(fetchCurrenciesFromDatabase) onTarget:self withObject:nil animated:YES];
}

-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    
    /****** add custom left bar button (Back to history Button) at navigation bar  **********/
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    //add right bar button item
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 62.0f, 30.0f)];
    [saveBtn setImage:[UIImage imageNamed:@"save_but"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"save_but_hover"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(122, 20, 320, 44)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 5.0f, 210.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:@"Preferred Currency"];
    [titleLbl.layer setShadowRadius:1.0f];
    [titleLbl.layer setShadowColor:[[UIColor colorWithRed:176.0f/255.0f green:19.0f/255.0f blue:25.0f/255.0f alpha:1.0f] CGColor]];
    [titleLbl.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [titleLbl.layer setShadowOpacity:1.0f];
    [titleLbl setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:titleLbl];
    
    [self.navigationItem setTitleView:titleView];

}

- (void) fetchCurrenciesFromDatabase
{
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
    currencyArray = nil;
    currencyArray = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement = @"SELECT * FROM currency_table GROUP BY code_name ORDER BY name ASC";
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *currencyName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *codeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *currencySymbol = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:currencyName,@"name",codeName,@"code",currencySymbol,@"symbol",nil];
                
                [currencyArray addObject:dic];
            }
        }
        
        sqlite3_finalize(compiledStatement);
        
        sqlite3_close(database);
    }

    for (int i = 0; i < [currencyArray count]; i++)
    {
        NSMutableDictionary *dic = [currencyArray objectAtIndex:i];
        
        if ([[dic objectForKey:@"code"] isEqualToString:preferredCurrency])
        {
            selectedRow = i;
        }
    }
}

#pragma mark -
#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;// [currencyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"currencyCellIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    DefaultCurrencyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // If no cell is available, create a new one using the given identifier.

    if (cell == nil)
    {
        // Use the default cell style.
        cell = [[DefaultCurrencyCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DefaultCurrencyCustomCell"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    
    [tableView reloadData];
}

-(IBAction)backButtonTouched:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) saveButtonTap:(id) sender
{
    NSMutableDictionary *dic = [currencyArray objectAtIndex:selectedRow];
    
    preferredCurrency = nil;
    preferredCurrency = [dic objectForKey:@"code"];
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:[dic objectForKey:@"code"] forKey:@"preferredCurrency"];
    [userDefs synchronize];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - MBProgressHUD Delegate

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    
    [table reloadData];
}

- (void)viewDidUnload
{
    [self setReceiptsButton:nil];
    [self setCaptureButton:nil];
    [self setSettingsButton:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


@end
