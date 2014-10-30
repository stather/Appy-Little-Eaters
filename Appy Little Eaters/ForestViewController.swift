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
	
//	@IBOutlet weak var myScroller: UIScrollView!
	
//	@IBOutlet weak var backgroundImage: UIImageView!
	
	override public func viewWillAppear(animated: Bool) {
		var f = mainView.frame
		spriteView = SKView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
		spriteView.opaque = false
		spriteView.allowsTransparency = true
		spriteView.showsDrawCount = true
		spriteView.showsNodeCount = true
		spriteView.showsFPS = true
		mainView.insertSubview(spriteView, belowSubview: homeButton)
		var forest = ForestScene(size: CGSize(width: 1024, height: 768))
		spriteView.presentScene(forest)
		
//		anchorLimit = CGFloat((forest.scaledWidth - w)/2/w)
	}
	
	@IBAction func panGesture(sender: AnyObject) {
		/*
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
*/
	}
}

