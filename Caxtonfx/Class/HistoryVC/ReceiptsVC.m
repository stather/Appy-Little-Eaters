//
//  ReceiptsVC.m
//  cfx
//
//  Created by Amzad on 10/10/12.
//
//

#import "ReceiptsVC.h"
#import "SettingVC.h"
#import "HistoryConversionDetailVC.h"

@interface ReceiptsVC ()

@end

@implementation ReceiptsVC

@synthesize bottomView;
@synthesize table;
@synthesize historyArray;
@synthesize receiptsButton;
@synthesize captureButton;
@synthesize settingsButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizingNavigationBar];
    
    _tempMA = [[NSMutableArray alloc] init];
    historyArray = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    DatabaseHandler *dbHAndler =[[DatabaseHandler alloc] init];
    
    NSMutableArray *firstArray = [dbHAndler fetchingDatesFromTable:@"SELECT DISTINCT mthyear FROM Receipts order by mthyear desc"];
    for (int i = 0; i < [firstArray count]; i++)
    {
        NSMutableArray *secondArray = [dbHAndler fetchingEventDetailsFromTable:[NSString stringWithFormat:@"SELECT *  FROM Receipts where mthyear= '%@'",[[firstArray objectAtIndex:i] objectForKey:@"mthyear"]]];
        NSLog(@"second array  : %@",secondArray);
        [historyArray addObject:secondArray];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [AppDelegate getSharedInstance];
    
    //UIButton *recieptsBtn = (UIButton*) [appDelegate.bottomView viewWithTag:1];
    
    //[appDelegate BottomButtonTouched:recieptsBtn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [[appDelegate bottomView] setFrame:CGRectMake(0.0f, appDelegate.window.frame.size.height-55.0f, 320.0f, 55.0f)];
    [UIView commitAnimations];
}

-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    self.navigationItem.hidesBackButton = YES;
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont systemFontOfSize:20.0f]];
    [titleLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
    [titleLbl setText:@"History"];
    [titleLbl setShadowColor:[UIColor whiteColor]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLbl];
}

-(void)sortByStringDate:(NSMutableArray *)unsortedArray
{
    NSMutableDictionary *objModel;
    NSMutableArray *tempArray=[NSMutableArray array];
    for(int i=0;i<[unsortedArray count];i++)
    {
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        objModel=[unsortedArray objectAtIndex:i];
        [df setDateFormat:@"dd MMM yyyy"];
        NSDate *date=[df dateFromString:[objModel objectForKey:@"date"]];
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:objModel forKey:@"entity"];
        [dict setObject:date forKey:@"date"];
        [tempArray addObject:dict];
    }
    NSInteger counter=[tempArray count];
    NSDate *compareDate;
    NSInteger index;
    for(int i=0;i<counter;i++)
    {
        index=i;
        compareDate=[[tempArray objectAtIndex:i] valueForKey:@"date"];
        NSDate *compareDateSecond;
        for(int j=i+1;j<counter;j++)
        {
            compareDateSecond=[[tempArray objectAtIndex:j] valueForKey:@"date"];
            NSComparisonResult result = [compareDate compare:compareDateSecond];
            if(result == NSOrderedAscending)
            {
                compareDate=compareDateSecond;
                index=j;
            }
        }
        if(i!=index)
            [tempArray exchangeObjectAtIndex:i withObjectAtIndex:index];
    }
    [unsortedArray removeAllObjects];
    for(int i=0;i<[tempArray count];i++)
    {
        [unsortedArray addObject:[[tempArray objectAtIndex:i] valueForKey:@"entity"]];
    }
    historyArray = [self groupSortedData1:unsortedArray];

}

//==================================********************* =================================
-(UIImage *)FetchImage
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0];
    NSString *workSpacePath = [dataPath stringByAppendingPathComponent:@"12.png"];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
}
//========================  GROUPING DATA ACCORDING TO MONTHS ==================//


-(NSMutableArray *)groupSortedData1:(NSMutableArray *)unGroupedArray
{
    //Initially sort the groupedArray in the (ascending/descending) order of dates
    
    //Create an array to hold groups
    NSMutableArray* groupedArray = [[NSMutableArray alloc] initWithCapacity:[unGroupedArray count]];
    
    for (int i = 0; i < [unGroupedArray count]; i++)
    {
        //Grab first
        NSMutableDictionary * firstDict = [unGroupedArray objectAtIndex:i];
        
        //Create an array and add first dict in this array
        NSMutableArray* currentGroupArray = [[NSMutableArray alloc] initWithCapacity:0];
        [currentGroupArray addObject:firstDict];
        
        //create a Flag and set to NO
        BOOL flag = NO;
        for (int j = i+1; j < [unGroupedArray count]; j++)
        {
            //Grab next
            NSMutableDictionary* nextDict = [unGroupedArray objectAtIndex:j];
            
            NSString *oldStr =[firstDict objectForKey:@"date"];
            NSArray *dateAr =[oldStr componentsSeparatedByString:@" "];
            oldStr = [[dateAr objectAtIndex:0] stringByAppendingFormat:@" %@ %@",[dateAr objectAtIndex:1],[dateAr objectAtIndex:2]];
            
            NSString *newStr =[nextDict objectForKey:@"date"];
            NSArray *dateAr1 =[newStr componentsSeparatedByString:@" "];
            newStr = [[dateAr1 objectAtIndex:0] stringByAppendingFormat:@" %@ %@",[dateAr objectAtIndex:1],[dateAr1 objectAtIndex:2]];
            
            //Compare
            if ([oldStr isEqualToString:newStr])
            {
                //if they match add this to same group
                [currentGroupArray addObject:nextDict];
            }
            else
            {
                //we have got our group so stop next iterations
                [groupedArray addObject:currentGroupArray];
                i=j-1;
                flag = YES;
                break;
            }
        }
        //if entire array has same grouped dates we need to add it to grouped array in the end
        if (!flag)
        {
            [groupedArray addObject:currentGroupArray];
            
            if ([currentGroupArray count] == [unGroupedArray count])
            {
                return groupedArray;
            }
        }
    }
    return groupedArray;
}

