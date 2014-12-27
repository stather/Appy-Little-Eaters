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
		case Blackberries = 1
		case Bluebells
		case BlueBird
		case BlueDragon
		case BlueFlowers
		case BrownBird
		case BrownRabbit
		case BrownSquirrel
		case BrownToadstool
		case WhiteRabbit
		case YellowButterfly
		case Deer
		case GreenDragon
		case Firefly
		case BlueFish
		case GreenFish
		case Foxglove
		case Frog
		case GreenFern
		case PinkButterfly
		case PinkFlowers
		case PurpleFern
		case RedToadstool
		case Squirrel
		case Strawberry
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
	}

	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	public func printGeometry(){
		var p = forestScene.originalPoint(position)
		print("x ")
		if p.x < 0{
			print(p.x + 9000)
		}
		else{
			print(p.x)
		}
		print(" y ")
		print(1035 - p.y)
		print(" scale ")
		var s = forestScene.fact / Float(xScale)
		print(s)
		println()
	}
	
	class func from(creatureName:CreatureName) -> ForestCreature{
		var creature:ForestCreature
		switch creatureName{
		case .Blackberries:
			creature = Blackberries()
			break
		case .Bluebells:
			creature = Bluebells()
			break
		case .BlueBird:
			creature = BlueBird()
			break
		case .BlueDragon:
			creature = BlueDragon()
			break
		case .BlueFlowers:
			creature = BlueFlowers()
			break
		case .BrownBird:
			creature = BrownBird()
			break
		case .BrownRabbit:
			creature = BrownRabbit()
			break
		case .BrownSquirrel:
			creature = BrownSquirrel()
			break
		case .BrownToadstool:
			creature = BrownToadstool()
			break
		case .WhiteRabbit:
			creature = WhiteRabbit()
			break
		case .YellowButterfly:
			creature = YellowButterfly1()
			break
		case .Deer:
			creature = Deer()
			break
		case .GreenDragon:
			creature = GreenDragon()
			break
		case .Firefly:
			creature = Firefly()
			break
		case .BlueFish:
			creature = Bluefish()
			break
		case .GreenFish:
			creature = GreenFish()
			break
		case .Foxglove:
			creature = Foxglove()
			break
		case .Frog:
			creature = Frog()
			break
		case .GreenFern:
			creature = GreenFern()
			break
		case .PinkButterfly:
			creature = PinkButterfly()
			break
		case .PinkFlowers:
			creature = PinkFlowers()
			break
		case .PurpleFern:
			creature = PurpleFern()
			break
		case .Squirrel:
			creature = Squirrel()
			break
		case .RedToadstool:
			creature = RedToadstool()
			break
		case .Strawberry:
			creature = Strawberry()
			break
		}
		return creature
	}
	
	
	func scrollBy(amount: Float) {
		delegate?.scrollBy(amount)
	}
	
	func didAddToScene(){
		delegate = StandardScroller(howMuch:forestScene.fact * ForestScene.backgroundWidth() / 10,  node: self)
	}
}