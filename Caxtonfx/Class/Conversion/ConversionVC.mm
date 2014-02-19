//
//  ConversionVC.m
//  cfx
//
//  Created by Ashish on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConversionVC.h"
#import "ImagePickerVC.h"
#import "ImageEditorVC.h"
#import "AppDelegate.h"
#import "CurrencyPickerVC.h"
#import "ImageUtils.h"
#import "sqlite3.h"
#import "ReceiptsVC.h"
#import "BanksVC.h"
#import "UIImage+AutoLevels.h"
#import "UIImage+Brightness.h"
#import "CMocrCharacter.h"
#import "baseapi.h"
#include <math.h>
#import "CardsVC.h"
#import "SBJson.h"
#import "CMocrCharacter.h"
#import "environ.h"
#import "pix.h"
#import "TBXML.h"
#import "TOcr_Word.h"
#import "UIImageAverageColorAddition.h"
#import "ImageFilter.h"
#import "BaseCurrencyVC.h"
#import "DefaultCurrencyVC.h"
#import "MoreInfoVC.h"
#import "TargetCurrencyVC.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "UIImage+Resize.h"

#import <Social/Social.h>


static inline double radians (double degrees) {return degrees * M_PI/180;}

namespace tesseract {
    class TessBaseAPI;
};

@interface ConversionVC ()
{
    tesseract::TessBaseAPI* _tesseract;
    uint32_t* _pixels;
}

@end

int const maxImagePixelsAmount = 8000000; // 8 MP

static NSString* commonHtmlTitle = @"<font size=\"10\">";

@implementation ConversionVC

@synthesize imageToConvert;
@synthesize imgView;
@synthesize preferredBtn;
@synthesize targetBtn;
@synthesize menuScroller;
@synthesize focusBounds;
@synthesize pullView;
@synthesize headerView;
@synthesize bankScroller; 
@synthesize pullViewDownBtn;
@synthesize rateLbl;
@synthesize institutionNameLbl;
@synthesize comissionLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizingNavigationBar];
    [self allUpdationsOnLoad];
//    [self setupReachability];
    
    // Do any additional setup after loading the view from its nib.
      
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,32,32);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnSelected"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    NSLog(@"preferredCurrency = %@", preferredCurrency);
    
    [self.preferredBtn setTitle:[NSString stringWithFormat:@"%@ %@",(preferredCurrency.length !=0)?preferredCurrency:@"",[self getCurrencyNameForCurrencyCode:preferredCurrency]] forState:UIControlStateNormal];
    
    [self.targetBtn setTitle:[NSString stringWithFormat:@"%@ %@",targetCurrency,[self getCurrencyNameForCurrencyCode:targetCurrency]] forState:UIControlStateNormal];
    
    [self startTesseract];
    
    
    [self.preferredBtn setTitle:[NSString stringWithFormat:@"%@ %@",(preferredCurrency.length !=0)?preferredCurrency:@"",[self getCurrencyNameForCurrencyCode:preferredCurrency]] forState:UIControlStateNormal];
    
    [NSThread detachNewThreadSelector:@selector(doSomeImageAdjustment) toTarget:self withObject:nil];
    
}

-(void)backBtnPressed: (id)sender
{
    NSLog(@"inside back button");
    NSArray *array = [self.navigationController viewControllers];
    ImagePickerVC *ivc = (ImagePickerVC*) [array objectAtIndex:0];
    [ivc showCamera];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (isCurrencySettingsChanged)
    {
        isCurrencySettingsChanged = FALSE;
        
        [self.targetBtn setTitle:[NSString stringWithFormat:@"%@ %@",targetCurrency,[self getCurrencyNameForCurrencyCode:targetCurrency]] forState:UIControlStateNormal];
        
        int page = menuPageControl.pageControl.currentPage;
        
        if (page == 0)
            [self setInstitutionInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Caxton FX rate",@"name",nil]];
        else
        {
            NSMutableDictionary *dic = [bankArr objectAtIndex:page-1];
            [self setInstitutionInfo:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"name"],@"name",[dic objectForKey:@"oneOffFee"],@"oneOffFee",nil]];
        }
        
        [self.preferredBtn setTitle:[NSString stringWithFormat:@"%@ %@",(preferredCurrency.length !=0)?preferredCurrency:@"",[self getCurrencyNameForCurrencyCode:preferredCurrency]] forState:UIControlStateNormal];
        
        [self setUpMenuCardScroller];
    }
   
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark -
#pragma mark -

-(void)customizingNavigationBar
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(52, 20, 220, 44)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    //set title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(55.0f, 5.0f, 150.0f, 30.0f)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20.0f]];
    [titleLbl setTextColor:[UIColor whiteColor]];
    [titleLbl setText:@"Conversion"];
    [titleLbl.layer setShadowRadius:1.0f];
    [titleLbl.layer setShadowColor:[[UIColor colorWithRed:176.0f/255.0f green:19.0f/255.0f blue:25.0f/255.0f alpha:1.0f] CGColor]];
    [titleLbl.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [titleLbl.layer setShadowOpacity:1.0f];
    [titleLbl setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:titleLbl];
    [self.navigationItem setTitleView:titleView];
    
    /*
    //add let bar button item
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [leftBtn setImage:[UIImage imageNamed:@"topBackBtn.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"topBackBtn.png"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    */
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setHidesBackButton:YES];
    //===========
    /****** add custom left bar button (Share Button) at navigation bar  **********/
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,32,32);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"captureTopBtn.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"captureTopBtn.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(captureBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:left];
}

-(void)allUpdationsOnLoad
{
    NSMutableDictionary *dict ;
    NSMutableDictionary *finalBooks;
    for (int i =0; i < [[dict allKeys] count]; i++) {
        [finalBooks setObject:[dict objectForKey:[[dict allKeys] objectAtIndex:i]] forKey:[[dict allKeys] objectAtIndex:i]];
    }
    BOOL loginState = NO;
    if(loginState)
    {
        // share btn frame
        CGRect frame = self.shareBtn.frame;
        frame.origin.x = 115;
        self.shareBtn.frame = frame;
        
        // More Infobtn
        [self.moreInfoBtn setHidden:YES];
        
        // Save btn frame change
        frame = self.saveBtn.frame;
        frame.origin.x = 165;
        self.saveBtn.frame = frame;
        
        // tool tip label and tooltip imageview frame change
        frame = self.toolTipImgView.frame;
        
        frame.origin.x =122-44;
        self.toolTipImgView.frame = frame;
        
        frame = self.toolTipLbl.frame;
        frame.origin.x =135-44;
        self.toolTipLbl.frame = frame;
    }
    else
    {
        // share btn frame
        CGRect frame = self.shareBtn.frame;
        frame.origin.x = 60;
        self.shareBtn.frame = frame;
        
        // More Infobtn
        [self.moreInfoBtn setHidden:NO];
        
        // Save btn frame change
        frame = self.saveBtn.frame;
        frame.origin.x = 210;
        self.saveBtn.frame = frame;
        
        // tool tip label and tooltip imageview frame change
        frame = self.toolTipImgView.frame;
        frame.origin.x =122;
        self.toolTipImgView.frame = frame;
        
        frame = self.toolTipLbl.frame;
        frame.origin.x =135;
        self.toolTipLbl.frame = frame;
    }
    
    self.toolTipImgView.alpha = 0.0;
    self.toolTipLbl.alpha = 0.0;
    //show navigation bar
    [self.navigationController setNavigationBarHidden:FALSE];
    
    //config OCR
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    _pathToData = nil;
    
    //	_recognitionService = [[CRecognitionService alloc] init];
    //Saurabh
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    UIImage* newImage = scaleAndRotateImage(imageToConvert, maxImagePixelsAmount);
    imageToConvert = newImage;
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    indicatorView.frame = CGRectMake(146, 225, 33, 33); 
    
    [self.view addSubview:indicatorView];
    
    ProcessingLbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 257, 150, 14)];
    [ProcessingLbl setBackgroundColor:[UIColor clearColor]];
    [ProcessingLbl setText:@"Processing Image..."];
    ProcessingLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [ProcessingLbl setTextColor:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f]];
    [ProcessingLbl setShadowOffset:CGSizeMake(0.5, 0.5)];
    [ProcessingLbl setShadowColor:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0f]];
    

    if(IS_HEIGHT_GTE_568)
    {
        indicatorView.frame = CGRectMake(146, 225-20, 33, 33);
        ProcessingLbl.frame = CGRectMake(110, 257-20, 150, 14);
    }
    
    else{
        indicatorView.frame = CGRectMake(146, 225-64, 33, 33);
        ProcessingLbl.frame = CGRectMake(110, 257-64, 150, 14);
    }

    [self.view addSubview:ProcessingLbl];
    
       
    [self.saveBtn setHidden:YES];
    [self.shareBtn setHidden:YES];
    [self.moreInfoBtn setHidden:YES];
    
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
        [self performingUpdatesOnExpiryTime];
        
    }
    
    [reach startNotifier];
}

-(void)performingUpdatesOnExpiryTime
{
    NSDate * now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * mile = [df dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"expiryTime"]];
    NSComparisonResult result = [now compare:mile];
    
    switch (result)
    {
        case NSOrderedAscending:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                [self callgetGloableRateApi];
            });

        }
            break;
        case NSOrderedDescending:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                [self callgetGloableRateApi];
            });
        }
            break;
        case NSOrderedSame:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                [self callgetGloableRateApi];
            });
            
        }
            break;
        default:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                [self callgetGloableRateApi];
            });
        
        }
            break;
    }
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
                        
                        NSLog(@"sqlStatement : %@",sqlStatement);
                        
                        if (sqlite3_exec(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
                        {
                            NSLog(@"record inserted successfully!!");
                            NSLog(@"%@",DatabasePath);
                        }
                        
                        sqlite3_close(database);
                    }
                }
                
                [self fetchingBanksToDisplay];
            }
        }
    }
    else
    {
        int tableCount = [self getTableCount:@"converion_rate_table"];
        
        if (tableCount > 0)
        {
            
        }
        else
        {
            [self getLatestCurrencyConversionRates];
        }
    }
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

