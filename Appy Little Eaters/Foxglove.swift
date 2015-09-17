//
//  Foxglove.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Foxglove : ForestCreature{
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "foxglove1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "FOXGLOVE"
		perform()
	}
	
	func perform() {
		let atlas = SKTextureAtlas(named: "foxglove")
		var frames = [SKTexture]()
		for index in 1...7{
			frames.append(atlas.textureNamed("fox_glove" + String(index)))
		}
		for var index = 6; index >= 2; index-- {
			frames.append(atlas.textureNamed("fox_glove" + String(index)))
		}
		let action1 = SKAction.animateWithTextures(frames, timePerFrame: 0.2, resize: false, restore: true)
		let action2 = SKAction.repeatActionForever(action1)
		runAction(action2, withKey: "swaying")
	}
	
}