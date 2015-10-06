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
	
	
	override public func didMoveToView(view: SKView) {
		_speed = cStartSpeed
		
		let r:CGSize = frame.size
		fact = Float(r.height) / backgroundHeight
        scaledWidth = ForestScene.backgroundWidth() * fact
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
		let height:Float = backgroundHeight*fact;
		
		let scaledx:Float = (Float(p.x)) * fact
		let scaledy:Float = Float(p.y) * fact
				
		return CGPointMake(CGFloat(scaledx + leftHandEdge - tileWidth!/2), CGFloat(scaledy - (height/2)))
	}
	
	public func originalPoint(p:CGPoint) -> CGPoint{
		var width:Float = ForestScene.backgroundWidth()*fact;
		let height:Float = backgroundHeight*fact;
		
		let tileWidth:Float = ForestScene.backgroundWidth()/10 * fact
		
		let x = Float(p.x)
		let y = Float(p.y)
		
		let scaledx = x + tileWidth/2 - leftHandEdge
		let scaledy = y + height/2
		
		var origx = scaledx / fact
		let origy = scaledy / fact
		
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
        //strawb.activateAnimations()
		
		if (Scrolling){
			for item in children {
				let node:SKNode = item 
//                if node is ScrollableProtocol && node is Forest{
                if node.name == "BACK"{
//					var sp = node as! ScrollableProtocol
					let amount:Float  = _speed * Float(_dt)
//					sp.scrollBy(amount)
                    var x:Float = Float(node.position.x)
                    let y:Float = Float(node.position.y)
                    x += amount
                    if amount < 0 && x < -1000 {
                        x += 7093
                    }
                    if amount > 0 && x > 2000 {
                        x -= 7093
                    }
                    node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))

				}
			}
			for item in children {
				let node:SKNode = item 
				if node is ScrollableProtocol && !(node is Forest){
					let sp = node as! ScrollableProtocol
					let amount:Float  = _speed * Float(_dt)
					sp.scrollBy(amount)
				}
				if node is MoveableProtocol && !(node is Forest){
					let mp = node as! MoveableProtocol
					mp.moveBy(Float(_dt))
				}
				if node is SGG_Spine{
					let n = node as! SGG_Spine
					n.activateAnimations()
				}
			}
		}
		//frog.splash(_dt)
		if count > 0{
			let frog = SplashDrop()
			frog.position = self.forestPoint(CGPoint(x: CGFloat(1400), y: CGFloat(500)))
			self.addChild(frog)
			count--
		}
	}
	
	public override func didSimulatePhysics() {
		self.enumerateChildNodesWithName("SPLASH", usingBlock: {
			(node:SKNode, stop:UnsafeMutablePointer <ObjCBool> ) -> Void in
			let bottom = -(self.backgroundHeight*self.fact)/2
			if node.position.y < CGFloat(bottom) {
				node.removeFromParent()
			}
		})
	}
	
    var strawb:SGG_Spine!
    
	func createSceneContents(){
        let uow = UnitOfWork()
        let animations = uow.animationRepository?.getAllAnimation()
        for animation in animations!{
            let name = animation.name
            let skel:SpineSkeleton = DZSpineSceneBuilder.loadSkeletonName(name, scale: 0.1)
            let builder:DZSpineSceneBuilder = DZSpineSceneBuilder()
            let n:SKNode = builder.nodeWithSkeleton(skel, animationName: "waving", loop: true)
            let placeholder:SKNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 100, height: 100))
            //placeholder.position = CGPoint(x: 0,y: 0)
            placeholder.addChild(n)
            placeholder.zPosition = 1000
            self.addChild(placeholder)
        }
        
        leftHandEdge = 0
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 2
        let atlas = SKTextureAtlas(named: "newforest")
        var columnWidth:Int!
        var x:Int = -512
        for column in 1...10{
            let strColumn = formatter.stringFromNumber(column)
            var y:Int = -384
            for var row:Int=3; row>0; row=row-1{
                let strRow = formatter.stringFromNumber(row)
                let name = "background-gc-" + strColumn! + "-" + strRow!
                let texture = atlas.textureNamed(name)
                let size = texture.size()
                columnWidth = Int(size.width)
                // add the texture node at x,y
                let n = SKSpriteNode(texture: texture)
                let posx:Int = x + columnWidth/2
                let posy:Int = y + Int(size.height)/2
                n.position = CGPoint(x: posx,y: posy)
                n.name = "BACK"
                addChild(n)
                y += Int(size.height)
            }
            x += columnWidth
        }
        
		for item in (uow.rewardRepository?.getAllRewards())!{
			let reward:ForestCreature.CreatureName = ForestCreature.CreatureName(rawValue: Int(item.creatureName))!
			let creature:ForestCreature = ForestCreature.from(reward)
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
			let fc = node as! ForestCreature
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

	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch:UITouch = touches.first! 
		
		let location = touch.locationInNode(self)
		let nodes = nodesAtPoint(location)
		var creatureTouched:Bool = false
		for item in nodes{
			if Scrolling{
				if item is Performer{
					let creature:Performer = item as! Performer
					creature.perform()
					creatureTouched = true
				}
			}else{
				if item is ForestCreature{
					let fc = item as! ForestCreature
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
