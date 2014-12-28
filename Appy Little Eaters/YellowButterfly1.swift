//
//  YellowButterfly.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class YellowButterfly1 : ForestCreature, MoveableProtocol{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "butterfly1-1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "YELLOWBUTTERFLY1"
		perform()
	}
	
	func perform() {
		var atlas = SKTextureAtlas(named: "yellowbutterfly")
		var frames = [SKTexture]()
		for index in 1...4{
			frames.append(atlas.textureNamed("butterfly1-" + String(index)))
		}
		for var index = 3; index >= 2; index-- {
			frames.append(atlas.textureNamed("butterfly1-" + String(index)))
		}
		var action1 = SKAction.animateWithTextures(frames, timePerFrame: 0.2, resize: false, restore: true)
		var action2 = SKAction.repeatActionForever(action1)
		runAction(action2, withKey: "flapping")
	}
	
	override func didAddToScene() {
		pickRandomDestination()
	}
	
	func moveBy(amount: Float) {
		super.didAddToScene()
		fly(amount)
	}
	
	override func atDestination() {
		pickRandomDestination()
	}
	
	func pickRandomDestination(){
		var current = forestScene.originalPoint(position)
		var x = current.x
		var y = current.y
		let h = Int(arc4random_uniform(2))
		let v = Int(arc4random_uniform(2))
		let xdist = (Int(arc4random_uniform(3)) + 1) * 200
		let ydist = (Int(arc4random_uniform(3)) + 1) * 200
		switch h{
		case 0:
			horizontalDirection = HorizontalDirection.Left
			x -= CGFloat(xdist)
			break
		case 1:
			horizontalDirection = HorizontalDirection.Right
			x += CGFloat(xdist)
			break
		default:
			horizontalDirection = HorizontalDirection.Right
			x += CGFloat(xdist)
			break
		}
		switch v{
		case 0:
			verticalDirection = VerticalDirection.Down
			y -= CGFloat(ydist)
			break
		case 1:
			verticalDirection = VerticalDirection.Up
			y += CGFloat(ydist)
			break
		default:
			verticalDirection = VerticalDirection.Up
			y += CGFloat(ydist)
			break
		}
		if x <= 0 {
			x += CGFloat(xdist)
			horizontalDirection = HorizontalDirection.Right
		}
		if x >= 9000{
			x -= CGFloat(xdist)
			horizontalDirection = HorizontalDirection.Left
		}
		if y <= 0 {
			y += CGFloat(ydist)
			verticalDirection = VerticalDirection.Up
		}
		if y >= 1035{
			y -= CGFloat(ydist)
			verticalDirection = VerticalDirection.Down
			
		}
		destination = CGPoint(x: x, y: y)
	}
}