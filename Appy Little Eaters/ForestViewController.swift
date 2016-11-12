//
//  ForestViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit


public class ForestViewController : UIViewController{

	@IBOutlet weak var upButton: UIButton!
	@IBOutlet weak var downButton: UIButton!
	@IBOutlet weak var leftButton: UIButton!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var biggerButton: UIButton!
	@IBOutlet weak var smallerButton: UIButton!
	@IBOutlet weak var mirrorButton: UIButton!
	@IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var LeftLotsButton: UIButton!
    @IBOutlet weak var RightsLotsButton: UIButton!
	
	
	var spriteView:SKView!
	@IBOutlet weak var mainView:UIView!
	var startAnchor:CGPoint!
	@IBOutlet weak var homeButton:UIButton!
	var anchorLimit:CGFloat!
	var forest:ForestScene!
	
    @IBAction func done(sender: AnyObject) {
        forest.done()
    }
    
	
	var StartStop:Bool = true
	
	@IBAction func StartStop(sender: AnyObject) {
		if StartStop {
			forest.StopScrolling()
			StartStopButton.titleLabel?.text = "Start"
		}else{
			forest.StartScrolling()
			StartStopButton.titleLabel?.text = "Stop"
		}
		StartStop = !StartStop
	}
	
	@IBAction func Mirror(sender: AnyObject) {
		forest.Mirror()
	}
	
	@IBAction func Up(sender: AnyObject) {
		forest.MoveUp()
	}
	
	
	@IBAction func Down(sender: AnyObject) {
		forest.MoveDown()
	}
	
	@IBAction func Right(sender: AnyObject) {
		forest.MoveRight()
	}
	
    @IBAction func RightLots(sender: AnyObject) {
        forest.MoveRightLots()
    }
    
	@IBAction func Left(sender: AnyObject) {
		forest.MoveLeft()
	}
	
    @IBAction func LeftLots(sender: AnyObject) {
        forest.MoveLeftLots()
    }
	
	@IBAction func Smaller(sender: AnyObject) {
		forest.Smaller()
	}
	
	@IBAction func Bigger(sender: AnyObject) {
		forest.Bigger()
	}
	
	override public func viewWillAppear(animated: Bool) {
		spriteView = SKView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
		spriteView.opaque = false
        spriteView.allowsTransparency = true
		spriteView.showsDrawCount = false
		spriteView.showsNodeCount = false
		spriteView.showsFPS = false
		mainView.insertSubview(spriteView, belowSubview: homeButton)
		forest = ForestScene(size: CGSize(width: 1024, height: 768))
        if NSUserDefaults.standardUserDefaults().boolForKey("AnimationControls"){
            forest.AnimateCreatures = false
        }
		spriteView.presentScene(forest)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("AnimationControls"){
			upButton.hidden = true
			downButton.hidden = true
			leftButton.hidden = true
			rightButton.hidden = true
			biggerButton.hidden = true
			smallerButton.hidden = true
			mirrorButton.hidden = true
			StartStopButton.hidden = true
            DoneButton.hidden = true
            LeftLotsButton.hidden = true
            RightsLotsButton.hidden = true
		}
	}
	
	
	public override func viewDidLoad() {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.stopTheUke()
		appDelegate.playSceneSound()
		//appDelegate.speak("Welcome to the forest")
		
	}
	
	public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.stopSceneSound()
		appDelegate.playTheUke()
	}
	
	
}

