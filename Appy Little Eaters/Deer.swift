//
//  Deer.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 26/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Deer : ForestCreature, Performer{

	
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "deer1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
/*
		var p:CGPoint = parentScene.forestPoint(CGPointMake(645, 200))
		position = p
		var scale:Float = 0.15
		var a,b:Float
		a = Float(size.width) * scale
		b = Float(size.height) * scale
		
		size = CGSizeMake(CGFloat(a), CGFloat(b))
*/
		name = "DEER"
	}
	
	public func perform() {
		let wait = SKAction.waitForDuration(0.1)
		
		let eat2 = textureFrom("deer2")
		let eat3 = textureFrom("deer3")
		let eat4 = textureFrom("deer4")
		let eat5 = textureFrom("deer5")
		let eat6 = textureFrom("deer6")
		let eat7 = textureFrom("deer7")
		let eat1 = textureFrom("deer1")
		
		let actions:[SKAction] = [wait, eat2, wait, eat3, wait, eat4, wait, eat5, wait, eat6, wait, eat7, wait, eat6, wait, eat5, wait, eat4, wait, eat3, wait, eat2, wait, eat1]
		let eatSequence:SKAction = SKAction.sequence(actions);
		let eating = SKAction.repeatAction(eatSequence, count: 3)
		runAction(eating)

	}
}