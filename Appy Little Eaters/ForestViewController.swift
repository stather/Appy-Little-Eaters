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
	
	override public func viewWillAppear(animated: Bool) {
		spriteView = SKView(frame: CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height))
		mainView.insertSubview(spriteView, belowSubview: homeButton)
		var forest:ForestScene = ForestScene(size: spriteView.frame.size)
		var w:Float = Float(mainView.frame.size.width)
		
		spriteView.presentScene(forest)
		anchorLimit = CGFloat((forest.scaledWidth - w)/2/w)
		
	}
	
	@IBAction func panGesture(sender: AnyObject) {
		var g = sender as UIPanGestureRecognizer
		
		if g.state == UIGestureRecognizerState.Began{
			startAnchor = spriteView.scene?.anchorPoint
		}
		var p = g.translationInView(mainView)
		var offset = p.x / spriteView.frame.size.width
		var anchor = startAnchor
		anchor.x += offset

		NSLog("anchor %@", anchor.x)
		if (anchor.x < -anchorLimit){
			anchor.x = -anchorLimit;
		}
		if (anchor.x > anchorLimit){
			anchor.x = anchorLimit;
		}
		spriteView.scene?.anchorPoint = anchor;

	}
}

