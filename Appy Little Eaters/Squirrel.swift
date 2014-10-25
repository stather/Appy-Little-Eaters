//
//  Squirrel.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Squirrel : SKSpriteNode{
	var parentScene:ForestScene!
	
	convenience init(parentScene:ForestScene){
		var t:SKTexture = SKTexture(imageNamed: "squirrel1")
		self.init(texture: t, color:UIColor.blackColor(), size:CGSize.zeroSize)
		self.parentScene = parentScene
		var p:CGPoint = parentScene.forestPoint(CGPointMake(224, 103))
		position = p
		var scale:Float = 0.7
		var a,b:Float
		a = Float(size.width) * scale
		b = Float(size.height) * scale
		
		size = CGSizeMake(CGFloat(a), CGFloat(b))
		name = "SQUIRREL"
	}
	
	override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
			super.init(texture: texture, color: color, size: size)
	}
	
	override init(){
		super.init()
	}

	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
}

