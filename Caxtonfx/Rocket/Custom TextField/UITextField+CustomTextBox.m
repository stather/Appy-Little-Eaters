//
//  UITextField+CustomTextBox.m
//  OnePulse
//
//  Created by Amit on 12/04/13.
//  Copyright (c) 2013 RawDuck. All rights reserved.
//

#import "UITextField+CustomTextBox.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Additions.h"

@implementation UITextField(CustomTextBox)




-(void)errorTextField
{
    self.layer.borderColor=(__bridge CGColorRef)([UIColor redColor]);
    self.layer.borderWidth=2;
}

- (void)checkDataToserverTxtFld
{
    // ------------------------------ If either correct or wrong images exists then it should be remove ---------------------------------
    
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
    
    UIActivityIndicatorView *loadingIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingIndicator.frame=CGRectMake(self.frame.origin.x+self.frame.size.width-60,2, 30, 30);
    [self addSubview:loadingIndicator];
    loadingIndicator.tag = -1;
    [loadingIndicator startAnimating];
}

- (void)correctDataTxtFld
{
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
    
//    UIImageView *correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.origin.x+self.frame.size.width-49, 12, 19, 16)];
    
    UIImageView *correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 19, 16)];
    [correctImgView setImage:[UIImage imageNamed:@"checkMarkIcon"]];
    correctImgView.tag = -2;
    self.rightView = correctImgView;
    self.rightViewMode = UITextFieldViewModeUnlessEditing;
    //[self addSubview:correctImgView];
}

- (void)incorrectDataTxtFld
{
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
    // ------------------ Add Red Image to text field ---------------------------------
    
   // UIImageView *correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-20, 13, 16, 16)];
    
    UIImageView *correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 16, 16)];
    [correctImgView setImage:[UIImage imageNamed:@"cross"]];
    correctImgView.tag = -2;
    self.rightView = correctImgView;
    self.rightViewMode = UITextFieldViewModeUnlessEditing;
    //[self addSubview:correctImgView];
    
}

- (void)removeData
{
     //[[self viewWithTag:-2] removeFromSuperview];
    self.rightView = nil;
    self.rightViewMode = UITextFieldViewModeNever;
}



- (void) drawPlaceholderInRect:(CGRect)rect {
    
   
    NSLog(@"%@", NSStringFromCGRect(rect));
    UIColor *color = UIColorFromRedGreenBlue(203, 201, 199);
    
     [color setFill];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[self placeholder] drawInRect:CGRectMake(rect.origin.x, rect.origin.y+10, rect.size.width, rect.size.height) withFont:[UIFont fontWithName:@"OpenSans-Italic" size:13]];
    }else{
         [[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:@"OpenSans-Italic" size:13]];
    }
}

@end
