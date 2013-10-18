//
//  BanksVC.m
//  cfx
//
//  Created by Nishant on 10/11/12.
//
//

#import "BanksVC.h"
#import "SBJson.h"
#import "DatabaseHandler.h"
#import "SettingVC.h"

@interface BanksVC ()

@end

@implementation BanksVC

@synthesize bottomView;
@synthesize table;
@synthesize banksArray;
@synthesize receiptsButton;
@synthesize captureButton;
@synthesize settingsButton;
@synthesize addOrRemoveBank;

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
    [self customizingNavigationBar];
    
    _tempMA = [[NSMutableArray alloc] init];
    [navigationTitle setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:20.0f]];
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
    view.delegate = self;
    [self.table addSubview:view];
    _refreshHeaderView = view;
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    HUD               = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate      = self;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(fetchingBanksToDisplay) onTarget:self withObject:nil animated:YES];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *states= @"";
    for (int i=0; i< [banksArray count]; i++)
    {
        NSMutableDictionary *temp = [banksArray objectAtIndex:i];
        
        if ([[temp objectForKey:@"isSelected"] isEqualToString:@"1"])
        {
            states = [states stringByAppendingFormat:@"%@,",[temp objectForKey:@"id"]];
            
            DatabaseHandler *dbHandler = [[DatabaseHandler alloc] init];
            NSString *query = [NSString stringWithFormat:@"UPDATE banks_table set is_selected = '1' WHERE id=%@",[temp objectForKey:@"id"]];
            [dbHandler executeQuery:query];
        }
        else
        {
            DatabaseHandler *dbHandler = [[DatabaseHandler alloc] init];
            NSString *query = [NSString stringWithFormat:@"UPDATE banks_table set is_selected = '0' WHERE id=%@",[temp objectForKey:@"id"]];
            [dbHandler executeQuery:query];
        }
    }
    
    if ([states length]>0)
    {
        states = [states substringToIndex:states.length - 1];
        NSLog(@"states : %@",states);
        [[NSUserDefaults standardUserDefaults] setObject:states forKey:@"selectedBanks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selectedBanks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)fetchingBanksToDisplay
{
    DatabaseHandler *dbHAndler =[[DatabaseHandler alloc] init];
    indexIs = 0;
    banksArray = [NSMutableArray new];
    banksArray = [dbHAndler fetchingBanksDetailsFromTable:@"select * from banks_table"];
    
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    
    //hide back btn
    [self.navigationItem setHidesBackButton:TRUE];
    
    //add let bar button item
    UIButton *backBtn = [[UIButton alloc] initWithFrame:addOrRemoveBank?CGRectMake(0.0f, 0.0f, 51.0f, 30.0f):CGRectMake(0.0f, 0.0f, 66.0f, 30.0f)];
    [backBtn setBackgroundImage:[UIImage imageNamed:addOrRemoveBank?@"back_but":@"settingBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:addOrRemoveBank?@"back_but_hover":@"settingBtnHover"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont systemFontOfSize:20.0f]];
    [titleLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
    [titleLbl setText:@"My Banks"];
    [titleLbl setShadowColor:[UIColor whiteColor]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLbl];
    
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
    
    return [banksArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"scoreListing";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil)
    {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        // Adding Source Currency Label On Cell
        
        UILabel *banksLabel = [[UILabel alloc]initWithFrame:CGRectMake(11.0f, 12, 80.0f,20.0f)];
        [banksLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
        [banksLabel setBackgroundColor:[UIColor clearColor]];
        [banksLabel setTextColor:[UIColor blackColor]];//UIColorFromRedGreenBlue(160, 160, 160)];
        [banksLabel setTag:1];
        banksLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:banksLabel];
        
        // Adding choice Button On Cell
        
        UISwitch *swtch = [[UISwitch alloc] initWithFrame:CGRectMake(236.0f, 12.0f, 26.0f, 26.0f)];
        swtch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        swtch.tag = indexPath.row;
        [cell addSubview:swtch];
        [swtch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    
    cell.backgroundColor = UIColorFromRedGreenBlue(237, 237, 237);
    
    NSMutableDictionary *temp = [banksArray objectAtIndex:indexPath.row];
    
    UILabel *lbl = (UILabel*) [cell viewWithTag:1];
    lbl.text = [temp objectForKey:@"institution_name"];
    
    UISwitch *onOffSwitch;
    
    for (UIView *v in cell.subviews)
    {
        if ([v isKindOfClass:[UISwitch class]])
        {
            onOffSwitch = (UISwitch*) v;
        }
    }
    
    if ([[temp objectForKey:@"isSelected"] isEqualToString:@"1"])
    {
        [onOffSwitch setOn:TRUE];
    }
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (IBAction)stateChanged:(UISwitch *)sender
{
    NSLog(@"Tag : %d",sender.tag);
    NSMutableDictionary *temp = [banksArray objectAtIndex:sender.tag];
    
    if (sender.on)
    {
        NSLog(@"YES");
        [temp setObject:@"1" forKey:@"isSelected"];
    }
    else
    {
        NSLog(@"NO");
        [temp setObject:@"0" forKey:@"isSelected"];
    }
    
    isBanksSettingsChanged = TRUE;
}

-(IBAction)backButtonTouched:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
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

#pragma mark -

#pragma mark Data Source Loading / Reloading Methods



- (void)reloadTableViewDataSource{
    //  should be calling your tableviews data source model to reload
    
	//  put here just for demo
    
	_reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    // [self.topiclistArray removeAllObjects];
    
    [self.table reloadData];
    
	_reloading = NO;
    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self reloadTableViewDataSource];
    
    //===== CUSTOM CODE HERE =======//
    
    //[NSThread detachNewThreadSelector:@selector(fetchingBanksToDisplay) toTarget:self withObject:nil];
    HUD               = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate      = self;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(fetchingBanksToDisplay) onTarget:self withObject:nil animated:YES];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}



- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}
#pragma mark -

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    [table reloadData];
}

@end

