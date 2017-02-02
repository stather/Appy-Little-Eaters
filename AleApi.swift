//
//  AleApi.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 13/09/2015.
//  Copyright (c) 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

open class AleFoodDef{
    open var name:String!
    open var thumb:String!
    open var image:String!
    open var sound:String!
    open var free:Bool!
    open var colour:String!
    open var version:Int!
}

open class AleAnimationDef{
    open var atlas:String!
    open var texture:String!
    open var json:String!
    open var name:String!
    open var rewardImage:String!
    open var version:Int!
}

open class AleRewardDef{
    open var name:String!
    open var scene:String!
    open var animation:String!
    open var level:String!
    open var x:Float!
    open var y:Float!
    open var scale:Float!
}

open class AleApi{
    
//    static let BaseUrl = "http://localhost:8079/"
    static let BaseUrl = "http://rsrapi-dev2.elasticbeanstalk.com/"
    
    func addUser(_ name:String) -> Void {
//        let FullUrl = AleApi.BaseUrl + "User/addUser"
//        let params:NSMutableDictionary = NSMutableDictionary(objects: [name], forKeys: ["email" as NSCopying])
//        params.setValue("12345", forKey: "XDEBUG_SESSION_START")
        

//        ANRestOps.post(inBackgroundForm: FullUrl, payload: params as [NSObject: AnyObject], beforeRequest: { () -> Void in
            
//            }, onCompletion: {(response: ANRestOpsResponse!) -> Void in
//        })
    }
    
    func updateRewardPosition(_ name:String, x:Float, y:Float, scale:Float) -> Void{
        
        let FullUrl = AleApi.BaseUrl + "Reward/updateRewardPosition"
        var request = URLRequest(url:   URL(string: FullUrl)!)
        request.httpMethod = "POST"
        
        let params:NSMutableDictionary = NSMutableDictionary(objects: [name, String(x), String(y), String(scale)], forKeys: ["name" as NSCopying, "x" as NSCopying, "y" as NSCopying, "scale" as NSCopying])
        
        let j = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        request.httpBody = j
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) -> Void in
            guard let data = data, let error = error else{
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                return
            }
            
            let responseString = String(data:data, encoding:.utf8)
            
        }
        task.resume()
        
        
    }
    
    func parseJSON(inputData:Data) -> NSDictionary{
        let dictData = (try! JSONSerialization.jsonObject(with: inputData as Data, options:.mutableContainers)) as! NSDictionary
        return dictData
    }
    
    func parseJSONArray(inputData:Data) -> NSArray{
        let dictData = (try! JSONSerialization.jsonObject(with: inputData as Data, options:.mutableContainers)) as! NSArray
        return dictData
    }
    
    func getJSON(urlToRequest:String) -> Data{
        let u = URL(string: urlToRequest)
        return try! Data(contentsOf: (u?.absoluteURL)!)
    }
    
    func listFood() -> [AleFoodDef]{
        let j = getJSON(urlToRequest: "http://rsrapi-dev2.elasticbeanstalk.com/Food/listFoodJson")
        let p = parseJSONArray(inputData: j)
        var foods = [AleFoodDef]()
        for item in p{
            let afd = AleFoodDef()
            let d = item as! NSDictionary
            afd.name = d.object(forKey: "name") as! String
            afd.thumb = d.object(forKey: "thumb") as! String
            afd.image = d.object(forKey: "image") as! String
            afd.sound = d.object(forKey: "sound") as! String
            afd.free = d.object(forKey: "free") as! Bool
            afd.colour = d.object(forKey: "colour") as! String
            afd.version = d.object(forKey: "version") as! Int
            foods.append(afd)
        }
        return foods
    }
    
    func listAnimations() -> [AleAnimationDef]{
        let j = getJSON(urlToRequest: "http://rsrapi-dev2.elasticbeanstalk.com/Animation/listAnimationsJson")
        let p = parseJSONArray(inputData: j)
        var animations = [AleAnimationDef]()
        for item in p{
            let aad = AleAnimationDef()
            let d = item as! NSDictionary
            aad.atlas = d.object(forKey: "atlas") as! String
            aad.texture = d.object(forKey: "texture") as! String
            aad.json = d.object(forKey: "json") as! String
            aad.name = d.object(forKey: "name") as! String
            aad.rewardImage = d.object(forKey: "rewardImage") as! String
            aad.version = d.object(forKey: "version") as! Int
            animations.append(aad)
        }
        return animations
    }

    
    func listRewards() -> [AleRewardDef]{
        let j = getJSON(urlToRequest: "http://rsrapi-dev2.elasticbeanstalk.com/Reward/listRewardsJson")
        let p = parseJSONArray(inputData: j)
        var rewards = [AleRewardDef]()
        for item in p {
            let aad = AleRewardDef()
            let d = item as! NSDictionary
            aad.name = d.object(forKey: "name") as! String
            aad.scene = d.object(forKey: "scene") as! String
            aad.animation = d.object(forKey: "animation") as! String
            aad.level = d.object(forKey: "level") as! String
            aad.x = d.object(forKey: "x") as! Float
            aad.y = d.object(forKey: "y") as! Float
            aad.scale = d.object(forKey: "scale") as! Float
            rewards.append(aad)
        }
        return rewards

    }

}
