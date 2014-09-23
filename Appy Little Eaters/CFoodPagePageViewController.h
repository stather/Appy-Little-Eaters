//
//  CFoodPagePageViewController.h
//  Appy Little Eaters
//
//  Created by Russell Stather on 12/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFoodPagePageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;


@end
