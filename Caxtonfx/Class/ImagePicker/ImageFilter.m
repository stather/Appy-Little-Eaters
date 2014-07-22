//
//  ImageFilter.m
//  SnapXv2
//
//  Created by Ashish Sharma on 02/03/13.
//  Copyright (c) 2013 Konstant Info. All rights reserved.
//

#import "ImageFilter.h"
#import "UIImageAverageColorAddition.h"
#import "UIImage+Brightness.h"
#import "CommonFunctions.h"
#import <CoreImage/CIFilter.h>

@implementation ImageFilter

+(UIImage*) processedImageForOCR:(UIImage*) inputImage
{
    UIColor *color = [inputImage mergedColor];
    
    float hue;
    float saturation;
    float brightness;
    float alpha;
    
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    NSLog(@"Image Hue = %f",hue);
    NSLog(@"Image Saturation = %f",saturation);
    NSLog(@"Image Brightness = %f",brightness);
    NSLog(@"Image Alpha = %f",alpha);
    
    CIImage *beginImage = [CIImage imageWithCGImage:inputImage.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
        
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                        keysAndValues: kCIInputImageKey, beginImage,
              @"inputAngle", [NSNumber numberWithFloat:(1.0f-hue)], nil];
    
    CIImage *outputImage = [filter outputImage];
    
    filter = [CIFilter filterWithName:@"CIWhitePointAdjust"
                        keysAndValues: kCIInputImageKey, outputImage,
              @"inputColor", [CIColor colorWithRed:0.7f green:0.7f blue:0.7f], nil];
    
    outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    newImg = [newImg imageWithBrightness:1.0f];
    
    NSData *data = UIImageJPEGRepresentation(newImg, 1.0f);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *filePath = [docDir stringByAppendingPathComponent:@"a.jpg"];
    
    NSLog(@"filePath = %@",filePath);
    
    [data writeToFile:filePath atomically:TRUE];
    
    [CommonFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",filePath]]];

    
    CGImageRelease(cgimg);
    
    return newImg;
}

+ (UIImage *) convertToGreyscale:(UIImage *)i
{
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

@end
