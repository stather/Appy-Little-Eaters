//
//  ForestViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class ForestViewController : UIViewController{
	
	var spriteView:SKView!
	@IBOutlet weak var mainView:UIView!
	var startAnchor:CGPoint!
	@IBOutlet weak var homeButton:UIButton!
	var anchorLimit:CGFloat!
	var forest:ForestScene!
	@IBOutlet weak var StartStopButton: UIButton!
	
	@IBOutlet weak var mass: UITextField!
	
	@IBOutlet weak var velocity: UITextField!
	
	@IBAction func start(sender: AnyObject) {
		var fmass:Float = (mass.text as NSString).floatValue
		var fvelocity:Float = (velocity.text as NSString).floatValue
		forest.restart(fmass, velocity: fvelocity)
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
	
	@IBAction func Up(sender: AnyObject) {
		forest.MoveUp()
	}
	
	
	@IBAction func Down(sender: AnyObject) {
		forest.MoveDown()
	}
	
	@IBAction func Right(sender: AnyObject) {
		forest.MoveRight()
	}
	
	@IBAction func Left(sender: AnyObject) {
		forest.MoveLeft()
	}
	
	
	@IBAction func Smaller(sender: AnyObject) {
		forest.Smaller()
	}
	
	@IBAction func Bigger(sender: AnyObject) {
		forest.Bigger()
	}
	
	override public func viewWillAppear(animated: Bool) {
		var f = mainView.frame
		spriteView = SKView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
		spriteView.opaque = false
		spriteView.allowsTransparency = true
		spriteView.showsDrawCount = true
		spriteView.showsNodeCount = true
		spriteView.showsFPS = true
		mainView.insertSubview(spriteView, belowSubview: homeButton)
		forest = ForestScene(size: CGSize(width: 1024, height: 768))
		spriteView.presentScene(forest)
	}
	
}

