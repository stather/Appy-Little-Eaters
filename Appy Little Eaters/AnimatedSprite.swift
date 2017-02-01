//
//  AnimatedSprite.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 17/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import SpriteKit

open class AnimatedSprite: SKSpriteNode, ScrollableProtocol {
    open var animationName:String!
    open var rewardName:String!
    fileprivate var skeleton:SpineSkeleton!
    
    convenience init(withSkeletonName:String, rewardName:String, withAnimationName:String){
        self.init(color: UIColor.clear, size: CGSize(width: 100, height: 100))
        self.animationName = withSkeletonName
        self.rewardName = rewardName
        self.skeleton = DZSpineSceneBuilder.loadSkeletonName(withSkeletonName, scale: 0.1)
        let n:SKNode = CreateLoopingNode(withAnimationName: withAnimationName)
        self.addChild(n)
        self.zPosition = 1000
    }
    
    fileprivate func CreateLoopingNode(withAnimationName:String) -> SKNode{
        let builder:DZSpineSceneBuilder = DZSpineSceneBuilder()
        return builder.node(with: skeleton, animationName: withAnimationName, loop: true)
    }

    var delegate:ScrollableProtocol?

    lazy var forestScene:ForestScene = {
        return self.scene as! ForestScene
        }()

    open func printGeometry(){
        return
        let p = forestScene.originalPoint(position)
        print("x ", terminator: "")
        if p.x < 0{
            print(p.x + 9000, terminator: "")
        }
        else{
            print(p.x, terminator: "")
        }
        print(" y ", terminator: "")
        print(1035 - p.y, terminator: "")
        print(" scale ", terminator: "")
        let s = forestScene.fact / Float(xScale)
        print(s, terminator: "")
        print("")
    }
    
    func scrollBy(_ amount: Float) {
        delegate?.scrollBy(amount)
    }
    
    func didAddToScene(){
        delegate = StandardScroller(howMuch:forestScene.fact * forestScene.backgroundWidth / 10,  node: self)
    }

    
}
