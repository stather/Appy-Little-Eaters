//
//  ImgCache.h
//  WhatzzApp
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//
 

#import <Foundation/Foundation.h>

@interface ImgCache : NSObject {
	
}

// Methods
- (void) cacheImage: (NSString *) ImageURLString;
- (UIImage *) getCachedImage: (NSString *) ImageURLString;
- (void) removeFromCache:(NSString *) ImageURLString;

@end