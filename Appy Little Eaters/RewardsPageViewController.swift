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
	
	lazy var managedObjectContext : NSManagedObjectContext? = {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext = appDelegate.managedObjectContext {
			return managedObjectContext
		}
		else {
			return nil
		}
	}()
	
	lazy var managedObjectModel : NSManagedObjectModel? = {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		return appDelegate.managedObjectModel
		}()
	
	@IBOutlet weak var DoneButton: UIButton!
	
	@IBAction func DonePressed(sender: UIButton) {
		
		var rewardDef = RewardDefinition(rewardType: ForestCreature.CreatureName(rawValue: Int(chosen.creatureName))! )
		let reward = NSEntityDescription.insertNewObjectForEntityForName("DReward", inManagedObjectContext: managedObjectContext!) as! DReward
		
		reward.creatureName = NSNumber(integer: Int(chosen.creatureName))
		reward.positionX = chosen.positionX
		reward.positionY = 1035 - Int(chosen.positionY)
		reward.scale = chosen.scale
		chosen.available = false		
		
		var error:NSErrorPointer = NSErrorPointer()
		managedObjectContext?.save(error)
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

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
	
	override func viewDidLoad() {
		var fetchRequest: NSFetchRequest = managedObjectModel?.fetchRequestTemplateForName("FetchAvailableRewards")?.copy() as! NSFetchRequest
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
		var error:NSErrorPointer = NSErrorPointer()
		let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: error)
		let rewards:[DRewardPool] = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as! [DRewardPool]
		var filepath:NSString =  NSBundle.mainBundle().pathForResource(rewards[0].imageName, ofType: "png")!
		LeftReward.image = UIImage(contentsOfFile: filepath as String)
		lhs = rewards[0]

		filepath =  NSBundle.mainBundle().pathForResource(rewards[1].imageName, ofType: "png")!
		RightReward.image = UIImage(contentsOfFile: filepath as String)
		rhs = rewards[1]
		DoneButton.enabled = false;
	}
}