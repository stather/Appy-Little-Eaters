//
//  LoginVC.h
//  CaxtonFx
//
//  Created by Nishant on 05/04/13.
//  Copyright (c) 2013 Konstant Info Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PAPasscodeViewController.h"
#import "sharedManager.h"

@interface LoginVC : UIViewController <UITextFieldDelegate,PAPasscodeViewControllerDelegate,sharedDelegate>
{
    
    BOOL isRemember;
    
    IBOutlet UIImageView* loginCrossImgView;
	
}

@property (nonatomic, strong) IBOutlet UITextField *emailTxtFld;
@property (nonatomic, strong) IBOutlet UITextField *passwordTxtFld;

-(IBAction) rememberBtnPressed:(id)sender;
-(IBAction) loginBtnPressed:(id)sender;
-(IBAction) forgotpasswordBtnPressed:(id)sender;
-(IBAction) moreInfoBtnPressed:(id)sender;
-(void)loginWithAppAccount:(NSInteger)BtnTag;
-(IBAction)ContactBtnPressed:(id)sender;
@end


//////////////////////////////NOTE///////////////////////////////////////////////

//login websercive make dynamic