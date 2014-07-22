//
//  ImageUtils.h
//  ImageSuperImpose
//
//  Created by Konstant on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

UIImage *scaleAndRotateImage(UIImage *image, int maxPixelsAmount);

+(UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image atPoint:(CGPoint)   point ofSize:(CGSize) size withFont:(UIFont*) font;
+(UIImage*) drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point ofSize:(CGSize) size withFont:(UIFont*) font andBackgroundColor:(UIColor*) bgColor andTextColor:(UIColor*) textColor;
+ (UIColor*) getPixelColorInImage:(UIImage *)image atLocation:(CGPoint)point ;

+(UIImage*) drawCurrencies:(NSMutableArray*) currencies inImage:(UIImage*) image;
//+(float) maxFontSizeThatFitsForString:(NSString*)_string inRect:(CGRect)rect withFont:(NSString *)fontName onDevice:(int)device;
@end
