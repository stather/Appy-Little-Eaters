//
//  HistoryConversionDetailVC.m
//  cfx
//
//  Created by Nishant on 10/12/12.
//
//

#import "HistoryConversionDetailVC.h"
#import "ImageUtils.h"
@interface HistoryConversionDetailVC ()

@end
int const maxImagePixelsAmount = 8000000; // 8 MP
@implementation HistoryConversionDetailVC
@synthesize detailsDict;
@synthesize sourceCurrencyLbl;
@synthesize targetCurrencyLbl;
@synthesize bankNameLbl;
@synthesize scrollView;
@synthesize imageView;
@synthesize targetBtn;
@synthesize preferredBtn;
@synthesize mutableData;
@synthesize headerView;


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
     [self performSelectorInBackground:@selector(getImage:) withObject:[detailsDict objectForKey:@"imageName"]];
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:YES];
    [self customizingNavigationBar];
    
    if (IS_HEIGHT_GTE_568)
    {
        self.headerView.frame = CGRectMake(0, 454, 320, 50);
        self.imageView.frame = CGRectMake(0, -20, 320, 498);
    }else
    {
        self.headerView.frame = CGRectMake(0, 366, 320, 50);
    }

    [sourceCurrencyLbl setText:[NSString stringWithFormat:@"%@ 1 = %@ %@",[detailsDict objectForKey:@"source"],[detailsDict objectForKey:@"multiplier"],[detailsDict objectForKey:@"target"]]];
    [bankNameLbl setText:[detailsDict objectForKey:@"name"]];

    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = imageView.frame.size;
    scrollView.minimumZoomScale = scrollView.frame.size.width / imageView.frame.size.width;
    scrollView.maximumZoomScale = 1.0;
    [scrollView setZoomScale:scrollView.minimumZoomScale];
    self.scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-94);
    
    self.institutionNameLbl.text = @"CFX Global Rate";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[[AppDelegate getSharedInstance] customeTabBar] setHidden:YES];
    
    self.rateLbl.text = [detailsDict objectForKey:@"conversionRate"];

   [self.targetBtn setTitle:[NSString stringWithFormat:@"%@ %@",[detailsDict objectForKey:@"target"],[self getCurrencyNameForCurrencyCode:[detailsDict objectForKey:@"target"]]] forState:UIControlStateNormal];
    
    [self.preferredBtn setTitle:[NSString stringWithFormat:@"%@ %@",[detailsDict objectForKey:@"base"],[self getCurrencyNameForCurrencyCode:[detailsDict objectForKey:@"base"]]] forState:UIControlStateNormal];
}

-(void)getImage : (NSString *)name
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [dataPath stringByAppendingPathComponent:@"patientPhotoFolder"];
    NSString *workSpacePath = [patientPhotoFolder stringByAppendingPathComponent:name];
    
    UIImage *image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
  
    [self performSelectorOnMainThread:@selector(setImageInImageView:) withObject:image waitUntilDone:NO];

}

-(void)setImageInImageView : (UIImage*)image
{
    
 [self.imageView setImage:image];
}

- (NSString*) getCurrencyNameForCurrencyCode:(NSString*) currencyCode
{
    NSString *sqlStatement = @"";
    NSString *currencyName;
   
    sqlite3 *database;
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM currency_table WHERE code_name = '%@'",currencyCode];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *symbolStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                if (symbolStr)
                {
                    int symbol = [symbolStr integerValue];
                    
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
    else
        currencyName = currencyCode;
    
    return currencyName;
}


-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    
    //add let bar button item
    /****** add custom left bar button (Back to history Button) at navigation bar  **********/
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    /****** add custom left bar button (Share Button) at navigation bar  **********/
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0,0,32,32);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareBtnSelected"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:[detailsDict objectForKey:@"date"]];
    [titleLbl setShadowColor:[UIColor whiteColor]];
    [titleLbl setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLbl];

}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(IBAction)shareBtnTouched:(id)sender
{
    [[AppDelegate getSharedInstance] showActionSheet];
}
-(IBAction)backButtonTouched:(id)sender
{

    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
