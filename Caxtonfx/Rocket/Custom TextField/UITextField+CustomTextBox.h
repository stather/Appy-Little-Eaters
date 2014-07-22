//
//  UITextField+CustomTextBox.h
//  OnePulse
//
//  Created by Amit on 12/04/13.
//  Copyright (c) 2013 RawDuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField(CustomTextBox)
{
    
}

- (void) drawPlaceholderInRect:(CGRect)rect;

- (void)errorTextField;

- (void)checkDataToserverTxtFld;

- (void)correctDataTxtFld;

- (void)incorrectDataTxtFld;

- (void)removeData;

@end
