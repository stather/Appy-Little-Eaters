//
//  RewardsPageViewController.swift
//  Appy Little Eaters
//
//  Created by Russell Stather on 28/09/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RewardsPageViewController: UIViewController{
	
	var chosen:DRewardPool!
	var lhs:DRewardPool!
	var rhs:DRewardPool!
	
	
	@IBOutlet weak var DoneButton: UIButton!
	
	@IBAction func DonePressed(sender: UIButton) {
        if chosen != nil{
            let uow = UnitOfWork()
            let reward = uow.rewardRepository?.createNewReward()
		
            reward!.positionX = chosen.positionX!
            reward!.positionY = chosen.positionY!
            reward!.scale = chosen.scale!
            reward!.animationName = chosen.imageName!
            reward!.rewardName = chosen.rewardName!
            chosen.available = false
            uow.saveChanges()
        }
        
		performSegueWithIdentifier("RewardToForest", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
	}
	
	@IBOutlet weak var RightReward: UIImageView!
	
	@IBOutlet weak var LeftReward: UIImageView!
	
	@IBAction func LeftImageTapped(sender: UITapGestureRecognizer) {
		LeftReward.backgroundColor = UIColor.redColor()
		RightReward.backgroundColor = UIColor.clearColor()
		chosen = lhs
		DoneButton.enabled = true
	}
	
	@IBAction func RightImageTapped(sender: UITapGestureRecognizer) {
		RightReward.backgroundColor = UIColor.redColor()
		LeftReward.backgroundColor = UIColor.clearColor()
		chosen = rhs
		DoneButton.enabled = true
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
    
    func loadRewardImage(name:String) -> UIImage{
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let bundleID:String = NSBundle.mainBundle().bundleIdentifier!
        
        let possibleURLS:NSArray = fileManager.URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let appSupportDir:NSURL = possibleURLS[0] as! NSURL
        let dirPath = appSupportDir.URLByAppendingPathComponent(bundleID)
        let filename = dirPath.URLByAppendingPathComponent(name + "RewardImage." + "png")
        let filepath = filename.path
        let image:UIImage = UIImage(contentsOfFile: filepath as String!)!
        return image;
        
    }

	
	override func viewDidLoad() {
        let uow = UnitOfWork()
        let rewards:[DRewardPool] = (uow.rewardPoolRepository?.getAvailableRewardsOrderedByLevel())!
        
        if rewards.count == 0 {
            let alert = UIAlertController(title: "Rewards", message: "Sorry no more rewards are available", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { (action) in
                print(action)
            }
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: false, completion: { () -> Void in
            
            })
            return
            
        }
		LeftReward.image = loadRewardImage(rewards[0].imageName!)
		lhs = rewards[0]

		RightReward.image = loadRewardImage(rewards[1].imageName!)
		rhs = rewards[1]
		DoneButton.enabled = false;
	}
}
