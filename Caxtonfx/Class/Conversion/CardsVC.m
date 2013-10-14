//
//  CardsVC.m
//  cfx
//
//  Created by Ashish Sharma on 15/10/12.
//
//

#import "CardsVC.h"
#import "ImageUtils.h"
#import "UIImageAverageColorAddition.h"
#import "TOcr_Word.h"
#import <QuartzCore/QuartzCore.h>

@interface CardsVC ()

@end

@implementation CardsVC

@synthesize imageView;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithImageToConvert:(UIImage*) img andCurrencyArr:(NSMutableArray*) arr andBankArr:(NSMutableArray*) arr2 andFocusBounds:(CGRect) bounds andPageNumber:(int) page
{
    if (self = [super initWithNibName:@"CardsVC" bundle:[NSBundle mainBundle]])
    {
//        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [indicatorView startAnimating];
//        indicatorView.frame = CGRectMake(146, 225, 33, 33);
//        
//        [self.view addSubview:indicatorView];
//        indicatorView.hidden = NO;
        
        imageToConvert = [img copy];
        currencyArr = [[NSMutableArray alloc] initWithArray:arr];
        bankArr = [[NSMutableArray alloc] initWithArray:arr2 copyItems:TRUE];
        focusBounds = bounds;
        currentPage = page;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = imageView.frame.size;
    scrollView.minimumZoomScale = scrollView.frame.size.width / imageView.frame.size.width;
    scrollView.maximumZoomScale = 2.0;
    [scrollView setZoomScale:scrollView.minimumZoomScale];
    
    [self.imageView setImage:imageToConvert];
//    [self performSelectorInBackground:@selector(redrawImageWithNewCurrency) withObject:nil];
//    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            [indicatorView startAnimating];
//            indicatorView.frame = CGRectMake(146, 225, 33, 33);
//    
//            [self.view addSubview:indicatorView];
//            indicatorView.hidden = NO;
    [self redrawImageWithNewCurrency];
}

- (void) redrawImageWithNewCurrency
{
    if ([currencyArr count] > 0) 
    {
        CGImageRef cr = CGImageCreateWithImageInRect([imageToConvert CGImage], focusBounds);
        
        UIImage *croppedImage = [UIImage imageWithCGImage:cr];
        
        UIImage *image = croppedImage;
        
        NSMutableArray *currenciesInfoArr = [[NSMutableArray alloc] init];
        
        NSString *currencyStr = @"";
        
        UIFont *font = nil;
        
        UIColor *bgColor;

        for (int i = 0; i < [currencyArr count]; i++)
        {
            TOcr_Word *tWord = (TOcr_Word*) [currencyArr objectAtIndex:i];

        }
        for (int i = 0; i < [currencyArr count]; i++)
        {
            TOcr_Word *tWord = (TOcr_Word*) [currencyArr objectAtIndex:i];
            
            float x = tWord.wordRect.origin.x - 3.0f;
            float y = tWord.wordRect.origin.y - 3.0f;
            
            CGRect charRect = CGRectMake(x, y, tWord.wordRect.size.width, tWord.wordRect.size.height);
            
            bgColor = [self getBackgoundColorForRect:charRect inImage:croppedImage];
            
            float width = tWord.wordRect.size.width/[tWord.wordStr length];
            UIColor *textColor = [self getTextColorForRect:CGRectMake(tWord.wordRect.origin.x, tWord.wordRect.origin.y, width, tWord.wordRect.size.height) inImage:croppedImage forBackgroundColor:bgColor];
            
            if (tWord.wordStr.length != 0) {
                
            unichar fChar = [tWord.wordStr characterAtIndex:0];
            
            if ([self isCurrencySymbol:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
            {
                currencyStr = [tWord.wordStr substringFromIndex:1];
            }
            else if ([self isAlphabet:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
            {
                currencyStr = [tWord.wordStr substringFromIndex:3];
            }
            else if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:fChar] intValue]])
            {
                for (int j = 0; j < [tWord.wordStr length]; j++)
                {
                    unichar Char = [tWord.wordStr characterAtIndex:j];
                    
                    if ([self isNumericCharacter:[[NSNumber numberWithUnsignedShort:Char] intValue]] || [[NSNumber numberWithUnsignedShort:Char] intValue] == 44 || [[NSNumber numberWithUnsignedShort:Char] intValue] == 46)
                    {
                        currencyStr = [currencyStr stringByAppendingFormat:@"%c",Char];
                    }
                    else
                        break;
                }
            }
            else
                currencyStr = tWord.wordStr;
            }
            else
                currencyStr = tWord.wordStr;
            
            currencyStr = [self getConvertedCurrency:currencyStr];
            
            if ([currencyStr length] > 0)
            {
                
                float width = tWord.wordRect.size.width;
                
                float height = tWord.wordRect.size.height;
                
                if (!font)
                {
                    font = [UIFont systemFontOfSize:height-2];
                }
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:currencyStr,@"currency",[NSNumber numberWithFloat:tWord.wordRect.origin.x],@"x",[NSNumber numberWithFloat:tWord.wordRect.origin.y],@"y",[NSNumber numberWithFloat:width],@"width",[NSNumber numberWithFloat:height],@"height",font,@"font",bgColor,@"bgColor",textColor,@"textColor", nil];
                
                [currenciesInfoArr addObject:dic];
                
                dic = nil;
            }
            currencyStr = @"";
        }
        
        if ([currenciesInfoArr count] > 0)
        {
            image = [ImageUtils drawCurrencies:currenciesInfoArr inImage:image];        //crash
        }
        
        UIGraphicsBeginImageContext(imageToConvert.size);
        [imageToConvert drawInRect:CGRectMake(0,0,imageToConvert.size.width,imageToConvert.size.height)];
        [image drawInRect:focusBounds];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self performSelectorOnMainThread:@selector(setImage:) withObject:newImage waitUntilDone:NO];
    }
}

