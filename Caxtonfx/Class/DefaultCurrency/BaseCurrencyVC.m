//
//  BaseCurrencyVC.m
//  Caxtonfx
//
//  Created by XYZ on 06/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "BaseCurrencyVC.h"
#import "CurrencyTableCell.h"
#import "UIColor+Additions.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@interface BaseCurrencyVC ()

@end

@implementation BaseCurrencyVC

@synthesize searchBar,tableView,allRatesMA,heightConstraint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(UIBarButtonItem *)backButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return leftBtn;
}
- (void)saveBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBtnPressed:(id)sender
{
    for(int i=0;i<self.array.count;i++)
    {
        NSDictionary *dict = [self.array objectAtIndex:i];
        if ([selectedCurrency isEqualToString:[dict objectForKey:@"CcyCode"]])
        {
            selectedRow = i;
            
        }
    }

    
    if ([fromConversionSection isEqualToString:@"YES"])
    {
        
        isCurrencySettingsChanged = TRUE;
        
        NSMutableDictionary *dict = [self.array objectAtIndex:selectedRow];
        NSLog(@"selected row  : %d",selectedRow);
        targetCurrency  = [dict objectForKey:@"CcyCode"];
        NSLog(@"targetCurrency in backbutton event : %@",targetCurrency);
        
    }
    else
    {
               
        NSMutableDictionary *dict = [self.array objectAtIndex:selectedRow];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"CcyCode"] forKey:@"defaultCurrency"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"imageName"] forKey:@"defaultCurrencyImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchText = @"";
    if ([fromConversionSection isEqualToString:@"YES"])
    {
        selectedCurrency = targetCurrency;
        [self setNavigationTitle:@"Convert from:"];
    }
    else
    {
        selectedCurrency =   [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultCurrency"];
        
        [self setNavigationTitle:@"Convert to:"];
    }
    
    NSLog(@"%@",selectedCurrency);
    self.allRatesMA = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *backButton = [self backButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    NSString *query = [NSString stringWithFormat:@"select * from globalRatesTable"];
    self.array = [[NSMutableArray alloc]init];
    self.array = [[DatabaseHandler getSharedInstance] fetchingGlobalRatesFromTable:query];
    self.allRatesMA = [[DatabaseHandler getSharedInstance] fetchingGlobalRatesFromTable:query];
    
    [self.tableView removeConstraint:heightConstraint];
    
    if(IS_HEIGHT_GTE_568)
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:453];
        [self.tableView addConstraint:heightConstraint];
    }else
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:365];
        [self.tableView addConstraint:heightConstraint];
    }
    [self customeSearchBar];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.customeTabBar.hidden = YES;
    for(int i=0;i<self.array.count;i++)
    {
        NSDictionary *dict = [self.array objectAtIndex:i];
        if ([selectedCurrency isEqualToString:[dict objectForKey:@"CcyCode"]])
        {
            selectedRow = i;
            
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.translucent=NO;
    }
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.customeTabBar.hidden = NO;
}

#pragma mark -------
#pragma mark CustomeSearchBar

-(void)customeSearchBar
{
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5,7 , 310, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search for a currency";
    [self.view addSubview:searchBar];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, 320, 1)];
    lineView.backgroundColor = UIColorFromRedGreenBlue(245, 244, 243);
    searchBar.backgroundColor = [UIColor clearColor];
    
    NSArray *searchBarSubViews = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        searchBar.searchTextPositionAdjustment=UIOffsetMake(10, 0);
        searchBarSubViews = [[self.searchBar.subviews objectAtIndex:0] subviews];
        [[searchBarSubViews objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
        [[searchBarSubViews objectAtIndex:0] removeFromSuperview];
    }else{
        searchBarSubViews = searchBar.subviews;
        [[searchBarSubViews objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
        [[searchBarSubViews objectAtIndex:0] removeFromSuperview];
    }
    UITextField *searchField;
    
    for(UIView *subView in searchBarSubViews)
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            searchField = (UITextField *)subView;
            searchField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
            [[searchField placeholder] drawInRect:searchField.frame withFont:[UIFont fontWithName:@"OpenSans-Italic" size:13]];
            searchField.borderStyle = UITextBorderStyleRoundedRect;
            searchField.returnKeyType = UIReturnKeyDone;
        }
    }
    
    if (searchField)
    {
        UIImageView *imageView ;
        imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 18)];
        imageView.image = [UIImage imageNamed:@"srchIcon"];
        searchField.leftViewMode = UITextFieldViewModeNever;
        searchField.rightViewMode = UITextFieldViewModeAlways;
        searchField.rightView = imageView;
    }
    
    for (UIView *searchBarSubview in searchBarSubViews) {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"srchTxtBox"]forState:UIControlStateNormal];
                [(UITextField *)searchBarSubview setBorderStyle:UITextBorderStyleRoundedRect];
            }
            @catch (NSException * e) {
                
            }
        }
    }
}

