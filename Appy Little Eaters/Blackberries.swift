//
//  Blackberries.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Blackberries : ForestCreature{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "blackberries1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "BLACKBERRIES"
		perform()
	}
	
	func perform() {
		var atlas = SKTextureAtlas(named: "blackberry")
		var frames = [SKTexture]()
		for index in 1...7{
			frames.append(atlas.textureNamed("black_berries" + String(index)))
		}
		for var index = 6; index >= 2; index-- {
			frames.append(atlas.textureNamed("black_berries" + String(index)))
		}
		var action1 = SKAction.animateWithTextures(frames, timePerFrame: 0.2, resize: false, restore: true)
		var action2 = SKAction.repeatActionForever(action1)
		runAction(action2, withKey: "swaying")
	}
	
}