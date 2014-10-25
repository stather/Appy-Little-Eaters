//
//  Forest.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Forest : SKSpriteNode{
	var parentScene:ForestScene!
	
	convenience init(parentScene:ForestScene){
		var t:SKTexture = SKTexture(imageNamed: "rewards-forrestv2")
		var r:CGSize = parentScene.frame.size
		var h:Float = Float(r.height)
		var bh:Float = Float(640)
		var fact:Float = h / bh
		
		var s:CGSize = CGSizeMake(CGFloat(parentScene.backgroundWidth*fact), CGFloat(parentScene.backgroundHeight*fact))
		self.init(texture: t, color: UIColor.blackColor(), size: s)
		
		self.parentScene = parentScene
		position = CGPointMake(1024/2, 768/2)
		name = "BACKGROUND"
		
	}
	
	override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	
}


