//
//  Bird.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 26/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class BlueBird : ForestCreature, Performer, MoveableProtocol{

	public enum BirdLocation {
		case SittingOnRight
		case SittingOnLeft
		case FlyingRight
		case FlyingLeft
	}
	
	
	var location:BirdLocation = BirdLocation.SittingOnRight
	
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "bird-sitting_03")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "BLUEBIRD"
	}
	
	func flappingBird() -> SKAction{
		let wait = SKAction.waitForDuration(0.1)
		let flap1 = textureFrom("bird1_03")
		let flap2 = textureFrom("bird2_03")
		let flap3 = textureFrom("bird3_03")
		let flap4 = textureFrom("bird4_03")
		let flap5 = textureFrom("bird5_03")
		let flap6 = textureFrom("bird4_03")
		let flap7 = textureFrom("bird3_03")
		let flap8 = textureFrom("bird2_03")
		let actions:[SKAction] = [flap1, wait, flap2, wait, flap3, wait, flap4, wait, flap5, wait, flap6, wait, flap7, wait, flap8, wait]
		let flappingSequence:SKAction = SKAction.sequence(actions)
		let flapping = SKAction.repeatActionForever(flappingSequence)
		return flapping
	}
	
	
	func flyToLeftTree(){
		xScale = 1
		removeAllActions()
		destination = CGPointMake(2727, 1035 - 389)
		horizontalDirection = HorizontalDirection.Left
		verticalDirection = VerticalDirection.Down
		location = BirdLocation.FlyingLeft
		runAction(flappingBird(), withKey: "flapping")
		
	}
	
	func flyToRightTree(){
		xScale = -1
		removeAllActions()
		destination = CGPointMake(4448, 1035 - 217)
		horizontalDirection = HorizontalDirection.Right
		verticalDirection = VerticalDirection.Up
		location = BirdLocation.FlyingRight
		runAction(flappingBird(), withKey: "flapping")
		
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

	override func atDestination() {
		super.atDestination()
		removeAllActions()
		texture = SKTexture(imageNamed: "bird-sitting_03")
		location = BirdLocation.SittingOnLeft
	}
	
	
	func moveBy(amount: Float) {
		switch location{
		case .FlyingLeft:
			fly(amount)
			break
		case .FlyingRight:
			fly(amount)
			break
		default:
			break
		}
	}
	
}