-(void) setNavigationTitle:(NSString *) title
{
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    //    UIBarButtonItem *saveBtn = [self saveButton];
    //    self.navigationItem.rightBarButtonItem = saveBtn;
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0.0f, 0.0f,200, 44.0f)];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 200,30.0f)];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:title];
    [view addSubview:titleLbl];
    [self.navigationItem setTitleView:view];
}

-(UIBarButtonItem *)saveButton
{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0,0,33,33);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"checkboxSelected"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"checkboxSelectedRed"] forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    return rightBtn;
}


- (NSString*) addCurrencySymbolToCalculatedCurrency:(NSString*) currency
{
    NSString *currencyName = @"";
    
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM currency_table WHERE code_name = '%@'",currency];
        
        NSLog(@"%@",sqlStatement);
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *symbolStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSLog(@"symbol : %@",symbolStr);
                
                if (symbolStr)
                {
                    short symbol = [symbolStr intValue];
                    
                    if (symbol != 0)
                        currencyName = [NSString stringWithFormat:@"%C",symbol];
                    else
                        currencyName = @"";
                }
                else
                    currencyName = @"";
            }
            else
                currencyName = @"";
        }
        else
            currencyName = @"";
        
        sqlite3_finalize(compiledStatement);
        
        sqlite3_close(database);
    }
    
    return  currencyName;
}

#pragma mark -------
#pragma mark UITAbleViewMethod

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectZero];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"currencyCellIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    CurrencyTableCell *cell = [tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[CurrencyTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrencyTableCell"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSMutableDictionary *dict = [self.array objectAtIndex:indexPath.row];
    
    cell.textLbl.text = [[dict objectForKey:@"CcyCode"] stringByAppendingFormat:@"  %@",[self addCurrencySymbolToCalculatedCurrency:[dict objectForKey:@"CcyCode"]]];
    
    if ([selectedCurrency isEqualToString:[dict objectForKey:@"CcyCode"]])
    {
        selectedRow = indexPath.row;
        [cell.radio setImage:[UIImage imageNamed:@"DradioBtnSelected"]];
    }
    else
    {
        [cell.radio setImage:[UIImage imageNamed:@"DradioBtn"]];
    }
    
    UIImage *mask = [UIImage imageNamed:[dict objectForKey:@"imageName"]];
    if (mask)
    {
        cell.flagImageView.backgroundColor = [UIColor clearColor];
    
        mask = [mask resizedImage:CGSizeMake(72, 72) interpolationQuality:kCGInterpolationHigh];
        mask = [mask roundedCornerImage:35.0f borderSize:1];
        cell.flagImageView.image = mask;
    }
    else
    {
        cell.flagImageView.layer.cornerRadius = 18.0f;
        cell.flagImageView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedRow = indexPath.row;
    NSMutableDictionary *dict = [self.array objectAtIndex:indexPath.row];
    NSString *ccy = [dict objectForKey:@"CcyCode"];
    selectedCurrency = ccy;
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-(void)searchingMethod
{
    [self.array removeAllObjects];
    
    NSString *str = searchBar.text;
    
    if (str.length == 0) {
        self.array = [self.allRatesMA mutableCopy];
        [self.tableView reloadData];
    }
    else
    {
        for (NSMutableDictionary *dict in self.allRatesMA) {
            
            NSString *string = [dict objectForKey:@"CcyCode"];
            
            if ([string rangeOfString:[str uppercaseString]].location != NSNotFound)
            {
                [self.array addObject:dict];
            }
        }
        
        [self.tableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    [self searchingMethod];
    
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar resignFirstResponder];
    //    self.array = [self.allRatesMA mutableCopy];
    //    [self.tableView reloadData];
    //    searchBar.text = @"";
    
}



@end
