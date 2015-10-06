//
//  UnitOfWork.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 04/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

public class UnitOfWork{
    
    public init(){
    }
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    
    lazy var foodRepository : FoodRepository? = {
        var foodRepository = FoodRepository(managedObjectContext: self.managedObjectContext!)
        return foodRepository
        }()

    lazy var animationRepository : AnimationRepository? = {
        var animationRepository = AnimationRepository(managedObjectContext: self.managedObjectContext!)
        return animationRepository
        }()

    lazy var rewardPoolRepository : RewardPoolRepository? = {
        var rewardPoolRepository = RewardPoolRepository(managedObjectContext: self.managedObjectContext!)
        return rewardPoolRepository
        }()

    lazy var rewardRepository : RewardRepository? = {
        var rewardRepository = RewardRepository(managedObjectContext: self.managedObjectContext!)
        return rewardRepository
        }()
    
    
    public func saveChanges(){
        do {
            try managedObjectContext!.save()
        }catch{
            
        }
    }
    
}


