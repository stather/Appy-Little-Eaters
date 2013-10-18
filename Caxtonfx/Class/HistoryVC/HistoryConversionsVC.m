//
//  HistoryConversionsVC.m
//  Caxtonfx
//
//  Created by Nishant on 24/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "HistoryConversionsVC.h"
#import "ImageConversionsCustomCell.h"
#import "SettingVC.h"
#import "HistoryConversionDetailVC.h"
#import "UIImage+Resize.h"


@interface HistoryConversionsVC ()

@end

@implementation HistoryConversionsVC

@synthesize bottomView;
@synthesize table;
@synthesize historyArray;
@synthesize receiptsButton;
@synthesize captureButton;
@synthesize settingsButton;
@synthesize titleNameLbl;
@synthesize titletimeDateLbl;
@synthesize heightConstraint;
- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedIndex = 0;
    [self customizingNavigationBar];
    
    if(IS_HEIGHT_GTE_568)
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:524];
        [self.table addConstraint:heightConstraint];
    }else
    {
        heightConstraint = [NSLayoutConstraint constraintWithItem:self.table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:416];
        [self.table addConstraint:heightConstraint];
    }
    self.table.sectionHeaderHeight = 0.0f;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = [AppDelegate getSharedInstance];
    [[appDelegate customeTabBar] setHidden:YES];
    
    UIButton *recieptsBtn = (UIButton*) [appDelegate.bottomView viewWithTag:1];
    [appDelegate BottomButtonTouched:recieptsBtn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    [[appDelegate bottomView] setFrame:CGRectMake(0.0f, appDelegate.window.frame.size.height-55.0f, 320.0f, 55.0f)];
    [UIView commitAnimations];
    
}

-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    
    //NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
//    NSString *dateIs = [df stringFromDate:date];
    [titleLbl setText:@"Photo album"];
    [titleLbl setShadowColor:[UIColor whiteColor]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLbl];
    
    /****** add custom left bar button (Back to history Button) at navigation bar  **********/
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(0,0,32,32);
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [historyBtn addTarget:self action:@selector(backToHistoryBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
}

-(void)backToHistoryBtnTouched:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)BottomButtonTouched:(UIButton *)sender
{
    if(sender.tag == 3)
    {
        SettingVC *tempVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
        [[self navigationController] pushViewController:tempVC animated:YES];
    }
}

//==================================********************* =================================
-(UIImage *)FetchImage
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0];
    NSString *workSpacePath = [dataPath stringByAppendingPathComponent:@"12.png"];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
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
    return [historyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView setBackgroundColor:[UIColor darkGrayColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 200,22)];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:16.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    NSString *sectionName= nil;
    switch (section) {
        case 0:
            sectionName = @"Latest CFX Transactions";
            break;
        case 1:
            sectionName = @"CFX Image Conversions";
        default:
            break;
    }
    [titleLabel setText:sectionName];
    
    [headerView addSubview:titleLabel];
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ImageConversionsCustomCellIdentifier";
    ImageConversionsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[ImageConversionsCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageConversionsCustomCell"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else
    {
        cell.thumbnailImageView.image = nil;
    }
    
    NSMutableDictionary *dict = [historyArray objectAtIndex:indexPath.row];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.frame =   CGRectMake(24, 22, 37, 37);
    [cell addSubview:loadingView];
   
    [loadingView startAnimating];
    [NSThread detachNewThreadSelector:@selector(FetchImage:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:cell.thumbnailImageView, @"ImageView",[dict objectForKey:@"imageName"],@"imageName",loadingView,@"loadingView",nil]];
    
    NSString *base =@"";
       
    if ([dict objectForKey:@"base"])
    {
        base = [dict objectForKey:@"base"] ;
    }
    else
    {
        base = @"()";
    }
    cell.currencyCodeLabel.text= [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"target"],base];
    cell.globalRateLabel.text = @"Caxton FX Global Traveller Rate";
    cell.dateLabel.text= [dict objectForKey:@"date"];
    cell.convertedCurrencyLabel.text= [dict objectForKey:@"conversionValue"];
    
    if (selectedIndex == indexPath.row) {
        [cell setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    }
    else
        [cell setBackgroundColor:[UIColor whiteColor]];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, 320, 1)];
    [lineView setBackgroundColor:UIColorFromRedGreenBlue(220, 220, 220)];
    [cell addSubview:lineView];
    
        return cell;
}


//================================== *********  FetchImage  ************ =================================
-(void )FetchImage:(NSDictionary *) dic
{
   
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [dataPath stringByAppendingPathComponent:@"patientPhotoFolder"];
    NSString *workSpacePath = [patientPhotoFolder stringByAppendingPathComponent:[dic objectForKey:@"imageName"]];
    
    UIImage *mask = [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
    
    mask = [mask resizedImage:CGSizeMake(73, 73) interpolationQuality:kCGInterpolationHigh];
    
    [self performSelectorOnMainThread:@selector(setTheImage:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"ImageView"],@"ImageView",mask,@"Image",[dic objectForKey:@"loadingView"],@"loadingView", nil] waitUntilDone:NO];
    
}

-(void) setTheImage :(NSDictionary*)dic
{
    UIImageView *imgView = (UIImageView*)[dic objectForKey:@"ImageView"];
    
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView*)[dic objectForKey:@"loadingView"];
    [loadingView stopAnimating];
    
    [imgView setImage:[dic objectForKey:@"Image"]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;

        NSMutableDictionary *dict = [historyArray objectAtIndex:indexPath.row];
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

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        NSMutableDictionary *dic = [historyArray objectAtIndex:indexPath.row];
        [self deleteFromDB:dic];
        if (indexPath.section == 0) {
            [historyArray removeObjectAtIndex:indexPath.row];
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

//delete from database
- (void) deleteFromDB:(NSMutableDictionary*) receiptInfo
{
    NSString *sqlStatement = [NSString stringWithFormat:@"DELETE FROM conversionHistoryTable WHERE id =%@",[receiptInfo objectForKey:@"id"]];
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


@end

