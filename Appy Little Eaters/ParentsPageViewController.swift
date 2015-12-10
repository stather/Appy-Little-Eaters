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

public class ParentsPageViewController : UIViewController{
	
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
	
	
	
	@IBAction func facebookPressed(sender: AnyObject) {
		
	}
	
	@IBAction func webLinkPressed(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "http://www.readysteadyrainbow.com")!)
	}
	
	@IBAction func pinitPressed(sender: AnyObject) {
	}
}
