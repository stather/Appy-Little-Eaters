//
//  Dragon.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 26/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class GreenDragon : ForestCreature, Performer{
	
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "dragon1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "GREENDRAGON"
	}
	
	public func perform() {
		let wait:SKAction = SKAction.waitForDuration(0.25)
		let smoke2 = textureFrom("dragon2")
		let smoke3 = textureFrom("dragon3")
		let smoke4 = textureFrom("dragon4")
		let smoke5 = textureFrom("dragon5")
		let smoke6 = textureFrom("dragon6")
		let smoke7 = textureFrom("dragon2")
		let smoke8 = textureFrom("dragon1")

		let actions:[SKAction] = [wait, smoke2, wait, smoke3, wait, smoke4, wait, smoke5, wait, smoke6, wait, smoke7, wait, smoke8]
		let smokeSequence:SKAction = SKAction.sequence(actions);
		let smoking = SKAction.repeatAction(smokeSequence, count: 3)
		runAction(smoking)

	}
}