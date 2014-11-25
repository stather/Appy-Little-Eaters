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
		var t:SKTexture = SKTexture(imageNamed: "dragon1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "GREENDRAGON"
	}
	
	public func perform() {
		var wait:SKAction = SKAction.waitForDuration(0.25)
		var smoke2 = textureFrom("dragon2")
		var smoke3 = textureFrom("dragon3")
		var smoke4 = textureFrom("dragon4")
		var smoke5 = textureFrom("dragon5")
		var smoke6 = textureFrom("dragon6")
		var smoke7 = textureFrom("dragon2")
		var smoke8 = textureFrom("dragon1")

		var actions:[SKAction] = [wait, smoke2, wait, smoke3, wait, smoke4, wait, smoke5, wait, smoke6, wait, smoke7, wait, smoke8]
		var smokeSequence:SKAction = SKAction.sequence(actions);
		var smoking = SKAction.repeatAction(smokeSequence, count: 3)
		runAction(smoking)

	}
}