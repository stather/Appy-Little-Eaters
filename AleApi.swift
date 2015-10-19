//
//  AleApi.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 13/09/2015.
//  Copyright (c) 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

public class AleFoodDef{
    public var name:String!
    public var thumb:String!
    public var image:String!
    public var sound:String!
    public var free:Bool!
    public var colour:String!
}

public class AleAnimationDef{
    public var atlas:String!
    public var texture:String!
    public var json:String!
    public var name:String!
    public var rewardImage:String!
}

public class AleRewardDef{
    public var name:String!
    public var scene:String!
    public var animation:String!
    public var level:String!
}

public class AleApi{
    
    static let BaseUrl = "http://localhost:8079/"
    
    func listFood(success:(foods: [AleFoodDef]) -> Void){
        let FullUrl = AleApi.BaseUrl + "Food/listFoodJson"
        ANRestOps.getInBackground(FullUrl, beforeRequest: { () -> Void in
            
            }, onCompletion: {(response: ANRestOpsResponse!) -> Void in
                if response.statusCode() != 200{
                    return;
                }
                let r = response.dataAsArray()
                var foods = [AleFoodDef]()
                for item in r{
                    let afd = AleFoodDef()
                    afd.name = item.objectForKey("name") as! String
                    afd.thumb = item.objectForKey("thumb") as! String
                    afd.image = item.objectForKey("image") as! String
                    afd.sound = item.objectForKey("sound") as! String
                    afd.free = item.objectForKey("free") as! Bool
                    afd.colour = item.objectForKey("colour") as! String
                    foods.append(afd)
                }
                success(foods: foods)
        })
    }
    
    func listAnimations(success:(animations: [AleAnimationDef]) -> Void){
        let fullUrl = AleApi.BaseUrl + "Animation/listAnimationsJson"
        let params:NSDictionary = NSDictionary(objects: ["obj"], forKeys: ["key"])
        ANRestOps.getInBackground(fullUrl, parameters: params as [NSObject : AnyObject], beforeRequest: { () -> Void in
            
            }, onCompletion: {(response: ANRestOpsResponse!) -> Void in
                if response.statusCode() != 200{
                    return;
                }
                let resp = response.dataAsArray()
                var animations = [AleAnimationDef]()
                for item in resp{
                    let aad = AleAnimationDef()
                    aad.atlas = item.objectForKey("atlas") as! String
                    aad.texture = item.objectForKey("texture") as! String
                    aad.json = item.objectForKey("json") as! String
                    aad.name = item.objectForKey("name") as! String
                    aad.rewardImage = item.objectForKey("rewardImage") as! String
                    animations.append(aad)
                }
                success(animations: animations)
        });
        
    }
    
    func listRewardss(success:(rewards: [AleRewardDef]) -> Void){
        let fullUrl = AleApi.BaseUrl + "Reward/listRewardsJson"
        let params:NSDictionary = NSDictionary(objects: ["obj"], forKeys: ["key"])
        ANRestOps.getInBackground(fullUrl, parameters: params as [NSObject : AnyObject], beforeRequest: { () -> Void in
            
            }, onCompletion: {(response: ANRestOpsResponse!) -> Void in
                if response.statusCode() != 200{
                    return;
                }
                let resp = response.dataAsArray()
                var rewards = [AleRewardDef]()
                for item in resp{
                    let aad = AleRewardDef()
                    aad.name = item.objectForKey("name") as! String
                    aad.scene = item.objectForKey("scene") as! String
                    aad.animation = item.objectForKey("animation") as! String
                    aad.level = item.objectForKey("level") as! String
                    rewards.append(aad)
                }
                success(rewards: rewards)
        });
        
    }
   
}
