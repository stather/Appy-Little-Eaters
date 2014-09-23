//
//  CViewController.h
//  Appy Little Eaters
//
//  Created by Russell Stather on 03/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UIViewController{
	float keyboardHeight;
	float offset;
}
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *startEating;
@property (weak, nonatomic) IBOutlet UISwitch *acceptTC;
- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue;
@end
