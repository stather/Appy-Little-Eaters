//
//  ImgCache.m
//  WhatzzApp
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "ImgCache.h"
#define TMP NSTemporaryDirectory()

@implementation ImgCache

- (void) cacheImage: (NSString *) ImageURLString
{
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
	
	NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[ImageURLString substringFromIndex:7]];
	[tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
	
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7];   // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	
	NSLog(@"%@",uniquePath);
	
	
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
		
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
		[data writeToFile:uniquePath atomically:YES];
		 
		
		/*NSFileManager *NSFm = [NSFileManager defaultManager];
		NSDictionary *attr;
		attr = [NSFm fileAttributesAtPath:uniquePath  traverseLink: NO];
		NSDate *fileCreationDate = [attr objectForKey:NSFileModificationDate];
		NSString *fileCreationDateString = [fileCreationDate description];
		NSLog(@"%@",fileCreationDateString);*/

		
        //UIImage *image = [[UIImage alloc] initWithData: data];
        
        // Do we want to round the corners?
       // image = [self roundCorners: image]; // dont need in this app...
        
		
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
		/*
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
        }
        else if(
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
        {
            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
        }
		*/
	
		
    }
	
	 
}

-(void) removeFromCache:(NSString *) ImageURLString{
	
	NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[ImageURLString substringFromIndex:7]];
	[tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
	
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7];   // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	
	//NSLog(@"%@",uniquePath);
	
	// Check for file existence
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
		[[NSFileManager defaultManager] removeItemAtPath:uniquePath error:nil];
	}
 
}
- (UIImage *) getCachedImage: (NSString *) ImageURLString
{

    NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[ImageURLString substringFromIndex:7]];
	
	[tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];

	NSString *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7]; // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
	//NSLog(@"filename = %@, uniquepath = %@",filename,uniquePath);
	
	
	
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
       // image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
		NSData* imageData = [[NSData alloc] initWithContentsOfFile:uniquePath];
		image = [[UIImage alloc] initWithData:imageData];
 
    }
    else
    {
        // get a new one
        [self cacheImage: ImageURLString];
		
		NSData* imageData = [[NSData alloc] initWithContentsOfFile:uniquePath];
		image = [[UIImage alloc] initWithData:imageData];
	 
		
		//NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:ImageURLString]];
		//image = [[UIImage alloc] initWithData:imageData];
        //image = [UIImage imageWithContentsOfFile: uniquePath];
    }
	
    return image;
	
}

@end


