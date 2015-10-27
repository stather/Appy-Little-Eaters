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
		let y:Float = Float(node.position.y)
		x += amount
//		if x < -howMuch*2{
//			x += howMuch * 10
//		}
//		if x > howMuch*8{
//			x -= howMuch * 10
//		}
        if amount < 0 && x < -1000 {
            x += 7093
        }
        if amount > 0 && x > 2000 {
            x -= 7093
        }
		node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
	}
}