//
//  BlueFish.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Bluefish : ForestCreature, Performer{
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "fishinwater")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "BLUEFISH"
	}
	
	func perform() {
		let wait:SKAction = SKAction.waitForDuration(0.25)
		let smoke2 = textureFrom("fish1")
		let smoke3 = textureFrom("fish2")
		let smoke4 = textureFrom("fish3")
		let smoke5 = textureFrom("fish4")
		let smoke6 = textureFrom("fish5")
		let smoke7 = textureFrom("fish6")
		
		let actions:[SKAction] = [wait, smoke2, wait, smoke3, wait, smoke4, wait, smoke5, wait, smoke6, wait, smoke7]
		let smokeSequence:SKAction = SKAction.sequence(actions);
		let smoking = SKAction.repeatAction(smokeSequence, count: 3)
		runAction(smoking)
	}
}