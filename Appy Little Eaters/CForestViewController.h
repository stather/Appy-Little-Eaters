//
//  CForestViewController.h
//  Appy Little Eaters
//
//  Created by Russell Stather on 19/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CForestViewController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *mainView;
- (IBAction)myAction:(id)sender;
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@end
