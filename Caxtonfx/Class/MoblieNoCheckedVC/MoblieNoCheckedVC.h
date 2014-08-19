//
//  MoblieNoCheckedVC.h
//  Caxtonfx
//
//  Created by Sumit on 29/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoblieNoCheckedVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

-(IBAction)editBtnPressed:(id)sender;

-(IBAction)itsCorrectBtnPressed:(id)sender;

@end
