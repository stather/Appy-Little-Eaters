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
	var tileWidth:Float!
	var slice:Int!
	
	var delegate:ScrollableProtocol?
	
	lazy var forestScene:ForestScene = {
		return self.scene as! ForestScene
		}()
	
	convenience init(parentScene:ForestScene, slice:Int){
		let imageName:String = "REWARDS-FOREST-UPDATED_0" + slice.description + ".png"
		let t:SKTexture = SKTexture(imageNamed: imageName)
		let r:CGSize = parentScene.frame.size
		let h:Float = Float(r.height)
		let bh:Float = Float(t.size().height)
		let fact:Float = h / bh
		let newHeight:Float = Float(t.size().height) * fact
		let newWidth:Float = Float(t.size().width) * fact
		
		let s:CGSize = CGSizeMake(CGFloat(newWidth), CGFloat(newHeight))
		self.init(texture: t, color: UIColor.clearColor(), size: s)
		
		self.slice = slice

		tileWidth = newWidth
		delegate = StandardScroller(howMuch:tileWidth, node:self)
		position = CGPointMake(CGFloat(Float((slice-2))*newWidth), 0)
		if slice == 1 {
			parentScene.leftHandEdge = Float(position.x)
		}
		name = "BACKGROUND"
		
	}
	
	override init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func scrollBy(amount: Float) {
		delegate?.scrollBy(amount)
		if slice == 1 {
			forestScene.leftHandEdge = Float(position.x)
		}
	}
	
}


