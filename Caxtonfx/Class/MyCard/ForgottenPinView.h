//
//  ForgottenPinView.h
//  Caxtonfx
//
//  Created by Catalin Demian on 07/08/14.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgottenPinView : UIView<UIAlertViewDelegate>

@property(nonatomic, weak) IBOutlet UILabel *forgottenPinLabel;
@property(nonatomic, weak) IBOutlet UIButton *forgottenPinButton;


- (IBAction)forgottenPinAction:(id)sender;

@end
