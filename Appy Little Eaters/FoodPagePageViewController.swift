//
//  FoodPagePageViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 18/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

open class FoodPagePageViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
	

	
	open weak var pageViewController:UIPageViewController!
    var player:AVAudioPlayer?
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
		pageViewController.dataSource = self;
		pageViewController.delegate = self;
		let startingViewController = viewControllerAtInder(0)
		let viewControllers:NSArray = [startingViewController]
		pageViewController.setViewControllers(viewControllers as? [UIViewController], direction:UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
		
		
		// Change the size of page view controller
		pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
		addChildViewController(pageViewController)
		view.addSubview(pageViewController.view)
		pageViewController.didMove(toParentViewController: self)
        
        player = ResourceAudioPlayer(fromName: "yummyfoods")
        player?.play()

	}
	
	open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let pageContentViewController:FoodPageViewController = storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! FoodPageViewController
		let vc = viewController as! FoodPageViewController
		let index = (vc.index - 1 + 6)%6
		pageContentViewController.index = index;
		pageContentViewController.selectedFoodImage?.isHidden = true;
		pageContentViewController.theCollection?.isHidden = false;
		return pageContentViewController;
	}
	
	open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let pageContentViewController:FoodPageViewController = storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! FoodPageViewController
		let vc = viewController as! FoodPageViewController
		let index = (vc.index + 1)%6
		pageContentViewController.index = index;
		pageContentViewController.selectedFoodImage?.isHidden = true;
		pageContentViewController.theCollection?.isHidden = false;
		return pageContentViewController;
	}
	
	open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if (!completed){
			return;
		}
		for item in previousViewControllers{
			let vc = item as! FoodPageViewController
			vc.selectedFoodImage.isHidden = true;
			vc.theCollection.isHidden = false;
			vc.tick.isHidden = true;
			vc.cross.isHidden = true;
		}
	}
	
	func viewControllerAtInder(_ index: Int) -> FoodPageViewController{
		let pageContentViewController:FoodPageViewController = storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! FoodPageViewController
		pageContentViewController.index = index % 6;
		return pageContentViewController;
	}
}