// this does the trick to have tesseract accept the UIImage.
- (UIImage *) convertedImage: (UIImage * ) src_img
{
    CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB();
    /*
     * Note we specify 4 bytes per pixel here even though we ignore the
     * alpha value; you can't specify 3 bytes per-pixel.
     */
    size_t d_bytesPerRow = src_img.size.width * 4;
    unsigned char * imgData = (unsigned char*)malloc(src_img.size.height*d_bytesPerRow);
    CGContextRef context =  CGBitmapContextCreate(imgData, src_img.size.width,
                                                  src_img.size.height,
                                                  8, d_bytesPerRow,
                                                  d_colorSpace,
                                                  kCGImageAlphaNoneSkipFirst);
    
    UIGraphicsPushContext(context);
    // These next two lines 'flip' the drawing so it doesn't appear upside-down.
    CGContextTranslateCTM(context, 0.0, src_img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
    [src_img drawInRect:CGRectMake(0.0, 0.0, src_img.size.width, src_img.size.height)];
    UIGraphicsPopContext();
    
    /*
     * At this point, we have the raw ARGB pixel data in the imgData buffer, so
     * we can perform whatever image processing here.
     */
    
    
    // After we've processed the raw data, turn it back into a UIImage instance.
    CGImageRef new_img = CGBitmapContextCreateImage(context);
    UIImage * convertedImage = [[UIImage alloc] initWithCGImage:
                                new_img];
    
    CGImageRelease(new_img);
    CGContextRelease(context);
    CGColorSpaceRelease(d_colorSpace);
    free(imgData);
    
    return convertedImage;
}

-(void)extractingDataFromImage:(UIImage *)newImage
{
    [self setImage:newImage];
    //    [self recognize];
    //char* utf8Text = _tesseract->GetUTF8Text();
    NSString *htmlText = [self recognizedText];
    [self currencyPatternRecognitionForData:[self extractDataFromHtml:htmlText forImage:newImage]];
}

- (NSMutableArray *) extractDataFromHtml:(NSString*) htmlText forImage:(UIImage*) image
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    TBXML * tbxml = [[TBXML alloc] initWithXMLString:htmlText];
    
	TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root)
	{
        TBXMLElement *nextDiv = [TBXML childElementNamed:@"div" parentElement:root];
        
        if (nextDiv)
        {
            TBXMLElement *para = [TBXML childElementNamed:@"p" parentElement:nextDiv];
            
            while (para != nil)
            {
                TBXMLElement *line = [TBXML childElementNamed:@"span" parentElement:para];
                
                NSMutableArray *lineArray = [[NSMutableArray alloc] init];
                
                while (line != nil)
                {
                    NSLog(@"<----------------------------************ Line ***************--------------------------->");
                    
                    TOcr_Word *tmpWord = [[TOcr_Word alloc] init];
                    
                    TBXMLElement *word = [TBXML childElementNamed:@"span" parentElement:line];
                    
                    NSMutableArray *wordArray = [[NSMutableArray alloc] init];
                    
                    int index = 0;
                    int lastIndex = 0;
                    
                    while (word != nil)
                    {
                        TBXMLElement *strong = [TBXML childElementNamed:@"strong" parentElement:word];
                        
                        NSString *wordStr;
                        
                        if (strong)
                        {
                            TBXMLElement *em = [TBXML childElementNamed:@"em" parentElement:strong];
                            
                            if (em)
                                wordStr = [TBXML textForElement:em];
                            else
                                wordStr = [TBXML textForElement:strong];
                        }
                        else
                        {
                            TBXMLElement *em = [TBXML childElementNamed:@"em" parentElement:word];
                            
                            if (em)
                                wordStr = [TBXML textForElement:em];
                            else
                                wordStr = [TBXML textForElement:word];
                            
                        }
                        
                        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.$£¥č€₪лв₨б₩๚"];
                        
                        set = [set invertedSet];
                        
                        wordStr = [[wordStr componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
                        
                        NSRange range = [wordStr rangeOfString:@"^\\.*" options:NSRegularExpressionSearch];
                        wordStr = [wordStr stringByReplacingCharactersInRange:range withString:@""];
                        
                        range = [wordStr rangeOfString:@"^\\,*" options:NSRegularExpressionSearch];
                        wordStr = [wordStr stringByReplacingCharactersInRange:range withString:@""];
                        
                        //                        wordStr = [wordStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
                        
                        wordStr = [wordStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                        
                        NSString *rectStr = [TBXML valueOfAttributeNamed:@"title" forElement:word];
                        
                        
                        NSArray *components = [rectStr componentsSeparatedByString:@" "];
                        
                        float x = [[components objectAtIndex:1] floatValue];
                        float y = [[components objectAtIndex:2] floatValue];
                        float w = [[components objectAtIndex:3] floatValue] - [[components objectAtIndex:1] floatValue];
                        float h = [[components objectAtIndex:4] floatValue] - [[components objectAtIndex:2] floatValue];
                        
                        CGRect rect = CGRectMake(x, y, w, h);
                        
                        TOcr_Word *tWord = [[TOcr_Word alloc] init];
                        tWord.wordStr = wordStr;
                        tWord.wordRect = rect;
                        
                        if ([wordStr length] > 0)
                        {
                            if ([self isWordNumeric:wordStr])
                            {
                                if ([tmpWord.wordStr length] > 0 && index-lastIndex == 1)
                                {
                                    tmpWord.wordStr = [tmpWord.wordStr stringByAppendingFormat:@"%@",tWord.wordStr];
                                    
                                    float x = tmpWord.wordRect.origin.x;
                                    float y = tmpWord.wordRect.origin.y;
                                    float w = (tWord.wordRect.origin.x+tWord.wordRect.size.width) - tmpWord.wordRect.origin.x;
                                    float h;
                                    
                                    if (tWord.wordRect.size.height > tmpWord.wordRect.size.height)
                                        h = tWord.wordRect.size.height;
                                    else
                                        h = tmpWord.wordRect.size.height;
                                    
                                    tmpWord.wordRect = CGRectMake(x, y, w, h);
                                    
                                    lastIndex = index;
                                }
                                else
                                {
                                    if ([wordArray count] > 0)
                                    {
                                        TOcr_Word *lastWord = [wordArray lastObject];
                                        
                                        if ([lastWord.wordStr length] > 0)
                                        {
                                            unichar lastChar = [lastWord.wordStr characterAtIndex:[lastWord.wordStr length]-1];
                                            
                                            if ([[NSNumber numberWithUnsignedShort:lastChar] intValue] == 46)
                                            {
                                                TOcr_Word *lastWord = [wordArray lastObject];
                                                
                                                lastWord.wordStr = [lastWord.wordStr stringByAppendingFormat:@"%@",tWord.wordStr];
                                                
                                                float x = lastWord.wordRect.origin.x;
                                                float y = lastWord.wordRect.origin.y;
                                                float w = (tmpWord.wordRect.origin.x+tWord.wordRect.size.width) - lastWord.wordRect.origin.x;
                                                float h;
                                                
                                                if (tWord.wordRect.size.height > lastWord.wordRect.size.height)
                                                    h = tWord.wordRect.size.height;
                                                else
                                                    h = lastWord.wordRect.size.height;
                                                
                                                lastWord.wordRect = CGRectMake(x, y, w, h);
                                            }
                                            else
                                            {
                                                tmpWord.wordStr = tWord.wordStr;
                                                tmpWord.wordRect = tWord.wordRect;
                                                
                                                lastIndex = index;
                                            }
                                        }
                                        else
                                        {
                                            tmpWord.wordStr = tWord.wordStr;
                                            tmpWord.wordRect = tWord.wordRect;
                                            
                                            lastIndex = index;
                                        }
                                    }
                                    else
                                    {
                                        tmpWord.wordStr = tWord.wordStr;
                                        tmpWord.wordRect = tWord.wordRect;
                                        
                                        lastIndex = index;
                                    }
                                }
                            }
                            else if ([self isOnlyCurrencySymbol:wordStr])
                            {
                                if ([tmpWord.wordStr length] > 0 && index-lastIndex == 1)
                                {
                                    tmpWord.wordStr = [tmpWord.wordStr stringByAppendingFormat:@"%@",tWord.wordStr];
                                    
                                    float x = tmpWord.wordRect.origin.x;
                                    float y = tmpWord.wordRect.origin.y;
                                    float w = (tWord.wordRect.origin.x+tWord.wordRect.size.width) - tmpWord.wordRect.origin.x;
                                    float h;
                                    
                                    if (tWord.wordRect.size.height > tmpWord.wordRect.size.height)
                                        h = tWord.wordRect.size.height;
                                    else
                                        h = tmpWord.wordRect.size.height;
                                    
                                    tmpWord.wordRect = CGRectMake(x, y, w, h);
                                    
                                    lastIndex = index;
                                }
                                else
                                {
                                    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"$£¥č€₪лв₨б₩๚"];
                                    
                                    set = [set invertedSet];
                                    
                                    tWord.wordStr = [[tWord.wordStr componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
                                    
                                    tmpWord.wordStr = tWord.wordStr;
                                    tmpWord.wordRect = tWord.wordRect;
                                    
                                    lastIndex = index;
                                }
                            }
                            else if ([tmpWord.wordStr length] > 0)
                            {
                                if (tmpWord.wordStr.length !=0 && [[NSNumber numberWithUnsignedShort:[tmpWord.wordStr characterAtIndex:0]] intValue] == 46)
                                {
                                    if ([wordArray count] > 0)
                                    {
                                        TOcr_Word *lastWord = [wordArray lastObject];
                                        
                                        tmpWord.wordStr = [lastWord.wordStr stringByAppendingFormat:@"%@",tmpWord.wordStr];
                                        
                                        float x = lastWord.wordRect.origin.x;
                                        float y = lastWord.wordRect.origin.y;
                                        float w = (tmpWord.wordRect.origin.x+tmpWord.wordRect.size.width) - lastWord.wordRect.origin.x;
                                        float h;
                                        
                                        if (tmpWord.wordRect.size.height > lastWord.wordRect.size.height)
                                            h = tmpWord.wordRect.size.height;
                                        else
                                            h = lastWord.wordRect.size.height;
                                        
                                        tmpWord.wordRect = CGRectMake(x, y, w, h);
                                        
                                        [wordArray removeLastObject];
                                        [wordArray addObject:tmpWord];
                                    }
                                    else
                                    {
                                        [wordArray addObject:tmpWord];
                                        tmpWord = nil;
                                        tmpWord = [[TOcr_Word alloc] init];
                                        
                                        [wordArray addObject:tWord];
                                    }
                                }
                                else
                                {
                                    [wordArray addObject:tmpWord];
                                    tmpWord = nil;
                                    tmpWord = [[TOcr_Word alloc] init];
                                    
                                    [wordArray addObject:tWord];
                                }
                            }
                            else
                            {
                                [wordArray addObject:tWord];
                            }
                        }
                        
                        if ([tmpWord.wordStr length]>1)
                        {
                            if ([[NSNumber numberWithUnsignedShort:[tmpWord.wordStr characterAtIndex:0]] intValue] == 46)
                            {
                                TOcr_Word *lastWord = [wordArray lastObject];
                                
                                tmpWord.wordStr = [lastWord.wordStr stringByAppendingFormat:@"%@",tmpWord.wordStr];
                                
                                float x = lastWord.wordRect.origin.x;
                                float y = lastWord.wordRect.origin.y;
                                float w = (tmpWord.wordRect.origin.x+tmpWord.wordRect.size.width) - lastWord.wordRect.origin.x;
                                float h;
                                
                                if (tmpWord.wordRect.size.height > tmpWord.wordRect.size.height)
                                    h = tmpWord.wordRect.size.height;
                                else
                                    h = lastWord.wordRect.size.height;
                                
                                tmpWord.wordRect = CGRectMake(x, y, w, h);
                                
                                [wordArray removeLastObject];
                                [wordArray addObject:tmpWord];
                                
                                tmpWord = nil;
                                tmpWord = [[TOcr_Word alloc] init];
                            }
                        }
                        
                        word = [TBXML nextSiblingNamed:@"span" searchFromElement:word];
                        
                        if (!word)
                        {
                            if ([tmpWord.wordStr length] > 0)
                            {
                                [wordArray addObject:tmpWord];
                                tmpWord = nil;
                                tmpWord = [[TOcr_Word alloc] init];
                                
                                [wordArray addObject:tWord];
                            }
                        }
                        
                        index++;
                    }
                    
                    if ([wordArray count] > 0)
                    {
                        [lineArray addObject:wordArray];
                    }
                    
                    line = [TBXML nextSiblingNamed:@"span" searchFromElement:line];
                }
                
                if ([lineArray count] > 0)
                {
                    [dataArray addObject:lineArray];
                }
                
                para = [TBXML nextSiblingNamed:@"p" searchFromElement:para];
            }
        }
	}
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSMutableArray *arr = [dataArray objectAtIndex:i];
        
        for (int j = 0; j < [arr count]; j++)
        {
            NSMutableArray *arr2 = [arr objectAtIndex:j];
            
            for (int k = 0; k < [arr2 count]; k++)
            {
                TOcr_Word *tword = [arr2 objectAtIndex:k];
                
                NSLog(@"---------------%@",tword.wordStr);
            }
        }
    }
    
    return dataArray;
}

- (void) currencyPatternRecognitionForData:(NSMutableArray*) dataArr
{
    NSLog(@"currencyPatternRecognitionForData");
    
    currencyArr = [[NSMutableArray alloc] init];
    
    BOOL isCurrencyFound = FALSE;
    
    for (int i = 0; i < [dataArr count]; i++)
    {
        NSMutableArray *lines = [dataArr objectAtIndex:i];
        
        for (int j = 0; j < [lines count]; j++)
        {
            NSMutableArray *words = [lines objectAtIndex:j];
            
            NSMutableArray *tmpCurrencyArr = [[NSMutableArray alloc] init];
            
            NSMutableArray *addedWord = [[NSMutableArray alloc] init];
            
            for (int k = 0; k < [words count]; k++)
            {
                TOcr_Word *tWord = (TOcr_Word*)[words objectAtIndex:k];
                
                tWord = [self trimmedStringFromString:tWord forPattern:1];
                
                ///////////////////////////////////////////////////// $12 , $12.00 , $1,234 , $1,234.00 , $ 12 , $ 12.00 , $ 1,234 , $ 1,234.00 /////////////////////////////////////////////////////
                
                if ([tWord.wordStr length] > 0)
                {
                    if ([tWord.wordStr length] == 1 && [self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:[tWord.wordStr characterAtIndex:0]] intValue]]) // first character is currency symbol
                    {
                        [tmpCurrencyArr addObject:tWord];
                    }
                    else if ([tWord.wordStr length] > 1)
                    {
                        unichar fChar = [tWord.wordStr characterAtIndex:0];
                        
                        if ([self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
                        {
                            unichar sChar = [tWord.wordStr characterAtIndex:1];
                            
                            if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:sChar] intValue]])
                            {
                                tWord.wordStr = [self getCurrencyForCurrencyWord:tWord.wordStr];
                                
                                [currencyArr addObject:tWord];
                                
                                isCurrencyFound = TRUE;
                                
                                [addedWord addObject:tWord];
                                
                                [tmpCurrencyArr removeAllObjects];
                            }
                            else if ([[NSNumber numberWithUnsignedShort:sChar] intValue] == 32 && [tWord.wordStr length] > 2)
                            {
                                unichar thChar = [tWord.wordStr characterAtIndex:2];
                                
                                if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:thChar] intValue]])
                                {
                                    tWord.wordStr = [self getCurrencyForCurrencyWord:tWord.wordStr];
                                    
                                    [currencyArr addObject:tWord];
                                    
                                    isCurrencyFound = TRUE;
                                    
                                    [addedWord addObject:tWord];
                                    
                                    [tmpCurrencyArr removeAllObjects];
                                }
                            }
                        }
                        else if ([tmpCurrencyArr count] > 0 && [tWord.wordStr length] > 0)
                        {
                            unichar fChar = [tWord.wordStr characterAtIndex:0];
                            
                            if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
                            {
                                tWord.wordStr = [self getCurrencyForCurrencyWord:tWord.wordStr];
                                
                                TOcr_Word *fWord = (TOcr_Word*) [tmpCurrencyArr lastObject];
                                
                                TOcr_Word *newWord = [[TOcr_Word alloc] init];
                                newWord.wordStr = [fWord.wordStr stringByAppendingFormat:@" %@",tWord.wordStr];
                                float x = fWord.wordRect.origin.x;
                                float y = fWord.wordRect.origin.y;
                                float w = (tWord.wordRect.origin.x - fWord.wordRect.origin.x) + tWord.wordRect.size.width;
                                float h = fWord.wordRect.size.height;
                                newWord.wordRect = CGRectMake(x, y, w, h);
                                
                                [currencyArr addObject:newWord];
                                
                                isCurrencyFound = TRUE;
                                
                                [addedWord addObject:fWord];
                                [addedWord addObject:tWord];
                                
                                [tmpCurrencyArr removeAllObjects];
                            }
                        }
                    }
                    else if ([tmpCurrencyArr count] > 0)
                    {
                        unichar fChar = [tWord.wordStr characterAtIndex:0];
                        
                        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
                        {
                            tWord.wordStr = [self getCurrencyForCurrencyWord:tWord.wordStr];
                            
                            TOcr_Word *fWord = (TOcr_Word*) [tmpCurrencyArr lastObject];
                            
                            TOcr_Word *newWord = [[TOcr_Word alloc] init];
                            newWord.wordStr = [fWord.wordStr stringByAppendingFormat:@" %@",tWord.wordStr];
                            float x = fWord.wordRect.origin.x;
                            float y = fWord.wordRect.origin.y;
                            float w = (tWord.wordRect.origin.x - fWord.wordRect.origin.x) + tWord.wordRect.size.width;
                            float h = fWord.wordRect.size.height;
                            newWord.wordRect = CGRectMake(x, y, w, h);
                            
                            [currencyArr addObject:newWord];
                            
                            isCurrencyFound = TRUE;
                            
                            [addedWord addObject:fWord];
                            [addedWord addObject:tWord];
                            
                            [tmpCurrencyArr removeAllObjects];
                        }
                    }
                }
            }
            
            tmpCurrencyArr = nil;
            tmpCurrencyArr = [[NSMutableArray alloc] init];
            
            for (int k = 0; k < [words count]; k++)
            {
                TOcr_Word *tWord = (TOcr_Word*)[words objectAtIndex:k];
                
                tWord = [self trimmedStringFromString:tWord forPattern:2];
                
                ///////////////////////////////////////////////////// 12$ , 12.00$ , 1,234$ , 1,234.00$ , 12 $ , 12.00 $ , 1,234 $ , 1,234.00 $ /////////////////////////////////////////////////////
                
                if ([tWord.wordStr length] > 0)
                {
                    unichar fChar = [tWord.wordStr characterAtIndex:0];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
                    {
                        if ([self hasWordCurrencySymbol:tWord.wordStr])
                        {
                            tWord.wordStr = [self getCurrencyForCurrencyWord:tWord.wordStr];
                            
                            [currencyArr addObject:tWord];
                            
                            isCurrencyFound = TRUE;
                            
                            [addedWord addObject:tWord];
                            
                            [tmpCurrencyArr removeAllObjects];
                        }
                        else if ([self isWordNumeric:tWord.wordStr])
                        {
                            tWord.wordStr = [self getCurrencyForCurrencyWord:tWord.wordStr];
                            
                            [tmpCurrencyArr addObject:tWord];
                        }
                    }
                    else if ([tmpCurrencyArr count] == 1)
                    {
                        if (([tWord.wordStr length] == 1) && [self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:[tWord.wordStr characterAtIndex:0]] intValue]])
                        {
                            TOcr_Word *fWord = (TOcr_Word*) [tmpCurrencyArr lastObject];
                            
                            TOcr_Word *newWord = [[TOcr_Word alloc] init];
                            newWord.wordStr = [fWord.wordStr stringByAppendingFormat:@" %@",tWord.wordStr];
                            float x = fWord.wordRect.origin.x;
                            float y = fWord.wordRect.origin.y;
                            float w = (tWord.wordRect.origin.x - fWord.wordRect.origin.x) + tWord.wordRect.size.width;
                            float h = fWord.wordRect.size.height;
                            newWord.wordRect = CGRectMake(x, y, w, h);
                            
                            [currencyArr addObject:newWord];
                            
                            isCurrencyFound = TRUE;
                            
                            [addedWord addObject:fWord];
                            [addedWord addObject:tWord];
                            
                            [tmpCurrencyArr removeAllObjects];
                        }
                    }
                }
                
            }
            
            tmpCurrencyArr = nil;
            tmpCurrencyArr = [[NSMutableArray alloc] init];
            
            for (int k = 0; k < [words count]; k++)
            {
                TOcr_Word *tWord = (TOcr_Word*)[words objectAtIndex:k];
                
                tWord = [self trimmedStringFromString:tWord forPattern:3];
                
                ///////////////////////////////////////////////////// USD12 , USD12.00 , USD1,234 , USD1,234.00 , USD 12, USD 12.00 , USD 1,234 , USD 1,234.00 /////////////////////////////////////////////////////
                
                if ([tWord.wordStr length] > 0)
                {
                    char fChar = [tWord.wordStr characterAtIndex:0];
                    
                    if ([self isAlphabet:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
                    {
                        if (([tWord.wordStr length] == 3) && [self isCurrencyWord:tWord.wordStr])
                        {
                            [tmpCurrencyArr addObject:tWord];
                        }
                        else if ([tWord.wordStr length] > 3)
                        {
                            unichar forthChar = [tWord.wordStr characterAtIndex:3];
                            
                            if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:forthChar] intValue]])
                            {
                                NSString *currencyWord = [tWord.wordStr substringToIndex:3];
                                
                                if ([self isCurrencyWord:currencyWord])
                                {
                                    for (int i = 3; i < [tWord.wordStr length]; i++)
                                    {
                                        unichar Char = [tWord.wordStr characterAtIndex:i];
                                        
                                        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]] || [[NSNumber numberWithUnsignedShort:Char] intValue] == 44 || [[NSNumber numberWithUnsignedShort:Char] intValue] == 46)
                                        {
                                            currencyWord = [currencyWord stringByAppendingFormat:@"%C",Char];
                                        }
                                        else
                                            break;
                                    }
                                    
                                    tWord.wordStr = currencyWord;
                                    
                                    [currencyArr addObject:tWord];
                                    
                                    isCurrencyFound = TRUE;
                                    
                                    [addedWord addObject:tWord];
                                    
                                    [tmpCurrencyArr removeAllObjects];
                                }
                            }
                        }
                    }
                    else if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]] && [tmpCurrencyArr count] > 0)
                    {
                        NSString *currencyWord = @"";
                        
                        for (int i = 0; i < [tWord.wordStr length]; i++)
                        {
                            unichar Char = [tWord.wordStr characterAtIndex:i];
                            
                            if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]] || [[NSNumber numberWithUnsignedShort:Char] intValue] == 44 || [[NSNumber numberWithUnsignedShort:Char] intValue] == 46)
                            {
                                currencyWord = [currencyWord stringByAppendingFormat:@"%C",Char];
                            }
                            else
                                break;
                        }
                        
                        TOcr_Word *fWord = (TOcr_Word*) [tmpCurrencyArr lastObject];
                        
                        TOcr_Word *newWord = [[TOcr_Word alloc] init];
                        newWord.wordStr = [fWord.wordStr stringByAppendingFormat:@" %@",currencyWord];
                        float x = fWord.wordRect.origin.x;
                        float y = fWord.wordRect.origin.y;
                        float w = (tWord.wordRect.origin.x - fWord.wordRect.origin.x) + tWord.wordRect.size.width;
                        float h = fWord.wordRect.size.height;
                        newWord.wordRect = CGRectMake(x, y, w, h);
                        
                        [currencyArr addObject:newWord];
                        
                        isCurrencyFound = TRUE;
                        
                        [addedWord addObject:fWord];
                        [addedWord addObject:tWord];
                        
                        [tmpCurrencyArr removeAllObjects];
                    }
                }
                
            }
            
            tmpCurrencyArr = nil;
            tmpCurrencyArr = [[NSMutableArray alloc] init];
            
            for (int k = 0; k < [words count]; k++)
            {
                TOcr_Word *tWord = (TOcr_Word*)[words objectAtIndex:k];
                
                tWord = [self trimmedStringFromString:tWord forPattern:4];
                
                ///////////////////////////////////////////////////// 12USD , 12.00USD , 1,234USD , 1,234.00USD , 12 USD, 12.00 USD , 1,234 USD , 1,234.00 USD /////////////////////////////////////////////////////
                
                if ([tWord.wordStr length] > 0)
                {
                    unichar fChar = [tWord.wordStr characterAtIndex:0];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
                    {
                        if ([tWord.wordStr length] > 3)
                        {
                            NSString *currencyWord = [tWord.wordStr substringFromIndex:[tWord.wordStr length]-3];
                            
                            if ([self isCurrencyWord:currencyWord])
                            {
                                [currencyArr addObject:tWord];
                                
                                isCurrencyFound = TRUE;
                                
                                [addedWord addObject:tWord];
                                
                                [tmpCurrencyArr removeAllObjects];
                            }
                            else if ([self isWordNumeric:tWord.wordStr])
                            {
                                [tmpCurrencyArr addObject:tWord];
                            }
                        }
                        else if ([self isWordNumeric:tWord.wordStr])
                        {
                            [tmpCurrencyArr addObject:tWord];
                        }
                    }
                    else if ([self isAlphabet:[[NSNumber numberWithUnsignedShort:fChar] intValue]] && [tmpCurrencyArr count] > 0)
                    {
                        NSString *currencyWord = @"";
                        
                        if (([tWord.wordStr length] == 3) && [self isCurrencyWord:tWord.wordStr])
                        {
                            currencyWord = tWord.wordStr;
                        }
                        else if ([tWord.wordStr length] > 3)
                        {
                            currencyWord = [tWord.wordStr substringToIndex:3];
                            
                            if (![self isCurrencyWord:currencyWord])
                            {
                                currencyWord = @"";
                            }
                        }
                        
                        if ([currencyWord length] == 3)
                        {
                            TOcr_Word *fWord = (TOcr_Word*) [tmpCurrencyArr lastObject];
                            
                            TOcr_Word *newWord = [[TOcr_Word alloc] init];
                            newWord.wordStr = [fWord.wordStr stringByAppendingFormat:@" %@",currencyWord];
                            float x = fWord.wordRect.origin.x;
                            float y = fWord.wordRect.origin.y;
                            float w = (tWord.wordRect.origin.x - fWord.wordRect.origin.x) + tWord.wordRect.size.width;
                            float h = fWord.wordRect.size.height;
                            newWord.wordRect = CGRectMake(x, y, w, h);
                            
                            [currencyArr addObject:newWord];
                            
                            isCurrencyFound = TRUE;
                            
                            [addedWord addObject:fWord];
                            [addedWord addObject:tWord];
                            
                            [tmpCurrencyArr removeAllObjects];
                        }
                    }
                }
                
            }
            
            [tmpCurrencyArr removeAllObjects];
        }
    }
    
    for (int i = 0; i < [dataArr count]; i++)
    {
        NSMutableArray *lines = [dataArr objectAtIndex:i];
        
        if (!isCurrencyFound)
        {
            for (int j = 0; j < [lines count]; j++)
            {
                NSMutableArray *words = [lines objectAtIndex:j];
                
                NSMutableArray *tmpCurrencyArr = [[NSMutableArray alloc] init];
                
                for (int k = 0; k < [words count]; k++)
                {
                    TOcr_Word *tWord = (TOcr_Word*)[words objectAtIndex:k];
                    
                    ///////////////////////////////////////////////////// 12 , 12.00 , 1,234 , 1,234.00  /////////////////////////////////////////////////////
                    
                    if ([tWord.wordStr length] > 0)
                    {
                        if ([self isWordNumeric:tWord.wordStr])
                        {
                            [currencyArr addObject:tWord];
                        }
                        else
                        {
                            NSMutableDictionary *dic = [self hasNumeric:tWord.wordStr];
                            
                            if ([[dic objectForKey:@"hasNum"] isEqualToString:@"T"])
                            {
                                tWord.wordStr = [dic objectForKey:@"word"];
                                
                                [currencyArr addObject:tWord];
                            }
                        }
                    }
                }
                
                [tmpCurrencyArr removeAllObjects];
            }
        }
    }
    
    for (int i = 0; i < [currencyArr count]; i++)
    {
        TOcr_Word *word = (TOcr_Word*)[currencyArr objectAtIndex:i];
     
        NSLog(@"%@",word.wordStr);
    }
    
    if ([currencyArr count] > 0)
    {
        [self performSelectorOnMainThread:@selector(getAndSetTargetCurrency) withObject:nil waitUntilDone:YES];
    }
    else if ((focusBounds.size.width != imageToConvert.size.width) || (focusBounds.size.height != imageToConvert.size.height)) // if no currency found in focus area then try with full image
    {
        focusBounds = CGRectMake(0.0f, 0.0f, imageToConvert.size.width, imageToConvert.size.height);
        
        [NSThread detachNewThreadSelector:@selector(doSomeImageAdjustment) toTarget:self withObject:nil];
        
        return;
    }
    else if (isImageIsUsingForConversionFirstTime)
    {
        [self hideProcessingControls];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Unable to recognize the image" forKey:@"title"];
        [dict setObject:@"Please try to crop different area" forKey:@"message"];
        [dict setObject:@"1" forKey:@"tag"];
        [self performSelectorOnMainThread:@selector(DisplayAlertWithData:) withObject:dict waitUntilDone:YES];
        
        return;
    }
    else
    {
        [self hideProcessingControls];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Unable to recognize the image" forKey:@"title"];
        [dict setObject:@"Please try to retake the image in proper lighting and steady mode" forKey:@"message"];
        [dict setObject:@"2" forKey:@"tag"];
        [self performSelectorOnMainThread:@selector(DisplayAlertWithData:) withObject:dict waitUntilDone:YES];
        
        return;
    }
    
    [self performSelectorOnMainThread:@selector(setUpMenuCardScroller) withObject:nil waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(setInstitutionInfo:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Caxton FX rate",@"name",nil] waitUntilDone:NO];
    
    //    [self setInstitutionInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Caxton FX rate",@"name",nil]];
    [self hideProcessingControls];
}

- (void) getAndSetTargetCurrency
{
    targetCurrency = nil;
    targetCurrency = [self getCurrencyCode];
    
    [self.targetBtn setTitle:[NSString stringWithFormat:@"%@ %@",targetCurrency,[self getCurrencyNameForCurrencyCode:targetCurrency]] forState:UIControlStateNormal];
}

-(void)showProcessingControls
{
    CardsVC *controller = [menuCardViewControllers objectAtIndex:0];
    [controller.imageView setHidden:YES];
    
    [ProcessingLbl setHidden:NO];
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    [self.saveBtn setHidden:YES];
    [self.shareBtn setHidden:YES];
    [self.moreInfoBtn setHidden:YES];
}

-(void)hideProcessingControls
{
     [indicatorView stopAnimating];
    [ProcessingLbl setHidden:YES];
    [indicatorView setHidden:YES];
   
    
    CardsVC *controller = [menuCardViewControllers objectAtIndex:0];
    [controller.imageView setHidden:NO];
    
    [self.saveBtn setHidden:NO];
    [self.shareBtn setHidden:NO];
    [self.moreInfoBtn setHidden:NO];
    
}
- (TOcr_Word*) trimmedStringFromString:(TOcr_Word*) tWord forPattern:(int) pattern
{
    NSString *wordStr = tWord.wordStr;
    
    switch (pattern)
    {
            ///////////////////////////////////////////////////// $12 , $12.00 , $1,234 , $1,234.00 , $ 12 , $ 12.00 , $ 1,234 , $ 1,234.00 /////////////////////////////////////////////////////
        case 1:
        {
            NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"$£¥č€₪лв₨б₩๚"];
            
            NSRange range = [wordStr rangeOfCharacterFromSet:charSet];
            
            if (range.location != NSNotFound && range.location != 0 && range.location+1 < [wordStr length])
            {
                if ([wordStr length] > 1)
                {
                    unichar sChar = [wordStr characterAtIndex:range.location+1];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:sChar] intValue]])
                    {
                        NSString *trimmedStr = [NSString stringWithFormat:@"%C",[wordStr characterAtIndex:range.location]];
                        
                        int i = range.location+1;
                        
                        unichar nChar = [wordStr characterAtIndex:i];
                        
                        while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:nChar] intValue]] || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                        {
                            if ([[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                            {
                                if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                {
                                    break;
                                }
                            }
                            
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",nChar]];
                            
                            i++;
                            
                            if (i < [wordStr length])
                            {
                                nChar = [wordStr characterAtIndex:i];
                            }
                            else
                                break;
                        }
                        
                        TOcr_Word *word = [[TOcr_Word alloc] init];
                        word.wordStr = trimmedStr;
                        
                        float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                        
                        float x;
                        float w;
                        
                        if (range.location != 0)
                        {
                            x = tWord.wordRect.origin.x+(range.location-1)*avgCharLength;
                            w = (i-(range.location-1))*avgCharLength;
                        }
                        else
                        {
                            x = tWord.wordRect.origin.x;
                            w = tWord.wordRect.size.width;
                        }
                        
                        
                        float y = tWord.wordRect.origin.y;
                        float h = tWord.wordRect.size.height;
                        
                        word.wordRect = CGRectMake(x, y, w, h);
                        
                        return word;
                    }
                    else if ([wordStr length] > 2 && [[NSNumber numberWithUnsignedShort:sChar] intValue] == 32)
                    {
                        unichar thChar = [wordStr characterAtIndex:range.location+2];
                        
                        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:thChar] intValue]])
                        {
                            NSString *trimmedStr = [NSString stringWithFormat:@"%C",[wordStr characterAtIndex:range.location]];
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",sChar]];
                            
                            int i = range.location+2;
                            
                            unichar nChar = [wordStr characterAtIndex:i];
                            
                            while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:nChar] intValue]] || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                            {
                                if ([[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                                {
                                    if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                    {
                                        break;
                                    }
                                }
                                
                                trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",nChar]];
                                
                                i++;
                                
                                if (i < [wordStr length])
                                {
                                    nChar = [wordStr characterAtIndex:i];
                                }
                                else
                                    break;
                            }
                            
                            TOcr_Word *word = [[TOcr_Word alloc] init];
                            word.wordStr = trimmedStr;
                            
                            float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                            
                            float x;
                            float w;
                            
                            if (range.location != 0)
                            {
                                x = tWord.wordRect.origin.x+(range.location-1)*avgCharLength;
                                w = (i-(range.location-1))*avgCharLength;
                            }
                            else
                            {
                                x = tWord.wordRect.origin.x;
                                w = tWord.wordRect.size.width;
                            }
                            
                            float y = tWord.wordRect.origin.y;
                            float h = tWord.wordRect.size.height;
                            
                            word.wordRect = CGRectMake(x, y, w, h);
                            
                            return word;
                        }
                    }
                }
            }
        }
            break;
            
            ///////////////////////////////////////////////////// 12$ , 12.00$ , 1,234$ , 1,234.00$ , 12 $ , 12.00 $ , 1,234 $ , 1,234.00 $ /////////////////////////////////////////////////////
        case 2:
        {
            NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"$£¥č€₪лв₨б₩๚"];
            
            NSRange range = [wordStr rangeOfCharacterFromSet:charSet];
            
            if (range.location != NSNotFound && range.location != 0)
            {
                if ([wordStr length] > 1)
                {
                    unichar slChar = [wordStr characterAtIndex:range.location-1];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:slChar] intValue]])
                    {
                        NSString *trimmedStr = [NSString stringWithFormat:@"%C",[wordStr characterAtIndex:range.location]];
                        
                        int i = range.location-1;
                        
                        unichar pChar = [wordStr characterAtIndex:i];
                        
                        while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:pChar] intValue]] || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                        {
                            if ([[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                            {
                                if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                {
                                    break;
                                }
                            }
                            
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",pChar]];
                            
                            i--;
                            
                            if (i >= 0)
                            {
                                pChar = [wordStr characterAtIndex:i];
                            }
                            else
                                break;
                        }
                        
                        NSMutableString *revTrimmedStr = [NSMutableString stringWithCapacity:[trimmedStr length]];
                        
                        [trimmedStr enumerateSubstringsInRange:NSMakeRange(0,[trimmedStr length])
                                                       options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                        [revTrimmedStr appendString:substring];
                                                    }];
                        
                        TOcr_Word *word = [[TOcr_Word alloc] init];
                        word.wordStr = revTrimmedStr;
                        
                        float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                        
                        float x = 0.0f;
                        float w = 0.0f;
                        
                        if ([tWord.wordStr length] == [revTrimmedStr length])
                        {
                            x = tWord.wordRect.origin.x;
                            w = tWord.wordRect.size.width;
                        }
                        else
                        {
                            x = tWord.wordRect.origin.x+(i*avgCharLength);
                            w = ((range.location+1)-(i-1))*avgCharLength;
                        }
                        
                        float y = tWord.wordRect.origin.y;
                        float h = tWord.wordRect.size.height;
                        
                        word.wordRect = CGRectMake(x, y, w, h);
                        
                        return word;
                    }
                    else if ([wordStr length] > 2 && [[NSNumber numberWithUnsignedShort:slChar] intValue] == 32)
                    {
                        unichar thlChar = [wordStr characterAtIndex:range.location-2];
                        
                        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:thlChar] intValue]])
                        {
                            NSString *trimmedStr = [NSString stringWithFormat:@"%C",[wordStr characterAtIndex:range.location]];
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",slChar]];
                            
                            int i = range.location-2;
                            
                            unichar pChar = [wordStr characterAtIndex:i];
                            
                            while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:pChar] intValue]] || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                            {
                                
                                if ([[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                                {
                                    if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                    {
                                        break;
                                    }
                                }
                                
                                trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",pChar]];
                                
                                i--;
                                
                                if (i >= 0)
                                {
                                    pChar = [wordStr characterAtIndex:i];
                                }
                                else
                                    break;
                            }
                            
                            NSMutableString *revTrimmedStr = [NSMutableString stringWithCapacity:[trimmedStr length]];
                            
                            [trimmedStr enumerateSubstringsInRange:NSMakeRange(0,[trimmedStr length])
                                                           options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                                                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                            [revTrimmedStr appendString:substring];
                                                        }];
                            
                            TOcr_Word *word = [[TOcr_Word alloc] init];
                            word.wordStr = revTrimmedStr;
                            
                            float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                            
                            float x = 0.0f;
                            float w = 0.0f;
                            
                            if ([tWord.wordStr length] == [revTrimmedStr length])
                            {
                                x = tWord.wordRect.origin.x;
                                w = tWord.wordRect.size.width;
                            }
                            else
                            {
                                x = tWord.wordRect.origin.x+(i*avgCharLength);
                                w = ((range.location+1)-(i-1))*avgCharLength;
                            }
                            
                            float y = tWord.wordRect.origin.y;
                            float h = tWord.wordRect.size.height;
                            
                            word.wordRect = CGRectMake(x, y, w, h);
                            
                            return word;
                        }
                    }
                }
            }
        }
            break;
            
            ///////////////////////////////////////////////////// USD12 , USD12.00 , USD1,234 , USD1,234.00 , USD 12, USD 12.00 , USD 1,234 , USD 1,234.00 /////////////////////////////////////////////////////
            
        case 3:
        {
            NSRange range = [self rangeOfCurrencyWordInString:wordStr];
            
            if (range.location != NSNotFound && range.location+3 < [wordStr length])
            {
                if ([wordStr length] > 3)
                {
                    unichar foChar = [wordStr characterAtIndex:range.location+3];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:foChar] intValue]])
                    {
                        NSString *trimmedStr = [NSString stringWithFormat:@"%@",[wordStr substringWithRange:range]];
                        
                        int i = range.location+3;
                        
                        unichar nChar = [wordStr characterAtIndex:i];
                        
                        while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:nChar] intValue]] || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                        {
                            if ([[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                            {
                                if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                {
                                    break;
                                }
                            }
                            
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",nChar]];
                            
                            i++;
                            
                            if (i < [wordStr length])
                            {
                                nChar = [wordStr characterAtIndex:i];
                            }
                            else
                                break;
                        }
                        
                        TOcr_Word *word = [[TOcr_Word alloc] init];
                        word.wordStr = trimmedStr;
                        
                        float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                        
                        float x;
                        float w;
                        
                        if (range.location != 0)
                        {
                            x = tWord.wordRect.origin.x+(range.location-1)*avgCharLength;
                            w = (i-(range.location-1))*avgCharLength;
                        }
                        else
                        {
                            x = tWord.wordRect.origin.x;
                            w = tWord.wordRect.size.width;
                        }
                        
                        float y = tWord.wordRect.origin.y;
                        float h = tWord.wordRect.size.height;
                        
                        word.wordRect = CGRectMake(x, y, w, h);
                        
                        return word;
                    }
                    else if ([wordStr length] > 4 && [[NSNumber numberWithUnsignedShort:foChar] intValue] == 32)
                    {
                        unichar fiChar = [wordStr characterAtIndex:range.location+4];
                        
                        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fiChar] intValue]])
                        {
                            NSString *trimmedStr = [NSString stringWithFormat:@"%@",[wordStr substringWithRange:range]];
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",foChar]];
                            
                            int i = range.location+4;
                            
                            unichar nChar = [wordStr characterAtIndex:i];
                            
                            while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:nChar] intValue]] || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                            {
                                if ([[NSNumber numberWithUnsignedShort:nChar] intValue] == 46)
                                {
                                    if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                    {
                                        break;
                                    }
                                }
                                
                                trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",nChar]];
                                
                                i++;
                                
                                if (i < [wordStr length])
                                {
                                    nChar = [wordStr characterAtIndex:i];
                                }
                                else
                                    break;
                            }
                            
                            TOcr_Word *word = [[TOcr_Word alloc] init];
                            word.wordStr = trimmedStr;
                            
                            float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                            
                            float x;
                            float w;
                            
                            if (range.location != 0)
                            {
                                x = tWord.wordRect.origin.x+(range.location-1)*avgCharLength;
                                w = (i-(range.location-1))*avgCharLength;
                            }
                            else
                            {
                                x = tWord.wordRect.origin.x;
                                w = tWord.wordRect.size.width;
                            }
                            
                            float y = tWord.wordRect.origin.y;
                            
                            float h = tWord.wordRect.size.height;
                            
                            word.wordRect = CGRectMake(x, y, w, h);
                            
                            return word;
                        }
                    }
                }
            }
            else if (range.location != NSNotFound && range.location+3 == [wordStr length])
            {
                NSString *trimmedStr = [NSString stringWithFormat:@"%@",[wordStr substringWithRange:range]];
                
                TOcr_Word *word = [[TOcr_Word alloc] init];
                word.wordStr = trimmedStr;
                
                float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                
                float x;
                
                if (range.location != 0)
                {
                    x = tWord.wordRect.origin.x+(range.location-1)*avgCharLength;
                }
                else
                {
                    x = tWord.wordRect.origin.x;
                }
                
                float w = (range.location+1)*avgCharLength;
                
                float y = tWord.wordRect.origin.y;
                float h = tWord.wordRect.size.height;
                
                word.wordRect = CGRectMake(x, y, w, h);
                
                return word;
            }
        }
            break;
            
            ///////////////////////////////////////////////////// 12$ , 12.00$ , 1,234$ , 1,234.00$ , 12 $ , 12.00 $ , 1,234 $ , 1,234.00 $ /////////////////////////////////////////////////////
            
        case 4:
        {
            NSRange range = [self rangeOfCurrencyWordInString:wordStr];
            
            if (range.location != NSNotFound && range.location != 0)
            {
                if ([wordStr length] > 3)
                {
                    unichar flChar = [wordStr characterAtIndex:range.location-1];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:flChar] intValue]])
                    {
                        NSString *trimmedStr = @"";
                        
                        int i = range.location-1;
                        
                        unichar pChar = [wordStr characterAtIndex:i];
                        
                        while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:pChar] intValue]] || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                        {
                            if ([[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                            {
                                if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                {
                                    break;
                                }
                            }
                            
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",pChar]];
                            
                            i--;
                            
                            if (i >= 0)
                            {
                                pChar = [wordStr characterAtIndex:i];
                            }
                            else
                                break;
                        }
                        
                        NSMutableString *revTrimmedStr = [NSMutableString stringWithCapacity:[trimmedStr length]];
                        
                        [trimmedStr enumerateSubstringsInRange:NSMakeRange(0,[trimmedStr length])
                                                       options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                        [revTrimmedStr appendString:substring];
                                                    }];
                        
                        NSString *finalStr = [NSString stringWithFormat:@"%@%@",revTrimmedStr,[wordStr substringWithRange:range]];
                        
                        TOcr_Word *word = [[TOcr_Word alloc] init];
                        word.wordStr = finalStr;
                        
                        float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                        
                        float x = 0.0f;
                        float w = 0.0f;
                        
                        if ([tWord.wordStr length] == [revTrimmedStr length])
                        {
                            x = tWord.wordRect.origin.x;
                            w = tWord.wordRect.size.width;
                        }
                        else
                        {
                            x = tWord.wordRect.origin.x+(i*avgCharLength);
                            w = ((range.location+1)-(i-1))*avgCharLength;
                        }
                        
                        float y = tWord.wordRect.origin.y;
                        float h = tWord.wordRect.size.height;
                        
                        word.wordRect = CGRectMake(x, y, w, h);
                        
                        return word;
                    }
                    else if ([wordStr length] > 4 && [[NSNumber numberWithUnsignedShort:flChar] intValue] == 32)
                    {
                        unichar thlChar = [wordStr characterAtIndex:range.location-2];
                        
                        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:thlChar] intValue]])
                        {
                            NSString *trimmedStr = [NSString stringWithFormat:@"%@",[wordStr substringWithRange:range]];
                            trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",flChar]];
                            
                            int i = range.location-2;
                            
                            unichar pChar = [wordStr characterAtIndex:i];
                            
                            while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:pChar] intValue]] || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 44 || [[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                            {
                                
                                if ([[NSNumber numberWithUnsignedShort:pChar] intValue] == 46)
                                {
                                    if ([trimmedStr rangeOfString:@"."].location != NSNotFound)
                                    {
                                        break;
                                    }
                                }
                                
                                trimmedStr = [trimmedStr stringByAppendingString:[NSString stringWithFormat:@"%C",pChar]];
                                
                                i--;
                                
                                if (i >= 0)
                                {
                                    pChar = [wordStr characterAtIndex:i];
                                }
                                else
                                    break;
                            }
                            
                            NSMutableString *revTrimmedStr = [NSMutableString stringWithCapacity:[trimmedStr length]];
                            
                            [trimmedStr enumerateSubstringsInRange:NSMakeRange(0,[trimmedStr length])
                                                           options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                                                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                            [revTrimmedStr appendString:substring];
                                                        }];
                            
                            TOcr_Word *word = [[TOcr_Word alloc] init];
                            word.wordStr = revTrimmedStr;
                            
                            float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                            
                            float x = 0.0f;
                            float w = 0.0f;
                            
                            if ([tWord.wordStr length] == [revTrimmedStr length])
                            {
                                x = tWord.wordRect.origin.x;
                                w = tWord.wordRect.size.width;
                            }
                            else
                            {
                                x = tWord.wordRect.origin.x+(i*avgCharLength);
                                w = ((range.location+1)-(i-1))*avgCharLength;
                            }
                            
                            float y = tWord.wordRect.origin.y;
                            float h = tWord.wordRect.size.height;
                            
                            word.wordRect = CGRectMake(x, y, w, h);
                            
                            return word;
                        }
                    }
                }
            }
            else
            {
                NSString *trimmedStr = [NSString stringWithFormat:@"%@",[wordStr substringWithRange:range]];
                
                TOcr_Word *word = [[TOcr_Word alloc] init];
                word.wordStr = trimmedStr;
                
                float avgCharLength = tWord.wordRect.size.width/wordStr.length;
                
                float x;
                
                if (range.location != 0)
                {
                    x = tWord.wordRect.origin.x+(range.location-1)*avgCharLength;
                }
                else
                {
                    x = tWord.wordRect.origin.x;
                }
                
                float w = (range.location+1)*avgCharLength;
                
                float y = tWord.wordRect.origin.y;
                float h = tWord.wordRect.size.height;
                
                word.wordRect = CGRectMake(x, y, w, h);
                
                return word;
            }
        }
            break;
            
        default:
            break;
    }
    
    return tWord;
}

