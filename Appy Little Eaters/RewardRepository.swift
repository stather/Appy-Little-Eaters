//
//  RewardRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 06/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData


public class RewardRepository{
    private var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()
    
    func createNewReward() -> DReward!{
        return NSEntityDescription.insertNewObjectForEntityForName("DReward", inManagedObjectContext: self._managedObjectContext) as! DReward
    }
    
    func getAllRewards() ->[DReward]{
        let fetchAllRewards = managedObjectModel?.fetchRequestTemplateForName("FetchAllRewards")
        return (try! _managedObjectContext.executeFetchRequest(fetchAllRewards!)) as! [DReward]
        
    }
    
    func deleteReward(reward: DReward){
        _managedObjectContext.deleteObject(reward)
    }

    func deleteAllRewards(){
        let allRewards = getAllRewards()
        for item in allRewards{
            deleteReward(item)
        }
    }
    
    func findByName(name:String) -> DReward!{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplateWithName("FetchRewardByName", substitutionVariables: ["NAME":name])
        let rewards = try! _managedObjectContext.executeFetchRequest(fetchByName!) as! [DReward]
        return rewards[0]
    }
    
    func count() -> Int{
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("DReward", inManagedObjectContext: _managedObjectContext)
        let c = _managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
        return c
    }


}