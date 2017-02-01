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

open class ForestScene : SKScene{
	var contentCreated:Bool = false
	
    var backgroundWidth:Float = 0
	
	open let backgroundHeight:Float = 768
	open var scaledWidth:Float!
	open var fact:Float!
	var count:Int = 0
	
	var _lastUpdateTime:TimeInterval!
	var _dt:TimeInterval!
	let cStartSpeed:Float = 15
	let cMaxSpeed:Float = 80
	
	open var leftHandEdge:Float!
    open var edgeOffest:Float!
	
	var _speed:Float!
    static var debugRewardCounter = 0
    
    open var AnimateCreatures = true
		
	
	override open func didMove(to view: SKView) {
		_speed = cStartSpeed
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true
        alpha = 1
        //backgroundColor = SKColor.blueColor()
        backgroundColor = SKColor.clear
        scaleMode = SKSceneScaleMode.fill
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
    
    open func forestPoint(_ p:CGPoint) -> CGPoint{
        var x = Float(p.x) + leftHandEdge;
        if x < -1000 {
            x += backgroundWidth
        }
        if x > 2000 {
            x -= backgroundWidth
        }

        return CGPoint(x: CGFloat(x), y: CGFloat(p.y))
    }
    
    open func originalPoint(_ p:CGPoint) -> CGPoint{
        
        var x = Float(p.x) - leftHandEdge
        
        if x < 0 {
            x += backgroundWidth
        }
        
        if x > backgroundWidth{
            x -= backgroundWidth
        }
        
        return CGPoint(x: CGFloat(x), y: CGFloat(p.y))
        
    }
	
	open override func update(_ currentTime: TimeInterval) {
		if ((_lastUpdateTime) != nil) {
			_dt = currentTime - _lastUpdateTime;
		} else {
			_dt = 0;
		}
		_lastUpdateTime = currentTime;
		
		// Scroll
		
		if (Scrolling){
            var amount:Int  = Int(_speed * Float(_dt))
            if amount == 0{
                if _speed < 0 {
                    amount = -1;
                }else{
                    amount = 1;
                }
            }
			for item in children {
				let node:SKNode = item 
                var x:Int = Int(node.position.x)
                let y:Int = Int(node.position.y)
                x += amount
                if amount < 0 && x < -1000 {
                    x += Int(backgroundWidth)
                }
                if amount > 0 && x > 2000 {
                    x -= Int(backgroundWidth)
                }
                node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
                if node.name == "BACK"{
                    let bn = node as! BackgroundSpriteNode
                    if (bn.IsKey){
                        leftHandEdge = Float(bn.position.x) - edgeOffest
                    }
				}
			}
//			for item in children {
//				let node:SKNode = item 
//				if !(node is Forest){
//                    var x:Int = Int(node.position.x)
//                    let y:Int = Int(node.position.y)
//                    x += amount
//                    if amount < 0 && x < -1000 {
//                        x += Int(backgroundWidth)
//                    }
//                    if amount > 0 && x > 2000 {
//                        x -= Int(backgroundWidth)
//                    }
//                    node.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
//				}
//				if node is MoveableProtocol && !(node is Forest){
//					let mp = node as! MoveableProtocol
//					mp.moveBy(Float(_dt))
//				}
//			}
		}
	}
	
	open override func didSimulatePhysics() {
		self.enumerateChildNodes(withName: "SPLASH", using: {
			(node:SKNode, stop:UnsafeMutablePointer <ObjCBool> ) -> Void in
			let bottom = -(self.backgroundHeight*self.fact)/2
			if node.position.y < CGFloat(bottom) {
				node.removeFromParent()
			}
		})
	}
	
    var strawb:SGG_Spine!
    
    func createBackground(){
        let back = UserDefaults.standard.integer(forKey: "backgroundId")
        switch (back){
        case 0:
            createForestBackground()
            break
        case 1:
            createPlanetBackground()
            break
        default:
            createForestBackground()
        }
        
    }

    func createPlanetBackground(){
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        let atlas = SKTextureAtlas(named: "planet")
        var columnWidth:Int!
        var x:Int = -512
        backgroundWidth = 0
        var isKey = true
        for column in 1...10{
            let strColumn = formatter.string(from: NSNumber(value:column))
            var y:Int = -384
            let rows = [3,2,1]
            for row in rows{
                let strRow = formatter.string(from: NSNumber(value:row))
                let name = "Space-Rewards-Background-" + strColumn! + "-" + strRow! + ".png"
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
    
    
    func createForestBackground(){
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        let atlas = SKTextureAtlas(named: "newforest")
        var columnWidth:Int!
        var x:Int = -512
        backgroundWidth = 0
        var isKey = true
        for column in 1...10{
            let strColumn = formatter.string(from: NSNumber(value:column))
            var y:Int = -384
            let rows = [3,2,1]
            for row in rows{
                let strRow = formatter.string(from: NSNumber(value:row))
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
        var counter = 0
        
		for item in (uow.rewardRepository?.getAllRewards())!{
            if true || counter == ForestScene.debugRewardCounter {
                ForestScene.debugRewardCounter += 1
                let skeletonName = item.animationName
                print("################ Animation:" + skeletonName!)
                if skeletonName == "...RocketAnimation"{
                    counter += 1
                    continue
                }
                let rewardName = item.rewardName
                var animationName = "Random1"
                if !AnimateCreatures{
                    animationName = ""
                }
                let anim = AnimatedSprite(withSkeletonName: skeletonName!, rewardName: rewardName!, withAnimationName: animationName)
                let op = CGPoint(x: Double(item.positionX!), y: Double(item.positionY!))
                let fp = forestPoint(op)
                anim.position = fp
                anim.xScale = CGFloat(item.scale!)
                anim.yScale = abs(CGFloat(item.scale!))
                addChild(anim)
                if false{
                    return
                }
            }
            counter += 1
		}
	}
	
	open func restart(_ mass:Float, velocity:Float){
		count = 20
		//var frog = SplashDrop()
		//frog.position = forestPoint(CGPoint(x: CGFloat(1400), y: CGFloat(500)))
		//addChild(frog)
		//frog.physicsBody?.velocity = CGVector(dx: CGFloat(mass), dy: CGFloat(velocity))
		//frog.physicsBody?.mass = CGFloat(mass)
	}
	
	open override func addChild(_ node: SKNode) {
		super.addChild(node)
        if node is AnimatedSprite{
            let an = node as! AnimatedSprite
            an.didAddToScene()
        }
	}
	
	var CurrentCreature:AnimatedSprite!
	
	var Scrolling:Bool = true
	
	open func StopScrolling(){
		Scrolling = false
	}
	
	open func StartScrolling(){
		Scrolling = true
	}
	
	open func Mirror(){
		var scale = CurrentCreature.xScale
		scale *= -1
		CurrentCreature.xScale = scale
		CurrentCreature.printGeometry()
	}
	
	open func MoveDown(){
		var p = CurrentCreature.position
		var y = p.y
		y -= 10
		p.y = y
		CurrentCreature.position = p
		CurrentCreature.printGeometry()
	}
	
	open func MoveUp(){
		var p = CurrentCreature.position
		var y = p.y
		y += 10
		p.y = y
		CurrentCreature.position = p
		CurrentCreature.printGeometry()
	}
	
    open func MoveRight(){
        var p = CurrentCreature.position
        var x = p.x
        x += 10
        p.x = x
        CurrentCreature.position = p
        CurrentCreature.printGeometry()
    }
    
    open func MoveLeft(){
        var p = CurrentCreature.position
        var x = p.x
        x -= 10
        p.x = x
        CurrentCreature.position = p
        CurrentCreature.printGeometry()
    }
    
    open func MoveRightLots(){
        var p = CurrentCreature.position
        var x = p.x
        x += 500
        p.x = x
        CurrentCreature.position = p
        CurrentCreature.printGeometry()
    }
    
    open func MoveLeftLots(){
        var p = CurrentCreature.position
        var x = p.x
        x -= 500
        p.x = x
        CurrentCreature.position = p
        CurrentCreature.printGeometry()
    }
	
	open func Bigger(){
		var scale = abs(CurrentCreature.xScale)
		scale *= 1.1
        CurrentCreature.xScale = CurrentCreature.xScale < 0 ? -scale : scale
		CurrentCreature.yScale = abs(scale)
		CurrentCreature.printGeometry()
	}
	
	open func Smaller(){
		var scale = abs(CurrentCreature.xScale)
		scale /= 1.1
        CurrentCreature.xScale = CurrentCreature.xScale < 0 ? -scale : scale
		CurrentCreature.yScale = abs(scale)
		CurrentCreature.printGeometry()
	}
    
    open func done(){
        let api = AleApi()
        let op = originalPoint(CurrentCreature.position)
        api.updateRewardPosition(CurrentCreature.rewardName, x:Float(op.x), y: Float(op.y), scale: Float(CurrentCreature.xScale))
        let uow = UnitOfWork()
        let reward = uow.rewardRepository?.findByName(CurrentCreature.rewardName)
        reward?.positionX = op.x as NSNumber?
        reward?.positionY = op.y as NSNumber?
        reward?.scale = CurrentCreature.xScale as NSNumber?
        let rewardPool = uow.rewardPoolRepository?.findByName(CurrentCreature.rewardName)
        rewardPool?.positionX = op.x as NSNumber?
        rewardPool?.positionY = op.y as NSNumber?
        rewardPool?.scale = CurrentCreature.xScale as NSNumber?
        uow.saveChanges()
        CurrentCreature.color = UIColor.clear
        CurrentCreature = nil
    }

	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch:UITouch = touches.first! 
		
		let location = touch.location(in: self)
		let nodes = self.nodes(at: location)
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
                        CurrentCreature.color = UIColor.clear
                    }
					CurrentCreature = fc
                    CurrentCreature.color = UIColor.blue
				}
			}
		}
        if !creatureTouched{
            if CurrentCreature != nil{
                CurrentCreature.color = UIColor.clear
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
