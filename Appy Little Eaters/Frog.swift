//
//  Frog.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Frog : ForestCreature, Performer{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "frog1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "FROG"
	}
	
	func perform() {
		var atlas = SKTextureAtlas(named: "frog")
		var frames = [SKTexture]()
		for index in 1...5{
			frames.append(atlas.textureNamed("frog_" + String(index)))
		}
		for var index = 4; index >= 2; index-- {
			frames.append(atlas.textureNamed("frog_" + String(index)))
		}
		var action1 = SKAction.animateWithTextures(frames, timePerFrame: 0.2, resize: false, restore: true)
		var action2 = SKAction.repeatAction(action1, count: 3)
		runAction(action2, withKey: "swaying")
	}
	
}