//
//  ForestCreature.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 25/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class ForestCreature : SKSpriteNode{
	public func perform(){
		
	}

	func textureFrom(imageNamed:String) -> SKAction{
		return SKAction.setTexture(SKTexture(imageNamed: imageNamed))
	}

	override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
		var a = 1
		super.init(texture: texture, color: color, size: size)
	}

	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
}