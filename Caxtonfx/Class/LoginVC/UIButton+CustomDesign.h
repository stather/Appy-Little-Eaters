//
//  CustomTextField.h
//  OnePulse
//
//  Created by Amit on 10/04/13.
//  Copyright (c) 2013 RawDuck. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UIButton (CustomDesign)

/*********** Change Valid button image ******/
- (void)validButton;
/**
 add cross button in Button if email is not
 Valid
 */
- (void)errorSendButtonImage;
/**
 disabled sendbutton
 */
- (void)disableSendButton;
- (void)enableButtonWithLoading;
- (void)enableButtonWithGrayBGImg;
- (void)btnWithActivityIndicator;
-(void)btnWithoutActivityIndicator;
-(void)btnWithCrossImage;
-(void)btnWithOutCrossImage;
-(void)btnWithCheckImage;
-(void)btnWithOutCheckImage;
- (void)removeIndicator;
- (void)signUpBtnWithActivityIndicator;
- (void)btnSuccess;

@end
