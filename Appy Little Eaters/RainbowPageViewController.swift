//
//  RainbowPageViewController.swift
//  Appy Little Eaters
//
//  Created by Russell Stather on 11/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc
public class RainbowPageViewController: UIViewController{
	
	@IBOutlet weak var RedBand: UIImageView!
	@IBOutlet weak var OrangeBand: UIImageView!
	@IBOutlet weak var YellowBand: UIImageView!
	@IBOutlet weak var GreenBand: UIImageView!
	@IBOutlet weak var BrownBand: UIImageView!
	@IBOutlet weak var PurpleBand: UIImageView!
	
	public var colour: Int = 0
	public var foodEaten: Bool = false
	var theBand:UIView!
	var theColour:NSString!
	var player:AVAudioPlayer!
	
	@IBAction func tapped(sender: UITapGestureRecognizer) {
		theBand.hidden = false;
		theBand.alpha = 1.0;
		UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {
			UIView.setAnimationRepeatCount(5);
			self.theBand.alpha = 0;
			}, completion:{(Bool finished)-> Void in
				self.theBand.alpha = 1.0
				self.performSegueWithIdentifier("RainbowToReward", sender: self);
		});
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: theColour);
	}
	
	
	
	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
	
	public override func viewWillAppear(animated: Bool) {
		if (NSUserDefaults.standardUserDefaults().boolForKey("RED")){
			RedBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("ORANGE")){
			OrangeBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("YELLOW")){
			YellowBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("GREEN")){
			GreenBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("BROWN")){
			BrownBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("PURPLE")){
			PurpleBand.hidden = false;
		}
		if (foodEaten){
			switch colour
				{
			case 0:
				theBand = RedBand;
				theColour = "RED"
				break;
			case 1:
				theBand = OrangeBand;
				theColour = "ORANGE"
				break;
			case 2:
				theBand = YellowBand;
				theColour = "YELLOW"
				break;
			case 3:
				theBand = GreenBand;
				theColour = "GREEN"
				break;
			case 4:
				theBand = BrownBand;
				theColour = "BROWN"
				break;
			case 5:
				theBand = PurpleBand;
				theColour = "PURPLE"
				break;
			default:
				return;
			}
			theBand.hidden = false;
			theBand.alpha = 1.0;
			UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {UIView.setAnimationRepeatCount(5);self.theBand.alpha = 0;}, completion:{(Bool finished)-> Void in });

		}else{
			var soundFilePath:NSString
			soundFilePath = NSBundle.mainBundle().pathForResource("myfoodrainbow", ofType: "m4a")!
			var fileUrl:NSURL
			fileUrl = NSURL.fileURLWithPath(soundFilePath)!
			player = AVAudioPlayer(contentsOfURL: fileUrl, error: nil)
			player.play()
			
		}
	}
	
}