#pragma mark -
#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [historyArray count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[historyArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [headerView setBackgroundColor:UIColorFromRedGreenBlue(80, 80, 80)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 200,12)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    NSString *sectionName = [[[historyArray objectAtIndex:section] objectAtIndex:0] objectForKey:@"date"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy"];
    NSDate *date=[df dateFromString:sectionName];
    [df setDateFormat:@"dd MMMM yyyy"];
    sectionName = [df stringFromDate:date];
    NSArray *dateAr =[sectionName componentsSeparatedByString:@" "];
    sectionName = [[dateAr objectAtIndex:1] stringByAppendingFormat:@" %@",[dateAr objectAtIndex:2]];
    
    [titleLabel setText:sectionName];
    [headerView addSubview:titleLabel];
    return headerView;
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
        NSLog(@"cell allocated");
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        UILabel *tempLbl;
        
        // Adding Source Currency Label On Cell
        
        UILabel *sourceCurrencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 9, 40.0f,15.0f)];
        [sourceCurrencyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
        
        [sourceCurrencyLabel setBackgroundColor:[UIColor clearColor]];
        [sourceCurrencyLabel setTextColor:[UIColor blackColor]];
        [sourceCurrencyLabel setTag:1];
        sourceCurrencyLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:sourceCurrencyLabel];
        
        // Adding 'TO' Label On Cell
        
        tempLbl = [[UILabel alloc]initWithFrame:CGRectMake(51.0f, 9, 14.0f,15.0f)];
        [tempLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [tempLbl setBackgroundColor:[UIColor clearColor]];
        [tempLbl setTextColor:[UIColor blackColor]];
        [tempLbl setText:@"to"];
        tempLbl.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:tempLbl];
        
        // Adding Target Currency Label On Cell
        UILabel * targetCurrencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(69.0f, 9, 50.0f,15.0f)];
        [targetCurrencyLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [targetCurrencyLabel setBackgroundColor:[UIColor clearColor]];
        [targetCurrencyLabel setTag:2];
        targetCurrencyLabel.textAlignment = NSTextAlignmentLeft;
        [targetCurrencyLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:targetCurrencyLabel];
        
        // Adding Rate Label On Cell
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 27, 280.0f,11.0f)];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTag:3];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameLabel setTextColor:[UIColor grayColor]];
        [cell addSubview:nameLabel];
        
        // Adding Date Label On Cell
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(230.0f, 9, 64.0f,11.0f)];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setTag:4];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [dateLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:dateLabel];
        
        // Adding arrow Image On Cell
        UIImageView *detailIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(300.0f, 16.0f, 8.0f, 12.0f)];
        [detailIndicator setBackgroundColor:[UIColor clearColor]];
        [detailIndicator setImage:[UIImage imageNamed:@"arrow"]];
        [cell addSubview:detailIndicator];
    }
    
    NSMutableArray *tempArray = [historyArray objectAtIndex:indexPath.section];
    NSMutableDictionary *dict = [tempArray objectAtIndex:indexPath.row];
    
    UILabel *lbl = (UILabel*) [cell viewWithTag:1];
    lbl.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"source"]];
    lbl = (UILabel*) [cell viewWithTag:2];
    lbl.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"target"]];
    lbl = (UILabel*) [cell viewWithTag:3];
    lbl.text = [NSString stringWithFormat:@"%@ ( %@ 1 = %@ %@ )",[dict objectForKey:@"name"],[dict objectForKey:@"source"],[dict objectForKey:@"multiplier"],[dict objectForKey:@"target"]];
    lbl = (UILabel*) [cell viewWithTag:4];
  
    NSString *sectionName = @"";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy"];
    sectionName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"date"]];
    NSDate *date=[df dateFromString:sectionName];
    [df setDateFormat:@"dd MMM yyyy"];
    sectionName = [df stringFromDate:date];
    lbl.text = sectionName;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *tempArray = [historyArray objectAtIndex:indexPath.section];
    NSMutableDictionary *dict = [tempArray objectAtIndex:indexPath.row];
    HistoryConversionDetailVC *temp = [[HistoryConversionDetailVC alloc] initWithNibName:@"HistoryConversionDetailVC" bundle:nil];
    temp.detailsDict = dict;
    [[self navigationController] pushViewController:temp animated:YES];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *arr = [historyArray objectAtIndex:indexPath.section];
        //delete from database
        NSMutableDictionary *dic = [arr objectAtIndex:indexPath.row];
        [self deleteFromDB:dic];
        
        if ([arr count] == 1)
        {
            [historyArray removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        }
        else
        {
            [arr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

//delete from database
- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo
{
    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM Receipts WHERE id = %@",[receiptInfo objectForKey:@"id"]];
    
    DatabaseHandler *dbHAndler =[[DatabaseHandler alloc] init];
    
    [dbHAndler executeQuery:sqlStatement];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)BottomButtonTouched:(UIButton *)sender
{
    if(sender.tag == 3)
    {
        SettingVC *tempVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
        [[self navigationController] pushViewController:tempVC animated:YES];
    }
}


@end

