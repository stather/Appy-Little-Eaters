//
//  BlueDragon.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class BlueDragon : ForestCreature, Performer{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "blue-dragon-1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "BLUEDRAGON"
	}
	
	func perform() {
		var wait:SKAction = SKAction.waitForDuration(0.25)
		var drag2 = textureFrom("blue-dragon-2")
		var drag3 = textureFrom("blue-dragon-3")
		var drag4 = textureFrom("blue-dragon-4")
		var drag5 = textureFrom("blue-dragon5")
		var drag1 = textureFrom("blue-dragon-1")
		
		var actions:[SKAction] = [wait, drag2, wait, drag3, wait, drag4, wait, drag5, wait, drag4, wait, drag3, wait, drag2, wait, drag1]
		var dragSequence:SKAction = SKAction.sequence(actions);
		var draging = SKAction.repeatAction(dragSequence, count: 3)
		runAction(draging)
		
	}
	
}