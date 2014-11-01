//
//  Squirrel.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Squirrel : ForestCreature, Performer{
	
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "squirrel1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		/*
		var p:CGPoint = parentScene.forestPoint(CGPointMake(224, 103))
		position = p
		var scale:Float = 0.7
		var a,b:Float
		a = Float(size.width) * scale
		b = Float(size.height) * scale
		
		size = CGSizeMake(CGFloat(a), CGFloat(b))
*/
		name = "SQUIRREL"
	}


	public func perform() {

		var wait:SKAction = SKAction.waitForDuration(0.1)
		
		var eat2:SKAction = textureFrom("squirrel2")
		var eat3:SKAction = textureFrom("squirrel3")
		var eat4:SKAction = textureFrom("squirrel4")
		var eat5:SKAction = textureFrom("squirrel5")
		var eat6:SKAction = textureFrom("squirrel6")
		var eat7:SKAction = textureFrom("squirrel7")
		var eat1:SKAction = textureFrom("squirrel1")
		
		var actions:[SKAction] = [wait, eat2, wait, eat3, wait, eat4, wait, eat5, wait, eat6, wait, eat7, wait, eat6, wait, eat5, wait, eat4, wait, eat3, wait, eat2, wait, eat1]
		
		var eatSequence:SKAction = SKAction.sequence(actions);

		var eating:SKAction = SKAction.repeatAction(eatSequence, count:3)
		runAction(eating)

	}
}

