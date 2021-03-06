//
//  SocialStoryViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 18/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit

public class SocialStoryViewController : UIViewController{

	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		currentPage = 1;
	}
	
	var currentPage:Int!
	
	@IBOutlet weak var image:UIImageView!
	@IBOutlet weak var backgroundView:UIView!
	@IBOutlet weak var theStory:UITextView!
	@IBOutlet weak var storyImage:UIImageView!


	@IBAction func previousPage(sender: AnyObject){
		currentPage = currentPage - 1
		if (currentPage == 0){
			currentPage = 8;
		}
		setup()
	}

	@IBAction func nextPage(sender: AnyObject){
		currentPage = currentPage + 1
		if (currentPage == 9){
			currentPage = 1;
		}
		setup()
	}



	var player:ResourceAudioPlayer!

	override public func viewDidLoad() {
		super.viewDidLoad()
		player = ResourceAudioPlayer(fromName: "eatinghealthyfoods2")
		player.play()
	}
	
	func setup(){
		switch (currentPage) {
		case 1:
			self.storyImage.image = UIImage(named: "social-story1.png")
			player = ResourceAudioPlayer(fromName: "eatinghealthyfoods2")
			player.play()
			break;
		case 2:
			self.storyImage.image = UIImage(named: "social-story2.png")
			player = ResourceAudioPlayer(fromName: "goodfoodmakes2")
			player.play()
			break;
		case 3:
			self.storyImage.image = UIImage(named: "social-story3.png")
			player = ResourceAudioPlayer(fromName: "healthykids2")
			player.play()
			break;
		case 4:
			self.storyImage.image = UIImage(named: "social-story4.png")
			player = ResourceAudioPlayer(fromName: "healthykids2")
			player.play()
			break;
		case 5:
			self.storyImage.image = UIImage(named: "social-story5.png")
			player = ResourceAudioPlayer(fromName: "healthykids2")
			player.play()
			break;
		case 6:
			self.storyImage.image = UIImage(named: "social-story6.png")
			player = ResourceAudioPlayer(fromName: "healthykids2")
			player.play()
			break;
		case 7:
			self.storyImage.image = UIImage(named: "social-story7.png")
			player = ResourceAudioPlayer(fromName: "healthykids2")
			player.play()
			break;
		case 8:
			self.storyImage.image = UIImage(named: "social-story8.png")
			player = ResourceAudioPlayer(fromName: "healthykids2")
			player.play()
			break;
			
		default:
			break;
		}
		var transition:CATransition = CATransition()
//		transition.duration = 1
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionFade
		storyImage.layer.addAnimation(transition, forKey: nil)
		
	}

}