//
//  Forest.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Forest : SKSpriteNode, ScrollableProtocol{
	var parentScene:ForestScene!
	var tileWidth:Float!
	
	convenience init(parentScene:ForestScene, slice:Int){
		var imageName:String = "REWARDS-FOREST-UPDATED_0" + slice.description + ".png"
		var t:SKTexture = SKTexture(imageNamed: imageName)
		var r:CGSize = parentScene.frame.size
		var h:Float = Float(r.height)
		var bh:Float = Float(t.size().height)
		var fact:Float = h / bh
		var newHeight:Float = Float(t.size().height) * fact
		var newWidth:Float = Float(t.size().width) * fact
		
		var s:CGSize = CGSizeMake(CGFloat(newWidth), CGFloat(newHeight))
		self.init(texture: t, color: UIColor.clearColor(), size: s)
		
		tileWidth = newWidth
		self.parentScene = parentScene
		position = CGPointMake(CGFloat(Float((slice-2))*newWidth), 0)
		name = "BACKGROUND"
		
	}
	
	override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func scrollBy(amount: Float) {
		var x:Float = Float(position.x)
		var y:Float = Float(position.y)
		x += amount
		if x < -tileWidth*2{
			x += tileWidth * 10
		}
		if x > tileWidth*8{
			x -= tileWidth * 10
		}
		position = CGPoint(x: CGFloat(x), y: CGFloat(y))

	}
	
}


