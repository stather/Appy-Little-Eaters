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
	
    var backgroundWidth:Float = 0
	
	public let backgroundHeight:Float = 768
	public var scaledWidth:Float!
	public var fact:Float!
	var count:Int = 0
	
	var _lastUpdateTime:NSTimeInterval!
	var _dt:NSTimeInterval!
	let cStartSpeed:Float = 5
	let cMaxSpeed:Float = 80
	
	public var leftHandEdge:Float!
    public var edgeOffest:Float!
	
	var _speed:Float!
		
	
	override public func didMoveToView(view: SKView) {
		_speed = cStartSpeed
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        userInteractionEnabled = true
        alpha = 1
        backgroundColor = SKColor.blueColor()
        scaleMode = SKSceneScaleMode.Fill
        if (!self.contentCreated)
        {
            createBackground()
        }
		let r:CGSize = frame.size
		fact = Float(r.height) / backgroundHeight
        scaledWidth = backgroundWidth * fact
		if (!self.contentCreated)
		{
			createSceneContents()
			contentCreated = true
		}
	}
	
//    public func forestPoint(p:CGPoint) -> CGPoint{
//        
//        var width:Float = backgroundWidth*fact;
//        let height:Float = backgroundHeight*fact;
//        
//        let scaledx:Float = (Float(p.x)) * fact
//        let scaledy:Float = Float(p.y) * fact
//        let tileWidth:Float = backgroundWidth/10 * fact
//        
//        return CGPointMake(CGFloat(scaledx + leftHandEdge + 512), CGFloat(scaledy - (height/2)))
//    }
//    
//    public func originalPoint(p:CGPoint) -> CGPoint{
//        var width:Float = backgroundWidth*fact;
//        let height:Float = backgroundHeight*fact;
//        
//        let tileWidth:Float = backgroundWidth/10 * fact
//        
//        let x = Float(p.x)
//        let y = Float(p.y)
//        
//        let scaledx = x - 512 - leftHandEdge
//        let scaledy = y + height/2
//        
//        var origx = scaledx / fact
//        let origy = scaledy / fact
//        
//        if origx < 0 {
//            origx += backgroundWidth
//        }
//        
//        return CGPoint(x: CGFloat(origx), y: CGFloat(origy))
//        
//    }
    
    public func forestPoint(p:CGPoint) -> CGPoint{
        var x = Float(p.x) + leftHandEdge;
        if x < -1000 {
            x += backgroundWidth
        }
        if x > 2000 {
            x -= backgroundWidth
        }

        return CGPointMake(CGFloat(x), CGFloat(p.y))
    }
    
    public func originalPoint(p:CGPoint) -> CGPoint{
        
        var x = Float(p.x) - leftHandEdge
        
        if x < 0 {
            x += backgroundWidth
        }
        
        if x > backgroundWidth{
            x -= backgroundWidth
        }
        
        return CGPoint(x: CGFloat(x), y: CGFloat(p.y))
        
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
				let node:SKNode = item 
                if node.name == "BACK"{
					let amount:Float  = _speed * Float(_dt)
                    var x:Float = Float(node.position.x)
                    let y:Float = Float(node.position.y)
                    x += amount
                    if amount < 0 && x < -1000 {
                        x += backgroundWidth
                    }
                    if amount > 0 && x > 2000 {
                        x -= backgroundWidth
                    }
                    node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    let bn = node as! BackgroundSpriteNode
                    if (bn.IsKey){
                        leftHandEdge = Float(bn.position.x) - edgeOffest
                    }
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
    
    func createBackground(){
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 2
        let atlas = SKTextureAtlas(named: "newforest")
        var columnWidth:Int!
        var x:Int = -512
        backgroundWidth = 0
        var isKey = true
        for column in 1...10{
            let strColumn = formatter.stringFromNumber(column)
            var y:Int = -384
            for var row:Int=3; row>0; row=row-1{
                let strRow = formatter.stringFromNumber(row)
                let name = "background-gc-" + strColumn! + "-" + strRow!
                let texture = atlas.textureNamed(name)
                let size = texture.size()
                columnWidth = Int(size.width)
                if row == 3 {
                    backgroundWidth += Float(columnWidth)
                }
                // add the texture node at x,y
                let n = BackgroundSpriteNode(texture: texture)
                let posx:Int = x + columnWidth/2
                if isKey {
                    leftHandEdge = Float(-512)
                    edgeOffest = Float(columnWidth)/2
                }
                let posy:Int = y + Int(size.height)/2
                n.position = CGPoint(x: posx,y: posy)
                n.name = "BACK"
                n.IsKey = isKey
                isKey = false
                addChild(n)
                y += Int(size.height)
            }
            x += columnWidth
        }
    }
    
	func createSceneContents(){
        let uow = UnitOfWork()
        
		for item in (uow.rewardRepository?.getAllRewards())!{
            let animationName = item.animationName
            let rewardName = item.rewardName
            let anim = AnimatedSprite(withAnimationName: animationName!, rewardName: rewardName!)
            let op = CGPoint(x: Double(item.positionX!), y: Double(item.positionY!))
            let fp = forestPoint(op)
            anim.position = fp
            anim.xScale = CGFloat(item.scale!)
            anim.yScale = CGFloat(item.scale!)
			addChild(anim)
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
        if node is AnimatedSprite{
            let an = node as! AnimatedSprite
            an.didAddToScene()
        }
	}
	
	var CurrentCreature:AnimatedSprite!
	
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
    
    public func done(){
        let api = AleApi()
        let op = originalPoint(CurrentCreature.position)
        api.updateRewardPosition(CurrentCreature.rewardName, x:Float(op.x), y: Float(op.y), scale: Float(CurrentCreature.xScale))
        let uow = UnitOfWork()
        let reward = uow.rewardRepository?.findByName(CurrentCreature.rewardName)
        reward?.positionX = op.x
        reward?.positionY = op.y
        reward?.scale = CurrentCreature.xScale
        let rewardPool = uow.rewardPoolRepository?.findByName(CurrentCreature.rewardName)
        rewardPool?.positionX = op.x
        rewardPool?.positionY = op.y
        rewardPool?.scale = CurrentCreature.xScale
        uow.saveChanges()
        CurrentCreature.color = UIColor.clearColor()
        CurrentCreature = nil
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
				if item is AnimatedSprite{
                    creatureTouched = true
					let fc = item as! AnimatedSprite
                    if CurrentCreature != nil{
                        CurrentCreature.color = UIColor.clearColor()
                    }
					CurrentCreature = fc
                    CurrentCreature.color = UIColor.blueColor()
				}
			}
		}
        if !creatureTouched{
            if CurrentCreature != nil{
                CurrentCreature.color = UIColor.clearColor()
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
