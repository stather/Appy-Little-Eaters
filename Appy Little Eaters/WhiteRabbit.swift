//
//  WhiteRabbit.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class WhiteRabbit : ForestCreature, Performer{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "bunny1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "WHITERABBIT"
	}
	
	func perform() {
		var wait:SKAction = SKAction.waitForDuration(0.25)
		var rabbit1 = textureFrom("bunny1")
		var rabbit2 = textureFrom("bunny2")
		var rabbit3 = textureFrom("bunny3")
		var rabbit4 = textureFrom("bunny4")
		var rabbit5 = textureFrom("bunny5")
		var rabbit6 = textureFrom("bunny6")
		var rabbit7 = textureFrom("bunny7")
		
		var actions:[SKAction] = [wait, rabbit1, wait, rabbit2, wait, rabbit3, wait, rabbit4, wait, rabbit5, wait, rabbit6, wait, rabbit7,
			wait, rabbit6, wait, rabbit5, wait, rabbit4, wait, rabbit3, wait, rabbit2, wait, rabbit1]
		var rabbitSequence:SKAction = SKAction.sequence(actions);
		var rabbiting = SKAction.repeatAction(rabbitSequence, count: 3)
		runAction(rabbiting)
	}
	
}