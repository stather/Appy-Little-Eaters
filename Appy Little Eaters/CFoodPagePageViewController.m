//
//  CFoodPagePageViewController.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 12/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CFoodPagePageViewController.h"
#import "CFoodPageViewController.h"


@interface CFoodPagePageViewController ()

@end

@implementation CFoodPagePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	// Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;

	CFoodPageViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    CFoodPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    int index = (((CFoodPageViewController*)viewController).index - 1 + 6)%6;
	pageContentViewController.index = index;
	pageContentViewController.selectedFoodImage.hidden = true;
	pageContentViewController.didYouEatText.hidden = true;
	pageContentViewController.theCollection.hidden = false;
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    CFoodPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    int index = (((CFoodPageViewController*)viewController).index + 1)%6;
	pageContentViewController.index = index;
	pageContentViewController.selectedFoodImage.hidden = true;
	pageContentViewController.didYouEatText.hidden = true;
	pageContentViewController.theCollection.hidden = false;
    return pageContentViewController;
}

- (CFoodPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    // Create a new view controller and pass suitable data.
    CFoodPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.index = index % 6;
    return pageContentViewController;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	if (!completed){
		return;
	}
	[previousViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		CFoodPageViewController * vc = obj;
		vc.selectedFoodImage.hidden = YES;
		vc.didYouEatText.hidden = YES;
		vc.theCollection.hidden = NO;
		vc.tick.hidden = YES;
		vc.cross.hidden = YES;
	}];
}


@end
