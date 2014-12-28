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
	
	class func backgroundWidth() -> Float{
		return 9000
	}
	
	
	public let backgroundHeight:Float = 1035
	public var scaledWidth:Float!
	public var fact:Float!
	var count:Int = 0
	
	var _lastUpdateTime:NSTimeInterval!
	var _dt:NSTimeInterval!
	let cStartSpeed:Float = 5
	let cMaxSpeed:Float = 80
	
	public var leftHandEdge:Float!
	
	var _speed:Float!
	
	
	var characters: [ForestCreature] = []
	
	lazy public var tileWidth : Float? = {
		return ForestScene.backgroundWidth()/10 * self.fact
	}()
	
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
		
		var width:Float = ForestScene.backgroundWidth()*fact;
		var height:Float = backgroundHeight*fact;
		
		var scaledx:Float = (Float(p.x)) * fact
		var scaledy:Float = Float(p.y) * fact
				
		return CGPointMake(CGFloat(scaledx + leftHandEdge - tileWidth!/2), CGFloat(scaledy - (height/2)))
	}
	
	public func originalPoint(p:CGPoint) -> CGPoint{
		var width:Float = ForestScene.backgroundWidth()*fact;
		var height:Float = backgroundHeight*fact;
		
		var tileWidth:Float = ForestScene.backgroundWidth()/10 * fact
		
		var x = Float(p.x)
		var y = Float(p.y)
		
		var scaledx = x + tileWidth/2 - leftHandEdge
		var scaledy = y + height/2
		
		var origx = scaledx / fact
		var origy = scaledy / fact
		
		if origx < 0 {
			origx += 9000
		}
		
		return CGPoint(x: CGFloat(origx), y: CGFloat(origy))
		
	}
	
	public override func update(currentTime: NSTimeInterval) {
		if ((_lastUpdateTime) != nil) {
			_dt = currentTime - _lastUpdateTime;
		} else {
			_dt = 0;
		}
		_lastUpdateTime = currentTime;
		
		// Scroll
		
		if (Scrolling){
			for item in children {
				var node:SKNode = item as SKNode
				if node is ScrollableProtocol && node is Forest{
					var sp = node as ScrollableProtocol
					var amount:Float  = _speed * Float(_dt)
					sp.scrollBy(amount)
				}
			}
			for item in children {
				var node:SKNode = item as SKNode
				if node is ScrollableProtocol && !(node is Forest){
					var sp = node as ScrollableProtocol
					var amount:Float  = _speed * Float(_dt)
					sp.scrollBy(amount)
				}
				if node is MoveableProtocol && !(node is Forest){
					var mp = node as MoveableProtocol
					mp.moveBy(Float(_dt))
				}
				if node is SGG_Spine{
					let n = node as SGG_Spine
					n.activateAnimations()
				}
			}
		}
		//frog.splash(_dt)
		if count > 0{
			var frog = SplashDrop()
			frog.position = self.forestPoint(CGPoint(x: CGFloat(1400), y: CGFloat(500)))
			self.addChild(frog)
			count--
		}
	}
	
	public override func didSimulatePhysics() {
		self.enumerateChildNodesWithName("SPLASH", usingBlock: {
			(node:SKNode!, stop:UnsafeMutablePointer <ObjCBool> ) -> Void in
			var bottom = -(self.backgroundHeight*self.fact)/2
			if node.position.y < CGFloat(bottom) {
				node.removeFromParent()
			}
		})
	}
	
	
	func createSceneContents(){
		//var n = SGG_Spine()
		//n.skeletonFromFileNamed("deer", andAtlasNamed: "deer", andUseSkinNamed: nil)
		//n.queuedAnimation = "animation"
		//n.queueIntro = 0.1
		//n.runAnimation("animation", andCount: 0, withIntroPeriodOf: 0.1, andUseQueue: true)
		//n.xScale = 0.5
		//n.yScale = 0.5
		//addChild(n)
		
		for index in 1...10{
			var forest = Forest(parentScene: self, slice: index)
			addChild(forest)
		}
		
		var fetchAllRewards = managedObjectModel?.fetchRequestTemplateForName("FetchAllRewards")
		var error:NSErrorPointer! = NSErrorPointer()
		for item in managedObjectContext?.executeFetchRequest(fetchAllRewards!, error: error) as [DReward]{
			let reward:ForestCreature.CreatureName = ForestCreature.CreatureName(rawValue: Int(item.creatureName))!
			var creature:ForestCreature = ForestCreature.from(reward)
			creature.position = forestPoint(CGPoint(x: CGFloat(item.positionX), y: CGFloat(item.positionY)))
			creature.xScale = CGFloat(fact / Float(item.scale))
			creature.yScale = CGFloat(abs(fact / Float(item.scale)))
			
			addChild(creature)
			characters.append(creature)
		}
	}
	
	public func restart(mass:Float, velocity:Float){
		count = 20
		//var frog = SplashDrop()
		//frog.position = forestPoint(CGPoint(x: CGFloat(1400), y: CGFloat(500)))
		//addChild(frog)
		//frog.physicsBody?.velocity = CGVector(dx: CGFloat(mass), dy: CGFloat(velocity))
		//frog.physicsBody?.mass = CGFloat(mass)
	}
	
	public override func addChild(node: SKNode) {
		super.addChild(node)
		if node is ForestCreature {
			let fc = node as ForestCreature
			fc.didAddToScene()
		}
	}
	
	var CurrentCreature:ForestCreature!
	
	var Scrolling:Bool = true
	
	public func StopScrolling(){
		Scrolling = false
	}
	
	public func StartScrolling(){
		Scrolling = true
	}
	
	public func Mirror(){
		var scale = CurrentCreature.xScale
		scale *= -1
		CurrentCreature.xScale = scale
		CurrentCreature.printGeometry()
	}
	
	public func MoveDown(){
		var p = CurrentCreature.position
		var y = p.y
		y -= 10
		p.y = y
		CurrentCreature.position = p
		CurrentCreature.printGeometry()
	}
	
	public func MoveUp(){
		var p = CurrentCreature.position
		var y = p.y
		y += 10
		p.y = y
		CurrentCreature.position = p
		CurrentCreature.printGeometry()
	}
	
	public func MoveRight(){
		var p = CurrentCreature.position
		var x = p.x
		x += 10
		p.x = x
		CurrentCreature.position = p
		CurrentCreature.printGeometry()
	}
	
	public func MoveLeft(){
		var p = CurrentCreature.position
		var x = p.x
		x -= 10
		p.x = x
		CurrentCreature.position = p
		CurrentCreature.printGeometry()
	}
	
	public func Bigger(){
		var scale = CurrentCreature.xScale
		scale *= 1.1
		CurrentCreature.xScale = scale
		CurrentCreature.yScale = abs(scale)
		CurrentCreature.printGeometry()
	}
	
	public func Smaller(){
		var scale = CurrentCreature.xScale
		scale /= 1.1
		CurrentCreature.xScale = scale
		CurrentCreature.yScale = abs(scale)
		CurrentCreature.printGeometry()
	}
	
	
	public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		
		var touch:UITouch = touches.anyObject() as UITouch
		var location = touch.locationInNode(self)
		var nodes = nodesAtPoint(location)
		var creatureTouched:Bool = false
		for item in nodes{
			if Scrolling{
				if item is Performer{
					var creature:Performer = item as Performer
					creature.perform()
					creatureTouched = true
				}
			}else{
				if item is ForestCreature{
					let fc = item as ForestCreature
					CurrentCreature = fc
				}
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
