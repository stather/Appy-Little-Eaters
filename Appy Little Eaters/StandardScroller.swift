//
//  StandardScroller.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 01/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

class StandardScroller : ScrollableProtocol{
	var howMuch:Float!
	var node:SKSpriteNode!
	init(howMuch:Float, node:SKSpriteNode){
		self.howMuch = howMuch
		self.node = node
	}
	
	@objc func scrollBy(amount: Float) {
		var x:Float = Float(node.position.x)
		var y:Float = Float(node.position.y)
		x += amount
		if x < -howMuch*2{
			x += howMuch * 10
		}
		if x > howMuch*8{
			x -= howMuch * 10
		}
		node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
	}
}