- (NSRange) rangeOfCurrencyWordInString:(NSString*) wordStr
{
    NSRange range = NSMakeRange(0, 0);
    
    if ([wordStr rangeOfString:@"USD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"USD"];
    else if ([wordStr rangeOfString:@"AUD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"AUD"];
    else if ([wordStr rangeOfString:@"BHD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"BHD"];
    else if ([wordStr rangeOfString:@"BRL"].location != NSNotFound)
        range = [wordStr rangeOfString:@"BRL"];
    else if ([wordStr rangeOfString:@"GBP"].location != NSNotFound)
        range = [wordStr rangeOfString:@"GBP"];
    else if ([wordStr rangeOfString:@"BND"].location != NSNotFound)
        range = [wordStr rangeOfString:@"BND"];
    else if ([wordStr rangeOfString:@"CAD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"CAD"];
    else if ([wordStr rangeOfString:@"CLP"].location != NSNotFound)
        range = [wordStr rangeOfString:@"CLP"];
    else if ([wordStr rangeOfString:@"CNY"].location != NSNotFound)
        range = [wordStr rangeOfString:@"CNY"];
    else if ([wordStr rangeOfString:@"CZK"].location != NSNotFound)
        range = [wordStr rangeOfString:@"CZK"];
    else if ([wordStr rangeOfString:@"DKK"].location != NSNotFound)
        range = [wordStr rangeOfString:@"DKK"];
    else if ([wordStr rangeOfString:@"EUR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"EUR"];
    else if ([wordStr rangeOfString:@"HKD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"HKD"];
    else if ([wordStr rangeOfString:@"HUF"].location != NSNotFound)
        range = [wordStr rangeOfString:@"HUF"];
    else if ([wordStr rangeOfString:@"ISK"].location != NSNotFound)
        range = [wordStr rangeOfString:@"ISK"];
    else if ([wordStr rangeOfString:@"INR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"INR"];
    else if ([wordStr rangeOfString:@"IDR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"IDR"];
    else if ([wordStr rangeOfString:@"ILS"].location != NSNotFound)
        range = [wordStr rangeOfString:@"ILS"];
    else if ([wordStr rangeOfString:@"JPY"].location != NSNotFound)
        range = [wordStr rangeOfString:@"JPY"];
    else if ([wordStr rangeOfString:@"KZT"].location != NSNotFound)
        range = [wordStr rangeOfString:@"KZT"];
    else if ([wordStr rangeOfString:@"KWD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"KWD"];
    else if ([wordStr rangeOfString:@"MYR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"MYR"];
    else if ([wordStr rangeOfString:@"MUR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"MUR"];
    else if ([wordStr rangeOfString:@"MXN"].location != NSNotFound)
        range = [wordStr rangeOfString:@"MXN"];
    else if ([wordStr rangeOfString:@"NPR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"NPR"];
    else if ([wordStr rangeOfString:@"TWD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"TWD"];
    else if ([wordStr rangeOfString:@"NZD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"NZD"];
    else if ([wordStr rangeOfString:@"NOK"].location != NSNotFound)
        range = [wordStr rangeOfString:@"NOK"];
    else if ([wordStr rangeOfString:@"PKR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"PKR"];
    else if ([wordStr rangeOfString:@"QAR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"QAR"];
    else if ([wordStr rangeOfString:@"RUB"].location != NSNotFound)
        range = [wordStr rangeOfString:@"RUB"];
    else if ([wordStr rangeOfString:@"SAR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"SAR"];
    else if ([wordStr rangeOfString:@"SGD"].location != NSNotFound)
        range = [wordStr rangeOfString:@"SGD"];
    else if ([wordStr rangeOfString:@"ZAR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"ZAR"];
    else if ([wordStr rangeOfString:@"KPW"].location != NSNotFound)
        range = [wordStr rangeOfString:@"KPW"];
    else if ([wordStr rangeOfString:@"LKR"].location != NSNotFound)
        range = [wordStr rangeOfString:@"LKR"];
    else if ([wordStr rangeOfString:@"SEK"].location != NSNotFound)
        range = [wordStr rangeOfString:@"SEK"];
    else if ([wordStr rangeOfString:@"CHF"].location != NSNotFound)
        range = [wordStr rangeOfString:@"CHF"];
    else if ([wordStr rangeOfString:@"THB"].location != NSNotFound)
        range = [wordStr rangeOfString:@"THB"];
    else if ([wordStr rangeOfString:@"AED"].location != NSNotFound)
        range = [wordStr rangeOfString:@"AED"];
    
    return range;
}

- (NSString*) getCurrencyForCurrencyWord:(NSString*) currencyWord
{
    unichar fChar = [currencyWord characterAtIndex:0];
    
    if ([self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
    {
        NSString *currency = [NSString stringWithFormat:@"%C",[currencyWord characterAtIndex:0]];
        
        int i = 1;
        
        unichar Char = [currencyWord characterAtIndex:i];
        
        while ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]] || [[NSNumber numberWithUnsignedShort:Char] intValue] == 44 || [[NSNumber numberWithUnsignedShort:Char] intValue] == 46)
        {
            currency = [currency stringByAppendingFormat:@"%C",Char];
            
            i++;
            
            if (i < [currencyWord length])
                Char = [currencyWord characterAtIndex:i];
            else
                break;
        }
        
        return currency;
    }
    else if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
    {
        NSString *currency = @"";
        
        for (int i = 0; i < [currencyWord length]; i++)
        {
            unichar Char = [currencyWord characterAtIndex:i];
            
            if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]] || [[NSNumber numberWithUnsignedShort:Char] intValue] == 44 || [[NSNumber numberWithUnsignedShort:Char] intValue] == 46)
            {
                currency = [currency stringByAppendingFormat:@"%C",Char];
            }
            else if ([self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:Char] intValue]])
            {
                currency = [currency stringByAppendingFormat:@"%C",Char];
            }
            else
                break;
        }
        
        return currency;
    }
    
    return @"";
}

- (BOOL) hasWordCurrencySymbol:(NSString*) currencyWord
{
    BOOL hasSymbol = FALSE;
    
    for (int i = 0; i < [currencyWord length]; i++)
    {
        unichar Char = [currencyWord characterAtIndex:i];
        
        if ([self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:Char] intValue]])
        {
            hasSymbol = TRUE;
        }
    }
    
    return hasSymbol;
}

- (BOOL) isWordNumeric:(NSString*) currencyWord
{
    BOOL hasSymbol = TRUE;
    
    for (int i = 0; i < [currencyWord length]; i++)
    {
        unichar Char = [currencyWord characterAtIndex:i];
        
        if (![self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]] && [[NSNumber numberWithUnsignedShort:Char] intValue] != 44 && [[NSNumber numberWithUnsignedShort:Char] intValue] != 46)
        {
            hasSymbol = FALSE;
        }
    }
    
    return hasSymbol;
}

- (BOOL) isOnlyCurrencySymbol:(NSString*) currencyWord
{
    BOOL isSymbol = FALSE;
    
    for (int i = 0; i < [currencyWord length]; i++)
    {
        unichar Char = [currencyWord characterAtIndex:i];
        
        if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]])
        {
            return isSymbol;
        }
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"$£¥č€₪лв₨б₩๚"];
    
    set = [set invertedSet];
    
    currencyWord = [[currencyWord componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    
    NSArray *symbols = [NSArray arrayWithObjects:@"$",@"£",@"¥",@"č",@"€",@"₪",@"л",@"в",@"₨",@"б",@"₩",@"๚", nil];
    
    if ([symbols containsObject:currencyWord])
        isSymbol = TRUE;
    
    return isSymbol;
}

- (NSMutableDictionary *) hasNumeric:(NSString*) currencyWord
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"F" forKey:@"hasNum"];
    
    BOOL hasNumeric = FALSE;
    
    NSString *wordStr = @"";
    
    for (int i = 0; i < [currencyWord length]; i++)
    {
        unichar Char = [currencyWord characterAtIndex:i];
        
        if (Char)
        {
            if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]])
            {
                hasNumeric = TRUE;
                
                wordStr = [wordStr stringByAppendingFormat:@"%C",Char];
            }
            else if ([[NSNumber numberWithUnsignedShort:Char] intValue] == 44 && hasNumeric)
            {
                wordStr = [wordStr stringByAppendingFormat:@"%C",Char];
            }
            else if ([[NSNumber numberWithUnsignedShort:Char] intValue] == 46)
            {
                wordStr = [wordStr stringByAppendingFormat:@"%C",Char];
            }
            else if ([wordStr length] != 0)
            {
                break;
            }
        }
    }
    
    if (hasNumeric)
    {
        [dic setObject:@"T" forKey:@"hasNum"];
        
        [dic setObject:wordStr forKey:@"word"];
    }
    
    return dic;
}

- (void) doSomeImageAdjustment
{
    [self showProcessingControls]
    ;
    UIImage *image = imageToConvert;
    
    CGImageRef cr = CGImageCreateWithImageInRect([image CGImage], focusBounds);
	
	UIImage *croppedImage = [UIImage imageWithCGImage:cr];
    
    NSData *data = UIImageJPEGRepresentation(croppedImage, 0.0f);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *filePath = [docDir stringByAppendingPathComponent:@"sample.jpg"];
    
    [data writeToFile:filePath atomically:TRUE];
    
    [CommonFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",filePath]]];
    
    croppedImage = [UIImage imageWithData:data];
    
    [imgView setImage:croppedImage];
    
    [self extractingDataFromImage:croppedImage];
}

- (void) startRecognization:(UIImage*) image
{
    [self recognizeImage:image];
    //Saurabh
}

- (void) recognizeImage:(UIImage*)image
{
    if( image != nil ) {
		imgView.image = image;
	}
	
	[self onBeforeRecognition];
}

- (IBAction) currencyPickerBtnTap:(id)sender
{
    UIButton *btn = (UIButton*) sender;
    
    switch (btn.tag) {
        case 1:
        {
            TargetCurrencyVC *currencyVC = [[TargetCurrencyVC alloc]initWithNibName:@"TargetCurrencyVC" bundle:nil];
            [self.navigationController pushViewController:currencyVC animated:YES];
        }
            break;
        case 2:
        {
            fromConversionSection = @"YES";
            BaseCurrencyVC *currencyVC = [[BaseCurrencyVC alloc]initWithNibName:@"BaseCurrencyVC" bundle:nil];
            [self.navigationController pushViewController:currencyVC animated:YES];
            
        }
            break;
        default:
            break;
    }
}

- (IBAction) pullViewBtnTap:(id)sender
{
    [pullViewDownBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [preferredBtn setUserInteractionEnabled:FALSE];
    [targetBtn setUserInteractionEnabled:FALSE];
    
    int page = menuPageControl.pageControl.currentPage;
    
    CGRect frame = bankScroller.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [bankScroller scrollRectToVisible:frame animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4f];
    [self.pullView setFrame:CGRectMake(0.0, 50.0f, 320.0f, 200.0f)];
    [UIView commitAnimations];
}

- (IBAction) hidePullViewBtnTap:(id)sender
{
    [preferredBtn setUserInteractionEnabled:TRUE];
    [targetBtn setUserInteractionEnabled:TRUE];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4f];
    [self.pullView setFrame:CGRectMake(0.0, -150.0f, 320.0f, 200.0f)];
    [UIView commitAnimations];
    
    [self performSelector:@selector(setImageForDownArrowBtn) withObject:nil afterDelay:0.7f];
}

- (void) setInstitutionInfo:(NSDictionary*) dic
{
    [self.institutionNameLbl setText:[dic objectForKey:@"name"]];
    
    if ([targetCurrency length] > 0)
    {
        [self.rateLbl setText:[NSString stringWithFormat:@"Rate %@ %@1 = %@ %@%.02f",targetCurrency,[self getCurrencyNameForCurrencyCode:targetCurrency],(preferredCurrency.length !=0)?preferredCurrency:@"",[self getCurrencyNameForCurrencyCode:preferredCurrency],[self getConversionMultiplier]]];
    }
    else
        [self.rateLbl setText:@""];
}

- (void) setImageForDownArrowBtn
{
    [pullViewDownBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
}

- (void) leftBtnTap:(id) sender
{
    NSLog(@"controllers : %@",self.navigationController.viewControllers);
    
    [[self navigationController] popViewControllerAnimated:YES];
    return;
    NSArray *arr = [AppDelegate getSharedInstance].mainNavigation.viewControllers;
    
    ImagePickerVC *ipvc = nil;
    
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    
    [ipvc showCamera];
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = 2;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate window] setRootViewController:[delegate tabBarController]];
    delegate.tabBarController.selectedIndex = 1;
    [delegate customTabBarBtnTap:btn];
    
}

-(void)captureBtnTap:(id) sender
{
    _pathToData = nil;
	
    //Saurabh
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *arr = delegate.mainNavigation.viewControllers;
    
    ImagePickerVC *ipvc = nil;
    
    for (int i = 0; i < [arr count]; i++)
    {
        if ([[arr objectAtIndex:i] isKindOfClass:[ImagePickerVC class]])
        {
            ipvc = (ImagePickerVC*) [arr objectAtIndex:i];
        }
    }
    
    [ipvc showCamera];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction) shareButtonTap:(id) sender
{
    [self showActionSheet];
}

#define shouldUseDelegateExample 1
- (void)showActionSheet {
    
    JJGActionSheet *actionSheet = [[JJGActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"" primaryButtonTitle:@"" destructiveButtonTitle:@"" otherButtonTitles:@"", nil];
    if (shouldUseDelegateExample) {
        actionSheet.delegate = self;
    } else {
        actionSheet.callbackBlock = ^(JJGActionSheetCallbackType type, NSInteger buttonIndex, NSString *buttonTitle) {
            switch (type) {
                case JJGActionSheetCallbackTypeClickedButtonAtIndex:
                    NSLog(@"RDActionSheetCallbackTypeClickedButtonAtIndex %d, title %@", buttonIndex, buttonTitle);
                    break;
                case JJGActionSheetCallbackTypeDidDismissWithButtonIndex:
                    NSLog(@"RDActionSheetCallbackTypeDidDismissWithButtonIndex %d, title %@", buttonIndex, buttonTitle);
                    break;
                case JJGActionSheetCallbackTypeWillDismissWithButtonIndex:
                    NSLog(@"RDActionSheetCallbackTypeWillDismissWithButtonIndex %d, title %@", buttonIndex, buttonTitle);
                    break;
                case JJGActionSheetCallbackTypeDidPresentActionSheet:
                    NSLog(@"RDActionSheetCallbackTypeDidPresentActionSheet");
                    break;
                case JJGActionSheetCallbackTypeWillPresentActionSheet:
                    NSLog(@"RDActionSheetCallbackTypeDidPresentActionSheet");
                    break;
            }
        };
    }
    [actionSheet showFrom:self.view];
}
-(void)actionSheet:(JJGActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"didDismissWithButtonIndex %d", buttonIndex);
}

-(void)actionSheet:(JJGActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"willDismissWithButtonIndex %d", buttonIndex);
}

-(void)willPresentActionSheet:(JJGActionSheet *)actionSheet {
    NSLog(@"willPresentActionSheet");
}

-(void)didPresentActionSheet:(JJGActionSheet *)actionSheet {
    NSLog(@"didPresentActionSheet");
}

-(void)actionSheet:(JJGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            
            [self fbBtnPressed];
            break;
        case 2:
            
            [self twitterBtnPressed];
            break;
        case 3:
            
            [self shareMail];
            break;
            
        case 0:
            
            break;
        default:
            break;
    }
    
}

-(void)shareMail
{
   
    CardsVC *cvc = (CardsVC*)[menuCardViewControllers objectAtIndex:menuPageControl.pageControl.currentPage];
    NSData *myData = UIImagePNGRepresentation(cvc.imageView.image);
  
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
             [controller addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
            [controller setMessageBody:@"I’ve just used the Caxton FX travel app that makes holiday spending simple. Convert currency in a snap of a photo and manage a Caxton FX account on the move. Download yours here. https://itunes.apple.com/us/app/caxtonfx-app/id687286642?ls=1&mt=8" isHTML:NO];
             
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Setup mail account in email in setting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 505;
            [alert show];
        }
    }
}
#pragma mark -
#pragma mark Compose Mail

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:@"Success!"
                                    message:@"Your message has been sent. Thanks for your feedback."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
       
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


-(void)fbBtnPressed
{
    CardsVC *cvc = (CardsVC*)[menuCardViewControllers objectAtIndex:menuPageControl.pageControl.currentPage];
    
       if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController setInitialText:@"I’ve just used the Caxton FX travel app that makes holiday spending simple. Convert currency in a snap of a photo and manage a Caxton FX account on the move. Download yours here. https://itunes.apple.com/us/app/caxtonfx-app/id687286642?ls=1&mt=8"];
        [composeController addImage:cvc.imageView.image];
        [self.navigationController presentViewController:composeController
                                    animated:YES completion:nil];
        
        [composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                {
                    output = @"Post Successful";
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:output delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     alert.tag = 505;
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

-(void)twitterBtnPressed
{
   CardsVC *cvc = (CardsVC*)[menuCardViewControllers objectAtIndex:menuPageControl.pageControl.currentPage];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
         [composeController addImage:cvc.imageView.image];
//        [composeController setInitialText:@"I’ve just used the Caxton FX travel app. Convert currency in a snap of a photo and manage a Caxton FX account on the move. #CaxtonCurrency"];
        
        //this is dummy text bcoz we share only 100 char with image share so change text with provided by client 
        [composeController setInitialText:@"I’ve just used the Caxton FX card app to convert currency in the snap of a photo #CaxtonCurrency."];
        
        [self.navigationController presentViewController:composeController
                                    animated:YES completion:nil];
        
        [composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    //output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                {
                    output = @"Post Successful";
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:output delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     alert.tag = 505;
                    [alert show];
                }
                    break;
                default:
                    break;
                    
            }
        }];
    }
}



-(void)displayHint
{
    [UIView animateWithDuration:1.0 animations:^{
        self.toolTipImgView.alpha = 0.0;
        self.toolTipLbl.alpha = 0.0;
        _saveBtn.userInteractionEnabled = YES;
        [_saveBtn setImage:[UIImage imageNamed:@"s_saveRight"] forState:UIControlStateNormal];
    }];
}

- (IBAction) moreInfoButtonTap:(id) sender
{
    if([CommonFunctions reachabiltyCheck])
    {
        self.view.userInteractionEnabled = NO;
        [self performSelectorInBackground:@selector(callGetPromoApi) withObject:nil];
        
    }else
    {
        MoreInfoVC *tempVC = [[MoreInfoVC alloc] init];
        [[self navigationController] pushViewController:tempVC animated:YES];
    }
}
-(void)callGetPromoApi
{
    sharedManager *manger = [[sharedManager alloc]init];
    manger.delegate = self;
    NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetPromo/></soapenv:Body></soapenv:Envelope>";
    
    [manger callServiceWithRequest:soapMessage methodName:@"GetPromo" andDelegate:self];
}
- (IBAction) saveButtonTap:(id) sender
{
    [self.toolTipLbl setFont:[UIFont fontWithName:@"OpenSans" size:11.0f]];
    self.toolTipImgView.alpha = 1.0;
    self.toolTipLbl.alpha = 1.0;
    // instantaneously make the image view small (scaled to 1% of its actual size)
    self.toolTipImgView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.toolTipLbl.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.toolTipImgView.transform = CGAffineTransformIdentity;
        self.toolTipLbl.transform = CGAffineTransformIdentity;
        _saveBtn.userInteractionEnabled = NO;
        [_saveBtn setImage:[UIImage imageNamed:@"s_saveRightHover"] forState:UIControlStateNormal];
        
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        [self performSelector:@selector(displayHint) withObject:nil afterDelay:7];
        
        NSDate *currentDate=[NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd-MM-yyyy,hh:mm:a"]; //12hr time format
        NSString *strDate  = [outputFormatter stringFromDate:currentDate];
        
        [outputFormatter setDateFormat:@"dd/MM/yyyy"]; //12hr time format
        
        [self downloadImageToDirectory:strDate];
        
        NSString *str =[NSString stringWithFormat:@"(%@1 = %@%.02f)",[self getCurrencyNameForCurrencyCode:targetCurrency],[self getCurrencyNameForCurrencyCode:preferredCurrency],[self getConversionMultiplier]];
        NSString *query1 = [NSString stringWithFormat:@"insert into conversionHistoryTable (base,target,conversionValue,imageName,date,conversionRate) values('%@','%@','%@','%@','%@','%@')",preferredCurrency,targetCurrency,str,[NSString stringWithFormat:@"%@.png",strDate],[outputFormatter stringFromDate:currentDate],rateLbl.text];
        NSLog(@"qyr: %@",query1);
        NSLog(@"str conversionValue ->%@",str);
        [[DatabaseHandler getSharedInstance] executeQuery:query1];
    }];
    
}

-(void)downloadImageToDirectory:(NSString *)imageName
{
    //NSError *error;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *patientPhotoFolder = [documentsDirectory stringByAppendingPathComponent:@"patientPhotoFolder"];
    // STORING IMAGE IN DOCUMENT DIRECTORY
    NSString *dataPath = patientPhotoFolder;
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:dataPath
                           isDirectory:&isDir] && isDir == NO) {
        [fileManager createDirectoryAtPath:dataPath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
        
        // iCloude backup
        [CommonFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",dataPath]]];
    }
    
    CardsVC *cvc = (CardsVC*)[menuCardViewControllers objectAtIndex:menuPageControl.pageControl.currentPage];
    
    NSData* imageData = UIImagePNGRepresentation(cvc.imageView.image);
    
    NSString* incrementedImgStr = [NSString stringWithFormat:@"%@.png",imageName];
    NSLog(@"increment image str : %@",incrementedImgStr);
    NSString* fullPathToFile2 = [dataPath stringByAppendingPathComponent:incrementedImgStr];
    NSLog(@"fullPathToFile2 str : %@",fullPathToFile2);
    
    [imageData writeToFile:fullPathToFile2 atomically:NO];
    [CommonFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",fullPathToFile2]]];
    //Saurabh
}

- (void) setUpBankScroller
{
    //add CFX Global Rate card
    UIImageView *cardBg = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, 12.0f, 261.0f, 156.0f)];
    [cardBg setBackgroundColor:[UIColor clearColor]];
    [cardBg setImage:[UIImage imageNamed:@"card"]];
    [self.bankScroller addSubview:cardBg];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 17.0f, 200.0f, 18.0f)];
    [nameLbl setBackgroundColor:[UIColor clearColor]];
    [nameLbl setFont:[UIFont systemFontOfSize:15.0f]];
    [nameLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
    [nameLbl setText:@"CFX Global Rate"];
    
    
    [self.bankScroller addSubview:nameLbl];
    
    UILabel *productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 35.0f, 200.0f, 15.0f)];
    [productNameLbl setBackgroundColor:[UIColor clearColor]];
    [productNameLbl setFont:[UIFont systemFontOfSize:10.0f]];
    [productNameLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
    [productNameLbl setText:@"Currency Conversion API"];
    [self.bankScroller addSubview:productNameLbl];
    
    UIButton *cardBtn = [[UIButton alloc] initWithFrame:CGRectMake(30.0f, 12.0f, 261.0f, 156.0f)];
    [cardBtn setBackgroundColor:[UIColor clearColor]];
    [cardBtn addTarget:self action:@selector(bankBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [cardBtn setTag:0];
    [self.bankScroller addSubview:cardBtn];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    float x = 320.0f;
    
    if ([defs objectForKey:@"selectedBanks"])
    {
        NSString *selectedBanks = [defs objectForKey:@"selectedBanks"];
        
        NSArray *arr = [selectedBanks componentsSeparatedByString:@","];
        
        if ([arr count]>0)
        {
            [self getSelectedBanksDetail:arr];
            
            for (int i = 0; i < [bankArr count]; i++)
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:i];
                
                UIImageView *cardBg = [[UIImageView alloc] initWithFrame:CGRectMake(x+30.0f, 12.0f, 261.0f, 156.0f)];
                [cardBg setBackgroundColor:[UIColor clearColor]];
                [cardBg setImage:[UIImage imageNamed:@"card"]];
                [self.bankScroller addSubview:cardBg];
                
                UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f, 17.0f, 200.0f, 18.0f)];
                [nameLbl setBackgroundColor:[UIColor clearColor]];
                [nameLbl setFont:[UIFont systemFontOfSize:15.0f]];
                [nameLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
                [nameLbl setText:[dic objectForKey:@"name"]];
                [self.bankScroller addSubview:nameLbl];
                
                UILabel *productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f, 35.0f, 200.0f, 15.0f)];
                [productNameLbl setBackgroundColor:[UIColor clearColor]];
                [productNameLbl setFont:[UIFont systemFontOfSize:10.0f]];
                [productNameLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
                [productNameLbl setText:[dic objectForKey:@"productName"]];
                [self.bankScroller addSubview:productNameLbl];
                
                UILabel *ratesHeadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f, 67.0f, 200.0f, 15.0f)];
                [ratesHeadingLbl setBackgroundColor:[UIColor clearColor]];
                [ratesHeadingLbl setFont:[UIFont systemFontOfSize:10.0f]];
                [ratesHeadingLbl setTextColor:UIColorFromRedGreenBlue(77.0f, 77.0f, 77.0f)];
                [ratesHeadingLbl setText:@"*Rates"];
                [self.bankScroller addSubview:ratesHeadingLbl];
                
                UILabel *transFeeHeadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f, 82.0f, 110.0f, 15.0f)];
                [transFeeHeadingLbl setBackgroundColor:[UIColor clearColor]];
                [transFeeHeadingLbl setFont:[UIFont systemFontOfSize:12.0f]];
                [transFeeHeadingLbl setTextColor:UIColorFromRedGreenBlue(77.0f, 77.0f, 77.0f)];
                [transFeeHeadingLbl setText:@"Transaction Fee:"];
                [self.bankScroller addSubview:transFeeHeadingLbl];
                
                UILabel *transFeeValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f + 110.0f, 82.0f, 90.0f, 15.0f)];
                [transFeeValueLbl setBackgroundColor:[UIColor clearColor]];
                [transFeeValueLbl setFont:[UIFont systemFontOfSize:12.0f]];
                [transFeeValueLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
                [transFeeValueLbl setText:[NSString stringWithFormat:@"%@%% Charge",[dic objectForKey:@"transactionFee"]]];
                [self.bankScroller addSubview:transFeeValueLbl];
                
                UILabel *conversionFeeHeadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f, 97.0f, 110.0f, 15.0f)];
                [conversionFeeHeadingLbl setBackgroundColor:[UIColor clearColor]];
                [conversionFeeHeadingLbl setFont:[UIFont systemFontOfSize:12.0f]];
                [conversionFeeHeadingLbl setTextColor:UIColorFromRedGreenBlue(77.0f, 77.0f, 77.0f)];
                [conversionFeeHeadingLbl setText:@"Conversion Fee:"];
                [self.bankScroller addSubview:conversionFeeHeadingLbl];
                
                UILabel *conversionFeeValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f + 110.0f, 97.0f, 90.0f, 15.0f)];
                [conversionFeeValueLbl setBackgroundColor:[UIColor clearColor]];
                [conversionFeeValueLbl setFont:[UIFont systemFontOfSize:12.0f]];
                [conversionFeeValueLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
                [conversionFeeValueLbl setText:[NSString stringWithFormat:@"%@%% Charge",[dic objectForKey:@"conversionFee"]]];
                [self.bankScroller addSubview:conversionFeeValueLbl];
                
                UILabel *oneOffFeeHeadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f, 112.0f, 110.0f, 15.0f)];
                [oneOffFeeHeadingLbl setBackgroundColor:[UIColor clearColor]];
                [oneOffFeeHeadingLbl setFont:[UIFont systemFontOfSize:12.0f]];
                [oneOffFeeHeadingLbl setTextColor:UIColorFromRedGreenBlue(77.0f, 77.0f, 77.0f)];
                [oneOffFeeHeadingLbl setText:@"One off Fee:"];
                [self.bankScroller addSubview:oneOffFeeHeadingLbl];
                
                UILabel *oneOffFeeValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + 45.0f + 110.0f, 112.0f, 90.0f, 15.0f)];
                [oneOffFeeValueLbl setBackgroundColor:[UIColor clearColor]];
                [oneOffFeeValueLbl setFont:[UIFont systemFontOfSize:12.0f]];
                [oneOffFeeValueLbl setTextColor:UIColorFromRedGreenBlue(0.0f, 102.0f, 153.0f)];
                [oneOffFeeValueLbl setText:[NSString stringWithFormat:@"%@%% Charge",[dic objectForKey:@"oneOffFee"]]];
                [self.bankScroller addSubview:oneOffFeeValueLbl];
                
                UIButton *cardBtn = [[UIButton alloc] initWithFrame:CGRectMake(x+30.0f, 12.0f, 261.0f, 156.0f)];
                [cardBtn setBackgroundColor:[UIColor clearColor]];
                [cardBtn addTarget:self action:@selector(bankBtnTap:) forControlEvents:UIControlEventTouchUpInside];
                [cardBtn setTag:i+1];
                [self.bankScroller addSubview:cardBtn];
                
                x = x + 320.0f;
            }
        }
    }
    
    UIButton *addNewBtn = [[UIButton alloc] initWithFrame:CGRectMake(x+30.0f, 12.0f, 261.0f, 156.0f)];
    [addNewBtn setBackgroundColor:[UIColor clearColor]];
    [addNewBtn setImage:[UIImage imageNamed:@"addNewBank"] forState:UIControlStateNormal];
    [addNewBtn addTarget:self action:@selector(addNewBankBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.bankScroller addSubview:addNewBtn];
    
    x = x + 320.0f;
    
    [bankPageControl.pageControl setPageControlStyle:PageControlStyleThumb];
    [bankPageControl.pageControl setThumbImage:[UIImage imageNamed:@"gray_round"]];
    [bankPageControl.pageControl setSelectedThumbImage:[UIImage imageNamed:@"blue_round"]];
    [bankPageControl.pageControl setNumberOfPages:2+[bankArr count]];
    
    [bankPageControl setNeedsLayout];
    
    [self.bankScroller setPagingEnabled:TRUE];
    [self.bankScroller setContentSize:CGSizeMake(x, 195.0f)];
}

