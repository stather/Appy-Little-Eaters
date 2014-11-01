//
//  ForestScene.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import CoreData

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
	
	lazy var managedObjectContext : NSManagedObjectContext? = {
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		if let managedObjectContext = appDelegate.managedObjectContext {
			return managedObjectContext
		}
		else {
			return nil
		}
		}()

	lazy var managedObjectModel : NSManagedObjectModel? = {
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		return appDelegate.managedObjectModel
	}()
	
	override public func didMoveToView(view: SKView) {
		_speed = cStartSpeed
		backgroundWidth = Float(frame.width)
		backgroundHeight = Float(frame.height)
		
		var r:CGSize = frame.size
		fact = Float(r.height) / backgroundHeight
		anchorPoint = CGPoint(x: 0.5, y: 0.5)
		userInteractionEnabled = true
		alpha = 1
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

		var fetchAllRewards = managedObjectModel?.fetchRequestTemplateForName("FetchAllRewards")
		var error:NSErrorPointer! = NSErrorPointer()
		for item in managedObjectContext?.executeFetchRequest(fetchAllRewards!, error: error) as [DReward]{
			let reward:ForestCreature.CreatureName = ForestCreature.CreatureName(rawValue: Int(item.creatureName))!
			var creature:ForestCreature = ForestCreature.from(reward)
//			creature.position = CGPoint(x: CGFloat(item.positionX), y: CGFloat(item.positionY))
			creature.position = CGPoint(x: CGFloat(0), y: CGFloat(0))
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
			if item is Performer{
				var creature:Performer = item as Performer
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
