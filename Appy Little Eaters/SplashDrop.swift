//
//  SplashDrop.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 09/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class SplashDrop : ForestCreature{
	var reachedTop = false
	var count = 5
	
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "drop1")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "SPLASH"
		physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
		var vy:Int = Int(arc4random_uniform(700)) + 400
		var vx:Int = Int(arc4random_uniform(400)) - 200
		physicsBody?.velocity = CGVector(dx: CGFloat(vx), dy: CGFloat(vy))
		physicsBody?.linearDamping = 0
		
	}
	
	public func splash(deltaTime: NSTimeInterval){
//		if (position.y >= 900){
//			reachedTop = true
//		}
		print("deltat ")
		println(deltaTime)
		if (position.y < 900 && count > 0){
			var f = 200/0.08*Float(deltaTime)
			var vec = CGVector(dx: 0.0, dy: CGFloat(f))
			//physicsBody?.applyImpulse(vec)
			println("applying impulse")
			reachedTop = true
			count--
		}
		print("velocity ")
		print(physicsBody?.velocity.dx)
		print(",")
		print(physicsBody?.velocity.dy)
		println()
		
	}
	
}