- (void) setUpMenuCardScroller
{
    for (UIView *v in self.menuScroller.subviews)
    {
        [v removeFromSuperview];
    }
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    NSString *selectedBanks = [defs objectForKey:@"selectedBanks"];
    
    NSArray *arr = [selectedBanks componentsSeparatedByString:@","];
    
    kNumberOfPages = 1 + [arr count];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    
    menuCardViewControllers = controllers;
    
    // a page is the width of the scroll view
    menuScroller.pagingEnabled = YES;
    menuScroller.contentSize = CGSizeMake(menuScroller.frame.size.width * kNumberOfPages, menuScroller.frame.size.height);
    menuScroller.showsHorizontalScrollIndicator = NO;
    menuScroller.showsVerticalScrollIndicator = NO;
    menuScroller.scrollsToTop = NO;
    menuScroller.delegate = self;
    
    [menuPageControl.pageControl setPageControlStyle:PageControlStyleThumb];
    [menuPageControl.pageControl setThumbImage:[UIImage imageNamed:@"gray_round"]];
    [menuPageControl.pageControl setSelectedThumbImage:[UIImage imageNamed:@"blue_round"]];
    [menuPageControl.pageControl setNumberOfPages:kNumberOfPages];
    
    [menuPageControl setNeedsLayout];
    
    if (menuPageControl.pageControl.numberOfPages == 1)
        [menuPageControl setHidden:TRUE];
    else
        [menuPageControl setHidden:FALSE];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    // [self performSelector:@selector(hideProcessingControls) withObject:nil afterDelay:0.1f];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    CardsVC *controller = [menuCardViewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[CardsVC alloc] initWithImageToConvert:imageToConvert andCurrencyArr:currencyArr andBankArr:bankArr andFocusBounds:focusBounds andPageNumber:page];
        [menuCardViewControllers replaceObjectAtIndex:page withObject:controller];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview)
    {
        CGRect frame = menuScroller.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [menuScroller addSubview:controller.view];
    }
  
}

