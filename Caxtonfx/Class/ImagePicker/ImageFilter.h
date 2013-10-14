//
//  ImageFilter.h
//  SnapXv2
//
//  Created by Ashish Sharma on 02/03/13.
//  Copyright (c) 2013 Konstant Info. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFilter : NSObject

+(UIImage*) processedImageForOCR:(UIImage*) inputImage;
+ (UIImage *) convertToGreyscale:(UIImage *)i;

@end
