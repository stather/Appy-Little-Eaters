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
		var t:SKTexture = SKTexture(imageNamed: "fishinwater")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "BLUEFISH"
	}
	
	func perform() {
		var wait:SKAction = SKAction.waitForDuration(0.25)
		var smoke2 = textureFrom("fish1")
		var smoke3 = textureFrom("fish2")
		var smoke4 = textureFrom("fish3")
		var smoke5 = textureFrom("fish4")
		var smoke6 = textureFrom("fish5")
		var smoke7 = textureFrom("fish6")
		
		var actions:[SKAction] = [wait, smoke2, wait, smoke3, wait, smoke4, wait, smoke5, wait, smoke6, wait, smoke7]
		var smokeSequence:SKAction = SKAction.sequence(actions);
		var smoking = SKAction.repeatAction(smokeSequence, count: 3)
		runAction(smoking)
	}
}