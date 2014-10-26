//
//  ForestScene.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class ForestScene : SKScene{
	var contentCreated:Bool = false
	public let backgroundWidth:Float = 3710
	public let backgroundHeight:Float = 640
	public var scaledWidth:Float!
	var fact:Float!

	var characters: [ForestCreature] = []
	
	override public func didMoveToView(view: SKView) {
		var r:CGSize = frame.size
		fact = Float(r.height) / backgroundHeight
		scaledWidth = backgroundWidth * fact
		if (!self.contentCreated)
		{
			createSceneContents()
			contentCreated = true
		}
	}
	
	public func forestPoint(p:CGPoint) -> CGPoint{

		var width:Float = backgroundWidth*fact;
		var height:Float = backgroundHeight*fact;
				
		return CGPointMake(CGFloat(Float(p.x) - (width/2)), CGFloat((height/2)-Float(p.y)))
	}
	
	
	func createSceneContents(){
		backgroundColor = SKColor.blueColor()
		scaleMode = SKSceneScaleMode.AspectFill
		var forest = Forest(parentScene: self)
		addChild(forest)
		
		var squirrel = Squirrel(parentScene: self)
		forest.addChild(squirrel)
		characters.append(squirrel)
		
		var deer:Deer = Deer(parentScene: self)
		forest.addChild(deer)
		characters.append(deer)
		
		var bird:Bird = Bird(parentScene: self)
		forest.addChild(bird)
		characters.append(bird)
		
		var dragon:Dragon = Dragon(parentScene: self)
		forest.addChild(dragon)
		characters.append(dragon)

	}
	
	public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		
		var touch:UITouch = touches.anyObject() as UITouch
		var location = touch.locationInNode(self)
		var nodes = nodesAtPoint(location)
		for item in nodes{
			if item is ForestCreature{
				var creature:ForestCreature = item as ForestCreature
				creature.perform()
			}
		}
/*
		[nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			SKNode * node = obj;
			if ([node.name isEqualToString:@"BIRD"] && self.birdOnRightTree){
			[self flyToLeftTree];
			return;
			}
			if ([node.name isEqualToString:@"BIRD"] && self.birdOnLeftTree){
			[self flyToRightTree];
			return;
			}
			if ([node.name isEqualToString:@"BIRD"] && self.birdFlyingRight){
			[self flyToLeftTree];
			return;
			}
			if ([node.name isEqualToString:@"BIRD"] && self.birdFlyingLeft){
			[self flyToRightTree];
			return;
			}
			if ([node.name isEqualToString:@"DRAGON"]){
			[self dragonSmoke];
			}
			if ([node.name isEqualToString:@"SQUIRREL"]){
			[self squirrelEatNut];
			}
			if ([node.name isEqualToString:@"DEER"]){
			[self deerEatGrass];
			}
			}];
*/
	}
}