- (void) getSelectedBanksDetail:(NSArray*) arr
{
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement = @"SELECT * FROM banks_table WHERE ";
        
        for (int i = 0; i < [arr count]; i++)
        {
            if (i == 0)
            {
                sqlStatement = [sqlStatement stringByAppendingFormat:@"id = %@",[arr objectAtIndex:i]];
            }
            else
            {
                sqlStatement = [sqlStatement stringByAppendingFormat:@" OR id = %@",[arr objectAtIndex:i]];
            }
        }
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            bankArr = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *productName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *transactionFee = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *conversionFee = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *oneOffFee = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *accountID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *logo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *baseCurrency = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *timestamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ID,@"id",name,@"name",productName,@"productName",transactionFee,@"transactionFee",conversionFee,@"conversionFee",oneOffFee,@"oneOffFee",accountID,@"accountID",country,@"country",logo,@"logo",baseCurrency,@"baseCurrency",timestamp,@"timestamp", nil];
                
                [bankArr addObject:dic];
            }
            
        }
        sqlite3_finalize(compiledStatement);
        
        sqlite3_close(database);
    }
}

- (void) addNewBankBtnTap:(id) sender
{
    BanksVC *bvc = [[BanksVC alloc] initWithNibName:@"BanksVC" bundle:[NSBundle mainBundle]];
    [bvc setAddOrRemoveBank:TRUE];
    [self.navigationController pushViewController:bvc animated:TRUE];
}

