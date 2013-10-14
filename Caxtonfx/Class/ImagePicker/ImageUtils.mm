//
//  ImageUtils.m
//  ImageSuperImpose
//
//  Created by Konstant on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageUtils.h"
#import "CattailArtNSColor.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreAnimation.h>
@implementation ImageUtils

UIImage *scaleAndRotateImage(UIImage *image, int maxPixelsAmount)
{
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	// Reduce image width and height by 2^n times to match condition: width*height <= maxPixelAmount,
	// where n = floor( log4( maxPixelsAmount / (width * height) ) )
	CGFloat scaleRatio = fmin( 1., pow( 2., floor( 1e-12 + log2( (double)maxPixelsAmount / (width * height) ) / 2. ) ) );
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	bounds.size.width = width * scaleRatio;
	bounds.size.height = height * scaleRatio;
	
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
		case UIImageOrientationUp:
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored:
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown:
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

+(UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image atPoint:(CGPoint)   point ofSize:(CGSize) size withFont:(UIFont*) font
{
    UIGraphicsBeginImageContext(image.size);
    
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(1000.0f, size.height)];
    
    NSLog(@"frame width = %f height = %f",size.width,size.height);
    NSLog(@"text width = %f height = %f",textSize.width,textSize.height);
    
    CGRect rect = CGRectMake(point.x-2.0f, point.y, (textSize.width>size.width)?textSize.width:size.width, size.height+3.0f);
    
    UIColor *color = [ImageUtils getPixelColorInImage:image atLocation:CGPointMake(point.x-2.0f, point.y-2.0f)];
    [color set];
    
    CGRect rectToFill = CGRectMake(point.x - 5.0f, point.y, (textSize.width>size.width)?textSize.width:size.width+10.0f, size.height);
    
    // modify this to make it run with parameters to draw backround of text. 
    CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    UIColor *textColor = [UIColor complementryColorForColor:color];
    [textColor set];

    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point ofSize:(CGSize) size withFont:(UIFont*) font andBackgroundColor:(UIColor*) bgColor andTextColor:(UIColor*) textColor
{
    //begin context
    UIGraphicsBeginImageContext(image.size);
    
    //draw image
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    
    //get text size for font
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(1000.0f, size.height)];
    
    //shift start point to 5 px left for completely overlap
    float x = point.x - 5.0f;
    
    float y = point.y;
    
    float width;
    
    if (textSize.width > size.width)
        width = textSize.width+12.0f;
    else
        width = size.width+12.0f;
    
    float height = size.height;
    
    CGRect rectToFill = CGRectMake(x, y, width, height);
    
    //set background color
    [bgColor set];
    
    //fill background color
    CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
    
    //create rect to draw text
    
    x = point.x - 2.0f;
    y = point.y;
    
    if (textSize.width > size.width)
        width = textSize.width+2.0f;
    else
        width = size.width+2.0f;
    
    height = size.height;
    
    CGRect textRect = CGRectMake(x, y, width, height);
    
    //set text color
    [textColor set];
    
    [text drawInRect:textRect withFont:font];
    
    //get new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIColor*) getPixelColorInImage:(UIImage *)image atLocation:(CGPoint)point
{
    UIColor *color;
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int x = point.x;
    int y = point.y;
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    byteIndex += 4;
    
    color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    free(rawData);
    
    return color;
}

+(UIImage*) drawCurrencies:(NSMutableArray*) currencies inImage:(UIImage*) image
{
    //begin context
    UIGraphicsBeginImageContext(image.size);
    
    //draw image
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    
    for (int i = 0; i < [currencies count]; i++)
    {
        NSMutableDictionary *dic = [currencies objectAtIndex:i];
        
        NSString *text = [dic objectForKey:@"currency"];
        
        NSNumber *X = [dic objectForKey:@"x"];
        NSNumber *Y = [dic objectForKey:@"y"];
        
        CGPoint point = CGPointMake([X floatValue], [Y floatValue]);
        
        NSNumber *WIDTH = [dic objectForKey:@"width"];
        NSNumber *HEIGHT = [dic objectForKey:@"height"];
        
        CGSize size = CGSizeMake([WIDTH floatValue], [HEIGHT floatValue]);
        
        UIFont *font = [dic objectForKey:@"font"];
        
        UIColor *bgColor = [dic objectForKey:@"bgColor"];
        UIColor *textColor = [dic objectForKey:@"textColor"];
        
        //get text size for font
        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(9000.0f, size.height)];
        
        float pointsPerPixel = [font pointSize] / textSize.height;
        
        float desiredFontSize = size.height * pointsPerPixel;
        
        font = [UIFont systemFontOfSize:desiredFontSize];
        
        //shift start point to 5 px left for completely overlap
        float x = point.x-5.0f;
        
        float y = point.y-2.0f;
        
        float width;
        
        if (textSize.width > size.width)
            width = textSize.width+10.0f;
        else
            width = size.width+10.0f;
        
        float height = size.height+4.0f;
        
        CGRect rectToFill = CGRectMake(x, y, width, height);
        
        //set background color
        [bgColor set];
        
        //fill background color
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
      
        x = point.x-5.0f;

        y = point.y;
        
        if (textSize.width > size.width)
            width = textSize.width+10.0f;
        else
            width = size.width+10.0f;
        
        height = size.height;
        
        CGRect textRect = CGRectMake(x, y, width, height);
        
        //set text color
        [textColor set];
    
        [text drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByClipping];
    }
    
    //get new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
