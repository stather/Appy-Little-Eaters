//
//  YellowButterfly.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class YellowButterfly1 : Butterfly{
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "butterfly1-1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "YELLOWBUTTERFLY1"
		perform()
	}
	
	func perform() {
		let atlas = SKTextureAtlas(named: "yellowbutterfly")
		var frames = [SKTexture]()
		for index in 1...4{
			frames.append(atlas.textureNamed("butterfly1-" + String(index)))
		}
		for var index = 3; index >= 2; index-- {
			frames.append(atlas.textureNamed("butterfly1-" + String(index)))
		}
		let action1 = SKAction.animateWithTextures(frames, timePerFrame: 0.2, resize: false, restore: true)
		let action2 = SKAction.repeatActionForever(action1)
		runAction(action2, withKey: "flapping")
	}
	
}