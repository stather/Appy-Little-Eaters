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
	
	public enum HorizontalDirection{
		case Left
		case Right
	}
	
	public enum VerticalDirection{
		case Up
		case Down
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
	
	var destination:CGPoint!
	var horizontalDirection:HorizontalDirection!
	var verticalDirection:VerticalDirection!
	
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

	func fly(amount: Float){
		var x:Float = Float(position.x)
		var y:Float = Float(position.y)
		var original = forestScene.originalPoint(position)
		var howMuch = forestScene.fact * ForestScene.backgroundWidth() / 10
		if horizontalDirection == HorizontalDirection.Left{
			if original.x > destination.x{
				x -= amount * 25
				if x < -howMuch*2{
					x += howMuch * 10
				}
				if x > howMuch*8{
					x -= howMuch * 10
				}
			}
		}else{
			if original.x < destination.x{
				x += amount * 25
				if x < -howMuch*2{
					x += howMuch * 10
				}
				if x > howMuch*8{
					x -= howMuch * 10
				}
			}
		}
		if verticalDirection == VerticalDirection.Down{
			if original.y > destination.y{
				y -= amount * 25
			}
		}else{
			if original.y < destination.y{
				y += amount * 25
			}
		}
		
		position = CGPoint(x: CGFloat(x), y: CGFloat(y))
		original = forestScene.originalPoint(position)
		println(abs(original.x - destination.x))
		var arrivedX = false
		var arrivedY = false
		if horizontalDirection == HorizontalDirection.Left{
			if original.x <= destination.x{
				println("Got to x dest")
				arrivedX = true
			}
		}else{
			if original.x >= destination.x{
				println("Got to x dest")
				arrivedX = true
			}
		}
		if verticalDirection == VerticalDirection.Down{
			if original.y <= destination.y{
				println("Got to y dest")
				arrivedY = true
			}
		}else{
			if original.y >= destination.y{
				println("Got to y dest")
				arrivedY = true
			}
		}
		if arrivedX && arrivedY{
			println("Got to destination")
			removeAllActions()
			texture = SKTexture(imageNamed: "bird-sitting_03")
			location = BirdLocation.SittingOnLeft
		}
	}
	
	
	
	func moveBy(amount: Float) {
		switch location{
		case .FlyingLeft:
			fly(amount)
			printGeometry()
			break
		case .FlyingRight:
			fly(amount)
			break
		default:
			break
		}
	}
	
}