//
//  RewardsPageViewController.swift
//  Appy Little Eaters
//
//  Created by Russell Stather on 28/09/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit


class RewardsPageViewController: UIViewController{
	
	var chosen:Int = 0
	
	@IBOutlet weak var DoneButton: UIButton!
	
	@IBAction func DonePressed(sender: UIButton) {
		performSegueWithIdentifier("RewardToForest", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
	}
	
	@IBOutlet weak var RightReward: UIImageView!
	
	@IBOutlet weak var LeftReward: UIImageView!
	
	@IBAction func LeftImageTapped(sender: UITapGestureRecognizer) {
		LeftReward.backgroundColor = UIColor.redColor()
		RightReward.backgroundColor = UIColor.clearColor()
		chosen = 1
		DoneButton.enabled = true
	}
	
	@IBAction func RightImageTapped(sender: UITapGestureRecognizer) {
		RightReward.backgroundColor = UIColor.redColor()
		LeftReward.backgroundColor = UIColor.clearColor()
		chosen = 2
		DoneButton.enabled = true
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
	
	override func viewDidLoad() {
		var filepath:NSString =  NSBundle.mainBundle().pathForResource("green-fern", ofType: "png")!
		LeftReward.image = UIImage(contentsOfFile: filepath)
		filepath = NSBundle.mainBundle().pathForResource("pink-butterfly", ofType: "png")!
		RightReward.image = UIImage(contentsOfFile: filepath)
		DoneButton.enabled = false;
	}
}