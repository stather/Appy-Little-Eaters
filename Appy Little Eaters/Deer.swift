//
//  Deer.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 26/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Deer : ForestCreature{

	var parentScene:ForestScene?
	
	convenience init(parentScene:ForestScene){
		var t:SKTexture = SKTexture(imageNamed: "deer1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		self.parentScene = parentScene
		var p:CGPoint = parentScene.forestPoint(CGPointMake(645, 200))
		position = p
		var scale:Float = 0.15
		var a,b:Float
		a = Float(size.width) * scale
		b = Float(size.height) * scale
		
		size = CGSizeMake(CGFloat(a), CGFloat(b))
		name = "DEER"
	}
	
	public override func perform() {
		var wait = SKAction.waitForDuration(0.1)
		
		var eat2 = textureFrom("deer2")
		var eat3 = textureFrom("deer3")
		var eat4 = textureFrom("deer4")
		var eat5 = textureFrom("deer5")
		var eat6 = textureFrom("deer6")
		var eat7 = textureFrom("deer7")
		var eat1 = textureFrom("deer1")
		
		var actions:[SKAction] = [wait, eat2, wait, eat3, wait, eat4, wait, eat5, wait, eat6, wait, eat7, wait, eat6, wait, eat5, wait, eat4, wait, eat3, wait, eat2, wait, eat1]
		var eatSequence:SKAction = SKAction.sequence(actions);
		var eating = SKAction.repeatAction(eatSequence, count: 3)
		runAction(eating)

	}
}