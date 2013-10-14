//
//  TargetCurrencyVC.m
//  Caxtonfx
//
//  Created by Nishant on 20/06/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "TargetCurrencyVC.h"
#import "CurrencyTableCell.h"
#import "UIColor+Additions.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@interface TargetCurrencyVC ()

@end

@implementation TargetCurrencyVC

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

-(void)viewWillAppear:(BOOL)animated
{
    if ([preferredCurrency length] == 0)
        status = NO;
    else
        status = YES;
    
}

- (void)backBtnPressed:(id)sender
{
    if (!status)
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"Please save currency for conversion" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if ([preferredCurrency length] !=0) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"Please select currency for conversion" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    
}

- (void)saveBtnPressed
{
    if ([preferredCurrency length] != 0)
    {
        isCurrencySettingsChanged = TRUE;
        NSMutableDictionary *dict = [self.array objectAtIndex:selectedRow];
        preferredCurrency  = [dict objectForKey:@"CcyCode"];
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"Please select currency for conversion" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)viewDidLoad
{
    //
    [super viewDidLoad];
    searchText = @"";
    selectedCurrency = preferredCurrency;
    
    self.allRatesMA = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [self backButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    UIBarButtonItem *saveBtn = [self saveButton];
//    self.navigationItem.rightBarButtonItem = saveBtn;
    
    [self setNavigationTitle:@"Convert to:"];
    
    NSString *query = [NSString stringWithFormat:@"select * from globalRatesTable"];
    
    self.array = [[NSMutableArray alloc]init];
    self.array = [[DatabaseHandler getSharedInstance] fetchingGlobalRatesFromTable:query];
    self.allRatesMA = [self.array mutableCopy];
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
    
    [[[searchBar subviews] objectAtIndex:0] removeFromSuperview];
    [[[searchBar subviews] objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
    
    UITextField *searchField;
    for(UIView *subView in searchBar.subviews)
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
        searchField.rightView = imageView;
        searchField.leftViewMode = UITextFieldViewModeNever;
        searchField.rightViewMode = UITextFieldViewModeAlways;
        
    }
    for (UIView *searchBarSubview in [searchBar subviews]) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"target array  : %@",self.array);
    return [self.array count]+1;
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
    // If no cell is available, create a new one using the given identifier.
    
    cell = [[CurrencyTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrencyTableCell"
                                                 owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    if (indexPath.row == 0)
    {
        cell.textLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrency"];
        cell.textLbl.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrency"] stringByAppendingFormat:@"  %@",[self addCurrencySymbolToCalculatedCurrency:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrency"]]];
        NSString *imageNamestr = [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultCurrencyImage"];
        UIImage *mask = [UIImage imageNamed:imageNamestr];
        
        if (mask)
        {
            cell.flagImageView.backgroundColor = [UIColor clearColor];
            mask = [mask resizedImage:CGSizeMake(72, 72) interpolationQuality:kCGInterpolationHigh];
            mask = [mask roundedCornerImage:36.0f borderSize:1];
            cell.flagImageView.image = mask;
        }
        else
        {
            cell.flagImageView.layer.cornerRadius = 18.0f;
            cell.flagImageView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        }
        
        [cell.radio setHidden:YES];

        UIView *v = [[UIView alloc] initWithFrame:cell.frame];
        [v setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        cell.backgroundView = v;
    }
    else
    {
        NSMutableDictionary *dict = [self.array objectAtIndex:indexPath.row-1];
        NSLog(@"%@",dict);
         cell.textLbl.text = [[dict objectForKey:@"CcyCode"] stringByAppendingFormat:@"  %@",[self addCurrencySymbolToCalculatedCurrency:[dict objectForKey:@"CcyCode"]]];
        
         if ([selectedCurrency isEqualToString:[dict objectForKey:@"CcyCode"]])
        {
            selectedRow = indexPath.row-1;
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
            mask = [mask roundedCornerImage:36.0f borderSize:1];
            cell.flagImageView.image = mask;
        }
        else
        {
            cell.flagImageView.layer.cornerRadius = 18.0f;
            cell.flagImageView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        }
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        selectedRow = indexPath.row-1;
        NSMutableDictionary *dict = [self.array objectAtIndex:indexPath.row-1];
        NSString *ccy = [dict objectForKey:@"CcyCode"];
        
        selectedCurrency = ccy;
        
        [tableView reloadData];
        
        [self saveBtnPressed];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSLog(@"searchText - %@",searchText);
    if (text.length == 0) {
        searchText = [searchText substringToIndex:searchText.length-1];
    }
    else
    {
        if (![text isEqualToString:@"\n"])
        {
            searchText = [searchText stringByAppendingString:text];
        }
    }
   NSLog(@"searchText 2  - %@",searchText);
    NSLog(@"array  - %@",self.array); 
   [self.array removeAllObjects];
    if (searchText.length == 0)
    {
        self.array = [self.allRatesMA mutableCopy];
        NSLog(@"array  - %@",self.array); 
        [self.tableView reloadData];
    }
    else
    {
        for (NSMutableDictionary *dict in self.allRatesMA)
        {
            NSString *string = [dict objectForKey:@"CcyCode"];
            NSLog(@"--%@--",string);
            NSLog(@"--%@--",[searchText uppercaseString]);
            
            NSLog(@"[string rangeOfString:[searchText uppercaseString]].location  = %d",[string rangeOfString:[searchText uppercaseString]].location);
            if ([string rangeOfString:[searchText uppercaseString]].location != NSNotFound)
            {
                [self.array addObject:dict];
            }
        }
        [self.tableView reloadData];
    }
    NSLog(@"array  - %@",self.array);
    
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
   // self.array = [self.allRatesMA mutableCopy];
   // [self.tableView reloadData];
   // searchBar.text = @"";
    
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

@end
