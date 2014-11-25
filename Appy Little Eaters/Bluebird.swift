//
//  Bird.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 26/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class BlueBird : ForestCreature, Performer{

	public enum BirdLocation {
		case SittingOnRight
		case SittingOnLeft
		case FlyingRight
		case FlyingLeft
	}
	
	var location:BirdLocation = BirdLocation.SittingOnRight
	
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "bird-sitting_03")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "BLUEBIRD"
	}
	
	func flappingBird() -> SKAction{
		var wait = SKAction.waitForDuration(0.1)
		var flap1 = textureFrom("bird1_03")
		var flap2 = textureFrom("bird2_03")
		var flap3 = textureFrom("bird3_03")
		var flap4 = textureFrom("bird4_03")
		var flap5 = textureFrom("bird5_03")
		var flap6 = textureFrom("bird4_03")
		var flap7 = textureFrom("bird3_03")
		var flap8 = textureFrom("bird2_03")
		var actions:[SKAction] = [flap1, wait, flap2, wait, flap3, wait, flap4, wait, flap5, wait, flap6, wait, flap7, wait, flap8, wait]
		var flappingSequence:SKAction = SKAction.sequence(actions)
		var flapping = SKAction.repeatActionForever(flappingSequence)
		return flapping
	}
	
	func flyToLeftTree(){
		xScale = 1
		removeAllActions()
		var p:CGPoint = forestScene.forestPoint(CGPointMake(383, 108))
		var flyPath = SKAction.moveTo(p, duration: 5)
		var sitting = textureFrom("bird-sitting_03")
		var flight = SKAction.sequence([flyPath,sitting])
		location = BirdLocation.FlyingLeft
		runAction(flappingBird(), withKey: "flapping")
		runAction(flight, completion: {
			self.removeActionForKey("flapping")
			self.location = BirdLocation.SittingOnLeft
		})
		
	}
	
	func flyToRightTree(){
		xScale = -1
		removeAllActions()
		var p:CGPoint = forestScene.forestPoint(CGPointMake(904, 65))
		var flyPath = SKAction.moveTo(p, duration: 5)
		var sitting = textureFrom("bird-sitting_03")
		var flight = SKAction.sequence([flyPath,sitting])
		location = BirdLocation.FlyingLeft
		runAction(flappingBird(), withKey: "flapping")
		runAction(flight, completion: {
			self.removeActionForKey("flapping")
			self.location = BirdLocation.SittingOnRight
		})
		
	}

	public func perform() {
		switch location{
		case .SittingOnRight:
			flyToLeftTree()
			break
		case .SittingOnLeft:
			flyToRightTree()
			break
		case .FlyingRight:
			break
		case .FlyingLeft:
			break
		}
	}
	
}