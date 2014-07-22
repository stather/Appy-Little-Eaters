//
//  MyImageView.h
//  iMixtapes
//
//  Created by Vipin Jain on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyImageView : UIImageView 
{
   
}
-(void) addImageFrom:(NSString*) URL isRound:(BOOL)value isActivityIndicator:(BOOL)activ;
-(void) addImageFrom:(NSString*) URL isRound:(BOOL)value;
-(void) fetchImage:(NSString*) str;
-(NSString*)  getUniquePath:(NSString*)  urlStr;
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
//-(UIImage*)rescaleImage:(UIImage*)image;
@end
