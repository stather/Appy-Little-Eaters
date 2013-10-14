//
//  MyImageView.m
//  iMixtapes
//
//  Created by Vipin Jain on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyImageView.h"
#define TMP NSTemporaryDirectory()

@implementation MyImageView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        //self.image=[UIImage imageNamed:@"noimage.png"];
//        [self.layer setBorderColor: [[UIColor whiteColor] CGColor]];
//        [self.layer setBorderWidth: 4.0];
//        [self.layer setShadowOffset:CGSizeMake(-0.1, -0.1)];
//        [self.layer setShadowOpacity:0.4];
//        //[imgView.layer setShadowRadius:0.0];
//        [self.layer setShadowColor:[UIColor grayColor].CGColor];
    }
    return self;
}
-(void) addImageFrom:(NSString*) URL isRound:(BOOL)value isActivityIndicator:(BOOL)activ{
    value = NO;
    
    if ([URL length] == 0)
    {
        return;
    }
  //  self.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imgPath = [self getUniquePath:URL];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath])
    {
        [NSThread detachNewThreadSelector:@selector(getImageFromFile:) toTarget:self withObject:imgPath];
    }
	else 
	{
        if (activ) 
        {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
            activityIndicator.tag = 786;
            
            [activityIndicator startAnimating];
            
            [activityIndicator setHidesWhenStopped:YES];
            
            CGRect myRect = self.frame;
            
            NSLog(@"Class name %@",[self class]);
            
            CGRect newRect = CGRectMake(myRect.size.width/2 -12.5f,myRect.size.height/2 - 12.5f, 25, 25);
            
            [activityIndicator setFrame:newRect];
            
            [self addSubview:activityIndicator];
        }
        
		[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:URL];
	}
}

- (void) getImageFromFile:(NSString*) imgPath
{
    NSData *data = [NSData dataWithContentsOfFile:imgPath];

    [self setImage:[UIImage imageWithData:data]];
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)[self viewWithTag:786];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

-(void) addImageFrom:(NSString*) URL isRound:(BOOL)value
{
	[self addImageFrom:URL isRound:value isActivityIndicator:YES];
}

-(void) fetchImage:(NSString*) str
{

	NSURL *url = [NSURL URLWithString:str];
    
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *tmpImage = [UIImage imageWithData:data];
	
	NSString *imgPath = [self getUniquePath:str];
	[data writeToFile:imgPath atomically:YES];
    
   [self setImage:tmpImage];
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)[self viewWithTag:786];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

-(NSString*)  getUniquePath:(NSString*)  urlStr
{
	
    NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[urlStr substringFromIndex:7]];
    [tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
    
    // Generate a unique path to a resource representing the image you want
    NSString    *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7];   // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    return uniquePath;
}
						   
- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}


//-(UIImage*)rescaleImage:(UIImage*)image{
//    UIImage* scaledImage = image;
//    
//    CALayer* layer = self.layer;
//    CGFloat borderWidth = 4;//layer.borderWidth;
//    
//    //if border is defined
//    if (borderWidth > 0)
//    {
//        //rectangle in which we want to draw the image.
//        CGRect imageRect = CGRectMake(0.0, 0.0, self.bounds.size.width - 2 * borderWidth,self.bounds.size.height - 2 * borderWidth);
//        //Only draw image if its size is bigger than the image rect size.
//        if (image.size.width > imageRect.size.width || image.size.height > imageRect.size.height)
//        {
//            UIGraphicsBeginImageContext(imageRect.size);
//            [image drawInRect:imageRect];
//            scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }       
//    }
//    return scaledImage;
//}
@end
