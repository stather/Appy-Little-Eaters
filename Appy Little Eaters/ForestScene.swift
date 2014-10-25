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
/*
		SKSpriteNode * forest = [self newForestNode];
		[self addChild: forest];
		
		SKSpriteNode * bird = [self newBirdSittingNode];
		[forest addChild: bird];
		
		self.birdOnLeftTree = NO;
		self.birdOnRightTree = YES;
		
		SKSpriteNode * dragon = [self newDragonNode];
		[forest addChild:dragon];
		
		SKSpriteNode * squirrel = [self newSquirrelNode];
		[forest addChild:squirrel];
		
		SKSpriteNode* deer = [self newDeerNode];
		[forest addChild:deer];
*/
	}
}
