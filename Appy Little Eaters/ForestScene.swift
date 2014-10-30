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
	public var backgroundWidth:Float!
	public var backgroundHeight:Float!
	public var scaledWidth:Float!
	var fact:Float!

	var _lastUpdateTime:NSTimeInterval!
	var _dt:NSTimeInterval!
	let cStartSpeed:Float = 5
	let cMaxSpeed:Float = 80

	var _speed:Float!

	
	var characters: [ForestCreature] = []
	
	override public func didMoveToView(view: SKView) {
		_speed = cStartSpeed
		//var name = NSBundle.mainBundle().pathForResource("REWARDS-FOREST-UPDATED", ofType: "jpg")
		//var image:UIImage = UIImage(named: name!)!
		//backgroundHeight = Float(image.size.height)
		//backgroundWidth = Float(image.size.width)
		backgroundWidth = Float(frame.width)
		backgroundHeight = Float(frame.height)
		
		var r:CGSize = frame.size
		fact = Float(r.height) / backgroundHeight
		anchorPoint = CGPoint(x: 0.5, y: 0.5)
		//scaledWidth = backgroundWidth * fact
		userInteractionEnabled = true
		alpha = 1
		//backgroundColor = SKColor.clearColor()
		backgroundColor = SKColor.blueColor()
		scaleMode = SKSceneScaleMode.Fill
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
	
	public override func update(currentTime: NSTimeInterval) {
		if ((_lastUpdateTime) != nil) {
			_dt = currentTime - _lastUpdateTime;
		} else {
			_dt = 0;
		}
		_lastUpdateTime = currentTime;
		
		// Scroll

		for item in children {
			var node:SKNode = item as SKNode
			if node is ScrollableProtocol{
				var sp = node as ScrollableProtocol
				var amount:Float  = _speed * Float(_dt)
				sp.scrollBy(amount)
			}
		}
	}
	
	func createSceneContents(){
		for index in 1...10{
			var forest = Forest(parentScene: self, slice: index)
			addChild(forest)
		}
		
		var dict = NSUserDefaults.standardUserDefaults().arrayForKey("rewards")
		if dict == nil{
			var creature = Bird(parentScene: self)
			creature.position = CGPoint(x: 50, y: 50)
			creature.alpha = 1
			addChild(creature)
			characters.append(creature)
			return
		}
		var rewards:[NSDictionary] = dict as [NSDictionary]
		for item in rewards{
			var rewarddef:RewardDefinition = RewardDefinition(fromDictionary: item)
			var reward:ForestCreature.CreatureName = rewarddef.rewardType
			var creature:ForestCreature
			switch reward{
			case .Bird:
				creature = Bird(parentScene: self)
				break
			case .Deer:
				creature = Deer(parentScene: self)
				break
			case .Dragon:
				creature = Dragon(parentScene: self)
				break
			case .Squirrel:
				creature = Squirrel(parentScene: self)
				break
			}
			addChild(creature)
			characters.append(creature)
		}
		
	}
	
	public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		
		var touch:UITouch = touches.anyObject() as UITouch
		var location = touch.locationInNode(self)
		var nodes = nodesAtPoint(location)
		var creatureTouched:Bool = false
		for item in nodes{
			if item is ForestCreature{
				var creature:ForestCreature = item as ForestCreature
				creature.perform()
				creatureTouched = true
			}
		}
		if creatureTouched{
			return
		}
		if (_speed < cMaxSpeed && _speed > -cMaxSpeed) {
			_speed=_speed*2;
		} else {
			if (_speed<0) {
				_speed=cStartSpeed;
			} else {
				_speed = -cStartSpeed;
			}
		}
	
	}
}