- (void) bankBtnTap:(id) sender
{
    UIButton *btn = (UIButton*) sender;
    
    int page = btn.tag;
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
    
    [self hidePullViewBtnTap:nil];
    
    CGRect frame = menuScroller.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [menuScroller scrollRectToVisible:frame animated:YES];
}



- (NSString*) pathToData
{
	if( _pathToData == nil ) {
		NSBundle* mainBundle = [NSBundle mainBundle];
		if( mainBundle != nil ) {
			NSString* bundlePath = [mainBundle bundlePath];
			_pathToData = [bundlePath copy];
		} else {
			_pathToData = @"./";
		}
	}
	return _pathToData;
}

//Saurabh

// Represent CMocrLayout as html string to show in UIWebView.
- (NSString*) htmlFromMocrLayout:(NSMutableArray *)layout
{
    return @"";
}

- (BOOL) isArrayContainsNumericChar:(NSMutableArray*) characterArray
{
    BOOL containsNumeric = FALSE;
    
    for (int i = 0; i < [characterArray count]; i++)
    {
        CMocrCharacter *character = (CMocrCharacter*)[characterArray objectAtIndex:i];
        if ([self isNumericCharacter:character.unicode])
        {
            containsNumeric = TRUE;
        }
    }
    
    return containsNumeric;
}

