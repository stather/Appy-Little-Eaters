//
//  FoodPagePageViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 18/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation


public class FoodPagePageViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
	

	
	public weak var pageViewController:UIPageViewController!
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
		pageViewController.dataSource = self;
		pageViewController.delegate = self;
		var startingViewController = viewControllerAtInder(0)
		var viewControllers:NSArray = [startingViewController]
		pageViewController.setViewControllers(viewControllers, direction:UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
		
		
		// Change the size of page view controller
		pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
		addChildViewController(pageViewController)
		view.addSubview(pageViewController.view)
		pageViewController.didMoveToParentViewController(self)
	}
	
	public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		var pageContentViewController:FoodPageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as FoodPageViewController
		let vc = viewController as FoodPageViewController
		var index = (vc.index - 1 + 6)%6
		pageContentViewController.index = index;
		pageContentViewController.selectedFoodImage?.hidden = true;
		pageContentViewController.theCollection?.hidden = false;
		return pageContentViewController;
	}
	
	public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		var pageContentViewController:FoodPageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as FoodPageViewController
		let vc = viewController as FoodPageViewController
		var index = (vc.index + 1)%6
		pageContentViewController.index = index;
		pageContentViewController.selectedFoodImage?.hidden = true;
		pageContentViewController.theCollection?.hidden = false;
		return pageContentViewController;
	}
	
	public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
		if (!completed){
			return;
		}
		for item in previousViewControllers{
			var vc = item as FoodPageViewController
			vc.selectedFoodImage.hidden = true;
			vc.theCollection.hidden = false;
			vc.tick.hidden = true;
			vc.cross.hidden = true;
		}
	}
	
	func viewControllerAtInder(index: Int) -> FoodPageViewController{
		var pageContentViewController:FoodPageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as FoodPageViewController
		pageContentViewController.index = index % 6;
		return pageContentViewController;
	}
}
