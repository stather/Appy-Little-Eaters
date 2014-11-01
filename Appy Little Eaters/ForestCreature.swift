//
//  ForestCreature.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 25/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class ForestCreature : SKSpriteNode, ScrollableProtocol{
	enum CreatureName : Int{
		case Squirrel
		case Deer
		case Dragon
		case Bird
		case Toadstool
	}

	var delegate:ScrollableProtocol?

	lazy var forestScene:ForestScene = {
		return self.scene as ForestScene
	}()

	func textureFrom(imageNamed:String) -> SKAction{
		return SKAction.setTexture(SKTexture(imageNamed: imageNamed))
	}

	override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
		delegate = StandardScroller(node: self)
	}

	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	class func from(creatureName:CreatureName) -> ForestCreature{
		var creature:ForestCreature
		switch creatureName{
		case .Bird:
			creature = Bird()
			break
		case .Deer:
			creature = Deer()
			break
		case .Dragon:
			creature = Dragon()
			break
		case .Squirrel:
			creature = Squirrel()
			break
		case .Toadstool:
			creature = Toadstool()
		}
		return creature
	}
	
	
	func scrollBy(amount: Float) {
		delegate?.scrollBy(amount)
	}
}