-(void)DisplayAlertWithData:(NSMutableDictionary *)data
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[data objectForKey:@"title"] message:[data objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView setTag:[[data objectForKey:@"tag"] intValue]];
    [alertView show];
}
//Saurabh

- (float) getConversionMultiplier
{
    float multiplier = 0.0f;
    
    if ([targetCurrency length] == 0 || [targetCurrency isEqualToString:[self getBaseCurrency]])
    {
        sqlite3 *database;
        
        NSString *sqlStatement = @"";
        
        NSString *multiiplierStr;
        
        if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
        {
            int page = menuPageControl.pageControl.currentPage;
            
            if (page == 0)
                sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",preferredCurrency];
            else
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:page-1];
                
                sqlStatement = [NSString stringWithFormat:@"SELECT multiplier FROM rates_table WHERE bank_id=%@ AND currency_code='%@'",[dic objectForKey:@"id"],preferredCurrency];
            }
            
            
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    multiiplierStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                
            }
            sqlite3_finalize(compiledStatement);
            
            sqlite3_close(database);
        }
        
        multiplier = [multiiplierStr floatValue];
        
        return multiplier;
    }
    else
    {
        sqlite3 *database;
        
        NSString *sqlStatement = @"";
        
        NSString *multiiplierStr;
        
        NSString *dividerStr;
        
        if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
        {
            int page = menuPageControl.pageControl.currentPage;
            
            if (page == 0)
                sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",targetCurrency];
            else
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:page-1];
                
                sqlStatement = [NSString stringWithFormat:@"SELECT multiplier FROM rates_table WHERE bank_id=%@ AND currency_code='%@'",[dic objectForKey:@"id"],targetCurrency];
            }
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    dividerStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                
            }
            sqlite3_finalize(compiledStatement);
            
            if (page == 0)
                sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",preferredCurrency];
            else
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:page-1];
                
                sqlStatement = [NSString stringWithFormat:@"SELECT multiplier FROM rates_table WHERE bank_id=%@ AND currency_code='%@'",[dic objectForKey:@"id"],preferredCurrency];
            }
            sqlite3_stmt *compiledStatement2;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement2, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement2) == SQLITE_ROW)
                {
                    multiiplierStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 0)];
                    NSLog(@"multiiplierStr = %@",multiiplierStr);
                }
                
            }
            sqlite3_finalize(compiledStatement2);
            
            sqlite3_close(database);
        }
        
        float multiplier = [multiiplierStr floatValue];
        float divider = [dividerStr floatValue];
        
        multiplier = (1/divider)*multiplier;
        
        return multiplier;
    }
    
    return multiplier;
}

- (NSString*) getConvertedCurrency:(NSString *) currencyStr
{
    NSArray *componenetsArr = [currencyStr componentsSeparatedByString:@"."];
    
    BOOL isContainsDecimalPoint = FALSE;
    int digitsAfterDecimal = 0;
    if ([currencyStr rangeOfString:@"."].location != NSNotFound)
    {
        isContainsDecimalPoint = TRUE;
        
        NSString *afterDecimal = [componenetsArr lastObject];
        
        digitsAfterDecimal = [afterDecimal length];
    }
    
    float currency = [currencyStr floatValue];
    
    if ([targetCurrency length] == 0 || [targetCurrency isEqualToString:[self getBaseCurrency]])
    {
        sqlite3 *database;
        
        NSString *sqlStatement = @"";
        
        NSString *multiiplierStr;
        
        if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
        {
            sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",preferredCurrency];
            
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    multiiplierStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                
            }
            sqlite3_finalize(compiledStatement);
            
            sqlite3_close(database);
        }
        
        float multiplier = [multiiplierStr floatValue];
        
        currency = currency * multiplier;
        
        if (isContainsDecimalPoint)
        {
            return [self addCurrencySymbolToCalculatedCurrency:[NSString stringWithFormat:@"%.*f",digitsAfterDecimal,currency]];
        }
        else
        {
            return [self addCurrencySymbolToCalculatedCurrency:[NSString stringWithFormat:@"%.0f",currency]];
        }
    }
    else
    {
        sqlite3 *database;
        
        NSString *sqlStatement = @"";
        
        NSString *multiiplierStr;
        
        NSString *dividerStr;
        
        if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
        {
            sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",targetCurrency];
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    dividerStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                
            }
            sqlite3_finalize(compiledStatement);
            
            sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",preferredCurrency];
            
            sqlite3_stmt *compiledStatement2;
            
            if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement2, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(compiledStatement2) == SQLITE_ROW)
                {
                    multiiplierStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 0)];
                }
                
            }
            sqlite3_finalize(compiledStatement2);
            
            sqlite3_close(database);
        }
        
        float multiplier = [multiiplierStr floatValue];
        float divider = [dividerStr floatValue];
        
        currency = (currency/divider)*multiplier;
        
        if (isContainsDecimalPoint)
        {
            return [self addCurrencySymbolToCalculatedCurrency:[NSString stringWithFormat:@"%.*f",digitsAfterDecimal,currency]];
        }
        else
        {
            return [self addCurrencySymbolToCalculatedCurrency:[NSString stringWithFormat:@"%.0f",currency]];
        }
    }
    
    return @"";
}

- (NSString*) getBaseCurrency
{
    NSString *baseCurrency = @"GBP";
    // baseCurrency = @"GBP";
    //    if (bankPageControl.pageControl.currentPage == 0)
    //    {
    //        baseCurrency = @"GBP";
    //    }
    //    else
    //    {
    //        baseCurrency = @"GBP";
    //    }
    
    return baseCurrency;
}

- (NSString*) addCurrencySymbolToCalculatedCurrency:(NSString*) currency
{
    NSString *currencyName = @"";
    
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
    if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement = [NSString stringWithFormat:@"SELECT * FROM currency_table WHERE code_name = '%@'",preferredCurrency];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *symbolStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                if (symbolStr)
                {
                    short symbol = [symbolStr intValue];
                    
                    if (symbol != 0)
                        currencyName = [NSString stringWithFormat:@"%C %@",symbol,currency];
                    else
                        currencyName = currency;
                }
                else
                    currencyName = currency;
            }
            else
                currencyName = currency;
        }
        else
            currencyName = currency;
        
        
        sqlite3_finalize(compiledStatement);
        
        sqlite3_close(database);
    }
    
    return  currencyName;
}

- (BOOL) isNumericCharacter:(int) unicode
{
    NSArray *arr = [NSArray arrayWithObjects:@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"56",@"57",nil];
    
    NSString *unicodeStr = [NSString stringWithFormat:@"%d",unicode];
    
    if ([arr containsObject:unicodeStr])
        return TRUE;
    
    return FALSE;
}

- (BOOL) isCurrencySymbol:(int) unicode
{
    sqlite3 *database;
	
	NSString *sqlStatement = @"";
    NSString *cnt;
	
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
	{
		sqlStatement = [NSString stringWithFormat:@"select count(*) as cnt from currency_table where unicode=%d",unicode];
        
        sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
			{
				cnt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			}
			
		}
		sqlite3_finalize(compiledStatement);
        
		sqlite3_close(database);
	}
    
    if ([cnt intValue] > 0)
        return TRUE;
    else
        return FALSE;
    
    return FALSE;
}

- (BOOL) isAlphabet:(int) unicode
{
    NSArray *arr = [NSArray arrayWithObjects:@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"97",@"98",@"99",@"100",@"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",@"110",@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118",@"119",@"120",@"121",
                    @"122",nil];
    
    NSString *unicodeStr = [NSString stringWithFormat:@"%d",unicode];
    
    if ([arr containsObject:unicodeStr])
        return TRUE;
    
    return FALSE;
}

- (BOOL) isCurrencyWord:(NSString*) wordStr
{
    NSString *currency = wordStr;
    
    sqlite3 *database;
	
	NSString *sqlStatement = @"";
    
    NSString *cnt;
	
	if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
	{
		sqlStatement = [NSString stringWithFormat:@"select count(*) as cnt from currency_table where code_name='%@'",currency];
        
        sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
			{
				cnt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			}
			
		}
		sqlite3_finalize(compiledStatement);
        
		sqlite3_close(database);
	}
    
    if ([cnt intValue] > 0)
        return TRUE;
    else
        return FALSE;
    
    return FALSE;
}

