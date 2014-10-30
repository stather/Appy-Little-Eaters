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
	}
	
}