-(void)setImage: (UIImage*)image
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *navControler = appDelegate.mainNavigation;
    NSLog(@"navControler.viewControllers -> %@",navControler.viewControllers);
    NSLog(@"navControler.visibleViewController -> %@",navControler.visibleViewController);
    ConversionVC *vc;
    [self.imageView setImage:image];
    NSArray *arry = navControler.viewControllers;
    for(int i=0;i<arry.count;i++)
    {
        if([[arry objectAtIndex:i]isKindOfClass:[ConversionVC class]])
        {
            vc = [arry objectAtIndex:i];
            break;
        }
    }

    [vc hideProcessingControls];

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

- (UIColor *) getBackgoundColorForRect:(CGRect) charRect  inImage:(UIImage*) croppedImage
{
    CGImageRef imgRef = CGImageCreateWithImageInRect([croppedImage CGImage], charRect);
    
    UIImage *charImage = [UIImage imageWithCGImage:imgRef];
    
    UIColor *color = [ImageUtils getPixelColorInImage:charImage atLocation:CGPointMake(0.0f, 0.0f)];
    
    return color;
}

- (UIColor *) getTextColorForRect:(CGRect) charRect inImage:(UIImage*) croppedImage forBackgroundColor:(UIColor*) bgColor
{
    CGImageRef imgRef = CGImageCreateWithImageInRect([croppedImage CGImage], charRect);
    
    UIImage *charImage = [UIImage imageWithCGImage:imgRef];
    
    UIColor *color = [charImage mergedColor];
    
    float hue;
    float saturation;
    float brightness;
    float alpha;
    
    [bgColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if (brightness < 0.5f)
    {
        color = [self lighterColorForColor:color];
    }
    else
    {
        color = [self darkerColorForColor:color];
    }
    
    return color;
}

- (UIColor *)lighterColorForColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.4, 0.0)
                               green:MAX(g - 0.4, 0.0)
                                blue:MAX(b - 0.4, 0.0)
                               alpha:a];
    return nil;
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
    else if ([currencyStr rangeOfString:@","].location != NSNotFound)
    {
        NSMutableString *str = [[NSMutableString alloc] initWithString:currencyStr];
        [str replaceOccurrencesOfString:@"," withString:@"." options:nil range:NSMakeRange(0, [str length])];
        
        currencyStr = [NSString stringWithString:str];
        
        componenetsArr = [currencyStr componentsSeparatedByString:@"."];
        
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
            if (currentPage == 0)
                sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",preferredCurrency];
            else
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:currentPage-1];
                
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
        
        float multiplier = [multiiplierStr floatValue];
        
        currency = currency * multiplier;
        
        if (currentPage != 0)
        {
            NSMutableDictionary *dic = [bankArr objectAtIndex:currentPage-1];
            
            float conversionFee = [[dic objectForKey:@"conversionFee"] floatValue];
            float transcationFee = [[dic objectForKey:@"transactionFee"] floatValue];
            
            currency = currency + (currency*(conversionFee/100)) + (currency*(transcationFee/100));
        }
        
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
            if (currentPage == 0)
                sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",targetCurrency];
            else
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:currentPage-1];
                
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
            
            if (currentPage == 0)
                sqlStatement = [NSString stringWithFormat:@"select multiplier FROM converion_rate_table where currency_code = '%@'",preferredCurrency];
            else
            {
                NSMutableDictionary *dic = [bankArr objectAtIndex:currentPage-1];
                
                sqlStatement = [NSString stringWithFormat:@"SELECT multiplier FROM rates_table WHERE bank_id=%@ AND currency_code='%@'",[dic objectForKey:@"id"],preferredCurrency];
            }
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
        
        if (currentPage != 0)
        {
            NSMutableDictionary *dic = [bankArr objectAtIndex:currentPage-1];
            
            float conversionFee = [[dic objectForKey:@"conversionFee"] floatValue];
            float transcationFee = [[dic objectForKey:@"transactionFee"] floatValue];
            
            currency = currency + (currency*(conversionFee/100)) + (currency*(transcationFee/100));
        }
        
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

- (NSString*) getBaseCurrency
{
    NSString *baseCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCurrency"];
    
    return baseCurrency;
}

#pragma mark - 
#pragma mark - UIScrollView Delegate

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