- (NSString*) getCurrencyCode
{
    NSString *currency;
    
    if (usersLocationCurrency)
        currency = usersLocationCurrency;
    else
        currency = @"GBP";
    
    for (int i = 0; i < [currencyArr count]; i++)
    {
        NSString *tmpCurrency = @"";
        
        TOcr_Word *tWord =  (TOcr_Word*)[currencyArr objectAtIndex:i];
        
        for (int j = 0; j < [tWord.wordStr length]; j++)
        {
            unichar Char = [tWord.wordStr characterAtIndex:j];
            
            if ([self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:Char] intValue]])
            {
                sqlite3 *database;
                
                NSString *sqlStatement = @"";
                
                if(sqlite3_open([DatabasePath UTF8String], &database) == SQLITE_OK)
                {
                    sqlStatement = [NSString stringWithFormat:@"select code_name FROM currency_table where unicode = %d",[[NSNumber numberWithUnsignedShort:Char] intValue]];
                    
                    sqlite3_stmt *compiledStatement;
                    
                    if(sqlite3_prepare_v2(database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK)
                    {
                        if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                        {
                            currency = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                        }
                        
                    }
                    sqlite3_finalize(compiledStatement);
                    
                    sqlite3_close(database);
                }
                
                return currency;
            }
            else if ([self isAlphabet:[[NSNumber numberWithUnsignedShort:Char] intValue]])
            {
                tmpCurrency = [tmpCurrency stringByAppendingFormat:@"%c",[[NSNumber numberWithUnsignedShort:Char] intValue]];
            }
        }
        
        if ([tmpCurrency length] > 0)
        {
            currency = tmpCurrency;
            
            return currency;
        }
    }
    return currency;
}

- (NSString*) getCurrencyNameForCurrencyCode:(NSString*) currencyCode
{
    NSString *currencyName;
    
    sqlite3 *database;
    
    NSString *sqlStatement = @"";
    
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
                        currencyName = [NSString stringWithFormat:@"%C",(unichar)symbol];
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

- (void) showResults:(NSString*)stringToOutput
{
	NSMutableString* htmlString = [NSMutableString stringWithString:commonHtmlTitle];
	[htmlString appendString:stringToOutput];
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self displayHint];
    
}

- (void) onBeforeRecognition
{
	_needToStopRecognition = NO;
}

- (void) onAfterRecognition
{
    //	[progressSheet dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    
    if (scrollView == bankScroller)
    {
        CGFloat pageWidth = bankScroller.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        bankPageControl.pageControl.currentPage = page;
    }
    else if (scrollView == menuScroller)
    {
        CGFloat pageWidth = bankScroller.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        menuPageControl.pageControl.currentPage = page;
        
        [self loadScrollViewWithPage:page-1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page+1];
        
        if (page == 0)
            [self setInstitutionInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Caxton FX rate",@"name",nil]];
        else
        {
            NSMutableDictionary *dic = [bankArr objectAtIndex:page-1];
            
            [self setInstitutionInfo:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"name"],@"name",[dic objectForKey:@"oneOffFee"],@"oneOffFee",nil]];
        }
    }
}

#pragma mark -
#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 505)
    {
        return;
    }
    NSArray *array = [self.navigationController viewControllers];
    ImagePickerVC *ivc = (ImagePickerVC*) [array objectAtIndex:0];
    [ivc showCamera];
    [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark -
#pragma mark Tesseract Processing

#pragma mark -

- (NSString *) applicationDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	return documentsDirectoryPath;
}

#pragma mark -
#pragma mark Image Processsing

- (void) startTesseract
{
    _dataPath = @"tessdata";
    _language = @"eng";
    _variables = [[NSMutableDictionary alloc] init];
    
    [self copyDataToDocumentsDirectory];
    _tesseract = new tesseract::TessBaseAPI();
    
    BOOL success = [self initEngine];
    if (!success) {
        NSLog(@"Engine failed to start");
    }
}

- (BOOL)initEngine {
    int returnCode = _tesseract->Init([_dataPath UTF8String], [_language UTF8String]);
    return (returnCode == 0) ? YES : NO;
}

- (void)setImage:(UIImage *)image
{
    free(_pixels);
    
    CGSize size = [image size];
    int width = size.width;
    int height = size.height;
	
	if (width <= 0 || height <= 0) {
		return;
    }
	
    _pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // Clear the pixels so any transparency is preserved
    memset(_pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // Create a context with RGBA _pixels
    CGContextRef context = CGBitmapContextCreate(_pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // Paint the bitmap to our context which will fill in the _pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	
	// We're done with the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    _tesseract->SetImage((const unsigned char *) _pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
}

- (BOOL)recognize {
    int returnCode = _tesseract->Recognize(NULL);
    return (returnCode == 0) ? YES : NO;
}

- (NSString *)recognizedText {
    char* utf8Text = _tesseract->GetHOCRText(0);
    return [NSString stringWithUTF8String:utf8Text];
}

- (void)copyDataToDocumentsDirectory {
    
    // Useful paths
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    NSString *dataPath = [documentPath stringByAppendingPathComponent:_dataPath];
    
    // Copy data in Doc Directory
    if (![fileManager fileExistsAtPath:dataPath]) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:_dataPath];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:nil];
        }
    }
    [CommonFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",dataPath]]];
    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
}

//http: www.iphonedevsdk.com/forum/iphone-sdk-development/7307-resizing-photo-new-uiimage.html#post33912
-(UIImage *)resizeImage:(UIImage *)image {
 	
 	CGImageRef imageRef = [image CGImage];
 	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
 	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
 	
 	if (alphaInfo == kCGImageAlphaNone)
 		alphaInfo = kCGImageAlphaNoneSkipLast;
 	
 	int width, height;
 	
 	width = 640; //[image size].width;
 	height = 640; //[image size].height;
 	
 	CGContextRef bitmap;
 	
 	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
 		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
 		
 	} else {
 		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
 		
 	}
 	
 	if (image.imageOrientation == UIImageOrientationLeft) {
 		NSLog(@"image orientation left");
 		CGContextRotateCTM (bitmap, radians(90));
 		CGContextTranslateCTM (bitmap, 0, -height);
 		
 	} else if (image.imageOrientation == UIImageOrientationRight) {
 		NSLog(@"image orientation right");
 		CGContextRotateCTM (bitmap, radians(-90));
 		CGContextTranslateCTM (bitmap, -width, 0);
 		
 	} else if (image.imageOrientation == UIImageOrientationUp) {
 		NSLog(@"image orientation up");
 		
 	} else if (image.imageOrientation == UIImageOrientationDown) {
 		NSLog(@"image orientation down");
 		CGContextTranslateCTM (bitmap, width,height);
 		CGContextRotateCTM (bitmap, radians(-180.));
 		
 	}
 	
 	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
 	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
 	UIImage *result = [UIImage imageWithCGImage:ref];
 	
 	CGContextRelease(bitmap);
 	CGImageRelease(ref);
 	
 	return result;
}

#pragma mark -
#pragma mark - GLOBAL RATES & CHECK AUTH GET CARDS API

-(void)callgetGloableRateApi
{
    
    if([CommonFunctions reachabiltyCheck])
    {
        sharedManager *manger = [[sharedManager alloc]init];
        manger.delegate = self;
        NSString *soapMessage = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetGlobalRates/></soapenv:Body></soapenv:Envelope>";
        
        [manger callServiceWithRequest:soapMessage methodName:@"GetGlobalRates" andDelegate:self];
    }
    
}

-(void)goMoreInfoPage
{
    MoreInfoVC *tempVC = [[MoreInfoVC alloc] init];
    self.view.userInteractionEnabled = YES;
    [[self navigationController] pushViewController:tempVC animated:YES];
    [self performSelectorInBackground:@selector(getHtmlCache) withObject:nil];
}


-(void)getHtmlCache
{
    NSError *error = nil;
    NSString *htmlstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"moreInfoHtml"];
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlstr error:&error];
    if (error) {
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"img"];
    
    for (HTMLNode *inputNode in inputNodes) {
        
        NSURL *url = [NSURL URLWithString:[inputNode getAttributeNamed:@"src"]];
        
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        
        UIImage *  img1 = [UIImage imageWithData:data];
        NSString *urlstr = [inputNode getAttributeNamed:@"src"];
        NSArray *parts = [urlstr componentsSeparatedByString:@"/"];
        NSString *filename = [parts objectAtIndex:[parts count]-1];
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        
        if (img1)
        {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",documentPath,filename]])
            {
                [data writeToFile:[NSString stringWithFormat:@"%@/%@",documentPath,filename] atomically:YES];
                
                [CommonFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",documentPath,filename]]];
                
                htmlstr = [htmlstr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img src=\"%@\" />",urlstr] withString:[NSString stringWithFormat:@"<img src=\"%@\" />",filename]];
                
                
            }
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:htmlstr forKey:@"offlineHtml"];
        
    }
    
}


#pragma mark ------
#pragma mark sharedManagerDelegate

-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service
{
    if ([service isEqualToString:@"GetGlobalRates"])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyflags_map" ofType:@"csv"];
        NSString *myText = nil;
        
        if (filePath) {
            /*
             Depracated NSString method changed with the newest one available
             myText = [NSString stringWithContentsOfFile:filePath];
             */
            myText = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:nil];
            if (myText) {
                //here
            }
        }
        //NSString *content =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]; unused variable
        NSArray *contentArray = [myText componentsSeparatedByString:@"\r"]; // CSV ends with ACSI 13 CR (if stored on a Mac Excel 2008)
        NSMutableArray *codesMA = [NSMutableArray new];
        
        for (NSString *item in contentArray)
        {
            NSArray *itemArray = [item componentsSeparatedByString:@","];
            // log first item
            
            if ([itemArray count] > 3)
            {
                [codesMA addObject:[itemArray objectAtIndex:3]];
            }
        }
        NSMutableArray *glabalRatesMA  = [[NSMutableArray alloc] init];
        
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        if(rootItemElem)
        {
            TBXMLElement *subcategoryEle = [TBXML childElementNamed:@"GetGlobalRatesResponse" parentElement:rootItemElem];
            TBXMLElement * GetGlobalRatesResult = [TBXML childElementNamed:@"GetGlobalRatesResult" parentElement:subcategoryEle];
            //TBXMLElement *baseCcy = [TBXML childElementNamed:@"a:baseCcy" parentElement:GetGlobalRatesResult]; unused variable
            TBXMLElement *expiryTime = [TBXML childElementNamed:@"a:expiryTime" parentElement:GetGlobalRatesResult];
            NSString *expiryTimeStr = [TBXML textForElement:expiryTime];
            
            [[NSUserDefaults standardUserDefaults]setObject:expiryTimeStr forKey:@"expiryTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            TBXMLElement *rates = [TBXML childElementNamed:@"a:rates" parentElement:GetGlobalRatesResult];
            if (rates)
            {
                TBXMLElement *CFXExchangeRate = [TBXML childElementNamed:@"a:CFXExchangeRate" parentElement:rates];
                while (CFXExchangeRate != nil) {
                    TBXMLElement *currencyCode = [TBXML childElementNamed:@"a:CcyCode" parentElement:CFXExchangeRate];
                    TBXMLElement *rate = [TBXML childElementNamed:@"a:Rate" parentElement:CFXExchangeRate];
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setObject:[TBXML textForElement:currencyCode] forKey:@"currencyCode"];
                    
                    float mutiplier = [[TBXML textForElement:rate] floatValue];
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
                    [nf setPositiveFormat:@"0.##"];
                    
                    [dict setObject:[nf stringFromNumber:[NSNumber numberWithFloat:mutiplier]] forKey:@"rate"];
                    int index = -1;
                    NSString *imageName = @"";
                    
                    if ([codesMA containsObject:[dict objectForKey:@"currencyCode"]])
                    {
                        index=  [codesMA indexOfObject:[dict objectForKey:@"currencyCode"]];
                        
                    }
                    if(index >=0)
                    {
                        NSString *item = [contentArray objectAtIndex:index];
                        NSArray *itemArray = [item componentsSeparatedByString:@","];
                        if (itemArray.count != 0) {
                            imageName =[[[itemArray objectAtIndex:1] lowercaseString] stringByAppendingFormat:@" - %@",[[itemArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
                        }
                    }
                    
                    [dict setObject:imageName forKey:@"imageName"];
                    
                    if (dict) {
                        [glabalRatesMA addObject:dict];
                    }
                    CFXExchangeRate = [TBXML nextSiblingNamed:@"a:CFXExchangeRate" searchFromElement:CFXExchangeRate];
                }
                
            }
            [self performSelectorOnMainThread:@selector(updatingDatabase:) withObject:glabalRatesMA waitUntilDone:YES];
        }
        
    }else if([service isEqualToString:@"GetPromo"])
    {
        
        TBXML *tbxml =[TBXML tbxmlWithXMLString:response];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *rootItemElem = [TBXML childElementNamed:@"s:Body" parentElement:root];
        TBXMLElement *getPromoResponseEle = [TBXML childElementNamed:@"GetPromoResponse" parentElement:rootItemElem];
        TBXMLElement *GetPromoResult = [TBXML childElementNamed:@"GetPromoResult" parentElement:getPromoResponseEle];
        TBXMLElement *GetPromoHtmlResult = [TBXML childElementNamed:@"html" parentElement:GetPromoResult];
        NSString *str = [TBXML textForElement:GetPromoHtmlResult];
        
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"moreInfoHtml"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelectorOnMainThread:@selector(goMoreInfoPage) withObject:nil waitUntilDone:NO];
    }
}

-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service
{
    if ([error isKindOfClass:[NSString class]]) {
        NSLog(@"Service: %@ | Response is  : %@",service,error);
    }else{
        NSLog(@"Service: %@ | Response UKNOWN ERROR",service);
    }
    if([service isEqualToString:@"GetPromo"])
    {
        MoreInfoVC *tempVC = [[MoreInfoVC alloc] init];
        self.view.userInteractionEnabled = YES;
        [[self navigationController] pushViewController:tempVC animated:YES];
    }
    
}
-(void)updatingDatabase:(NSMutableArray *)glabalRatesMA
{
    NSString *deleteQuerry = [NSString stringWithFormat:@"DELETE FROM globalRatesTable"];
    
    NSString *sqlStatement = @"DELETE FROM converion_rate_table";
    DatabaseHandler *database = [[DatabaseHandler alloc]init];
    [database executeQuery:deleteQuerry];
    [database executeQuery:sqlStatement];
    
    for (NSMutableDictionary *dict in glabalRatesMA)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"insert into converion_rate_table (currency_code,multiplier) values ('%@','%@') ",[dict objectForKey:@"currencyCode"],[dict objectForKey:@"rate"]];
        [[DatabaseHandler getSharedInstance] executeQuery:sqlStatement];
        
        NSString *query = [NSString stringWithFormat:@"insert into globalRatesTable ('CcyCode','Rate','imageName') values ('%@',%f,'%@')",[dict objectForKey:@"currencyCode"] ,[[dict objectForKey:@"rate"] doubleValue],[dict objectForKey:@"imageName"]];
        [[DatabaseHandler getSharedInstance] executeQuery:query];
    }
}

@end
