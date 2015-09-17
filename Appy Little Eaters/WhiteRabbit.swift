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
		let t:SKTexture = SKTexture(imageNamed: "bunny1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "WHITERABBIT"
	}
	
	func perform() {
		let wait:SKAction = SKAction.waitForDuration(0.25)
		let rabbit1 = textureFrom("bunny1")
		let rabbit2 = textureFrom("bunny2")
		let rabbit3 = textureFrom("bunny3")
		let rabbit4 = textureFrom("bunny4")
		let rabbit5 = textureFrom("bunny5")
		let rabbit6 = textureFrom("bunny6")
		let rabbit7 = textureFrom("bunny7")
		
		let actions:[SKAction] = [wait, rabbit1, wait, rabbit2, wait, rabbit3, wait, rabbit4, wait, rabbit5, wait, rabbit6, wait, rabbit7,
			wait, rabbit6, wait, rabbit5, wait, rabbit4, wait, rabbit3, wait, rabbit2, wait, rabbit1]
		let rabbitSequence:SKAction = SKAction.sequence(actions);
		let rabbiting = SKAction.repeatAction(rabbitSequence, count: 3)
		runAction(rabbiting)
	}
	
}