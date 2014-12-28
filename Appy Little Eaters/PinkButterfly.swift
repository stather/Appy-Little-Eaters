//
//  PinkButterfly.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class PinkButterfly : Butterfly{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "pink-butterfly1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "PINKBUTTERFLY"
		perform()
	}
	
	func perform() {
		var atlas = SKTextureAtlas(named: "pinkbutterfly")
		var frames = [SKTexture]()
		for index in 1...3{
			frames.append(atlas.textureNamed("pink-butterfly_" + String(index)))
		}
		for var index = 2; index >= 2; index-- {
			frames.append(atlas.textureNamed("pink-butterfly_" + String(index)))
		}
		var action1 = SKAction.animateWithTextures(frames, timePerFrame: 0.2, resize: false, restore: true)
		var action2 = SKAction.repeatActionForever(action1)
		runAction(action2, withKey: "flapping")
	}

}