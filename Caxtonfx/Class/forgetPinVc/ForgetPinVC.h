//
//  ForgetPinVC.h
//  Caxtonfx
//
//  Created by XYZ on 18/06/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAPasscodeViewController.h"
#import "sharedManager.h"

@interface ForgetPinVC : UIViewController <UITextFieldDelegate,sharedDelegate,PAPasscodeViewControllerDelegate>
{
    IBOutlet UIImageView* loginCrossImgView;
}

@property (nonatomic, weak) IBOutlet UITextField *emailTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *passwordTxtFld;

-(IBAction)cancleBtn:(id)sender;


@end
