//
//  ParentsPageViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 19/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class ParentsPageViewController : UIViewController, InAppPurchaseDelegate{
	
	var currentPage:Int = 1
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	@IBOutlet weak var theText: UIImageView!
	
    @IBOutlet weak var animationProgress: UIProgressView!
    @IBOutlet weak var foodProgress: UIProgressView!
    @IBOutlet weak var rewardProgress: UIProgressView!
	@IBOutlet weak var pinit: UIButton!
	@IBOutlet weak var facebook: UIButton!
	@IBOutlet weak var webLink: UIButton!
	override public func viewDidLoad() {
		backButton.hidden = true
		facebook.hidden = true
		pinit.hidden = true
		webLink.hidden = true
	}

    public func FoodPurchased() {
    }
    
    public func FoodNotPurchased() {
    }
    
    @IBAction func BuyFood(sender: AnyObject) {
        InAppPurchaseManager.sharedInstance.BuyFood(self)
    }
    
    @IBAction func downloadRewards(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.deleteAllRewardsInPool()
        appDelegate.downloadRewards(rewardProgress)
    }
    
    @IBAction func downloadAnimations(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.deleteAllAnimations()
        appDelegate.downloadAnimations(animationProgress)
    }
    
    @IBAction func downloadFood(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.deleteAllFood()
        appDelegate.downloadFood(foodProgress)
    }
    
	
	@IBAction func backPressed(sender: AnyObject) {
		currentPage--
		setupPage()
	}
	
	@IBAction func nextPressed(sender: AnyObject) {
		currentPage++
		setupPage()
	}
	
	func setupPage(){
		switch currentPage{
		case 1:
			theText.image = UIImage(named: "PARENTS-PAGE-1.png")
			backButton.hidden = true
			break
		case 2:
			theText.image = UIImage(named: "PARENTS-PAGE-2.png")
			backButton.hidden = false
			break
		case 3:
			theText.image = UIImage(named: "PARENTS-PAGE-3.png")
			break
		case 4:
			theText.image = UIImage(named: "PARENTS-PAGE4.png")
			nextButton.hidden = false
			facebook.hidden = true
			pinit.hidden = true
			webLink.hidden = true
			break
		case 5:
			theText.image = UIImage(named: "PARENTS-PAGE5.png")
			nextButton.hidden = true
			facebook.hidden = false
			pinit.hidden = false
			webLink.hidden = false
			break
		default:
			break
		}
	}
	
	@IBAction func fillTheForest(sender: AnyObject) {
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        let allRewardsInPool = uow.rewardPoolRepository?.getAllRewardsInPool()
        
        for item in allRewardsInPool!{
            let reward = uow.rewardRepository?.createNewReward()
			
			reward!.creatureName = NSNumber(integer: Int(item.creatureName!))
			reward!.positionX = item.positionX!
//            reward!.positionY = 768 - Int(item.positionY!)
            reward!.positionY = Int(item.positionY!)
			reward!.scale = item.scale!
            reward!.animationName = item.imageName
            reward!.rewardName = item.rewardName
			item.available = false
		}
        uow.saveChanges()
	}
	
	@IBAction func clearTheForest(sender: AnyObject) {
        let uow = UnitOfWork()

        uow.rewardRepository?.deleteAllRewards()
        uow.rewardPoolRepository?.makeAllRewardsAvailable()
        
        uow.saveChanges()
	}
	
	@IBAction func facebookPressed(sender: AnyObject) {
		
	}
	
	@IBAction func webLinkPressed(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "http://www.readysteadyrainbow.com")!)
	}
	
	@IBAction func pinitPressed(sender: AnyObject) {
	}
}
