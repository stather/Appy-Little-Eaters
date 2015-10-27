//
//  AnimatedSprite.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 17/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import SpriteKit

public class AnimatedSprite: SKSpriteNode, ScrollableProtocol {
    public var animationName:String!
    public var rewardName:String!
    
    convenience init(withAnimationName:String, rewardName:String){
        self.init(color: UIColor.clearColor(), size: CGSize(width: 100, height: 100))
        self.animationName = withAnimationName
        self.rewardName = rewardName
        let skel:SpineSkeleton? = DZSpineSceneBuilder.loadSkeletonName(withAnimationName, scale: 0.1)
        let builder:DZSpineSceneBuilder = DZSpineSceneBuilder()
        let n:SKNode = builder.nodeWithSkeleton(skel, animationName: "Jump", loop: true)
        self.addChild(n)
        self.zPosition = 1000
    }

    var delegate:ScrollableProtocol?

    lazy var forestScene:ForestScene = {
        return self.scene as! ForestScene
        }()

    public func printGeometry(){
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
    
    func scrollBy(amount: Float) {
        delegate?.scrollBy(amount)
    }
    
    func didAddToScene(){
        delegate = StandardScroller(howMuch:forestScene.fact * forestScene.backgroundWidth / 10,  node: self)
    }

    
}
