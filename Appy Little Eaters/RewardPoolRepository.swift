//
//  RewardPoolRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 06/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData


public class RewardPoolRepository{
    private var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()

    
    func createNewRewardPool() -> DRewardPool!{
        return NSEntityDescription.insertNewObjectForEntityForName("DRewardPool", inManagedObjectContext: self._managedObjectContext) as! DRewardPool
    }
    
    func getAllRewardsInPool() -> [DRewardPool!]!{
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("DRewardPool", inManagedObjectContext: _managedObjectContext)
        
        let results:[DRewardPool!]! = try? _managedObjectContext.executeFetchRequest(fetchRequest) as! [DRewardPool!]
        return results
    }
    
    func getAllRewardsInPool(forScene:String) -> [DRewardPool!]{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplateWithName("FetchRewardPoolByScene", substitutionVariables: ["SCENE":forScene])
        let rewards = try! _managedObjectContext.executeFetchRequest(fetchByName!) as! [DRewardPool]
        return rewards
    }
    
    func deleteReward(reward:DRewardPool){
        _managedObjectContext.deleteObject(reward)
    }
    

    
    func getAvailableRewardsOrderedByLevel(forScene:String) -> [DRewardPool]{
        let fetchRequest: NSFetchRequest = managedObjectModel?.fetchRequestFromTemplateWithName("FetchAvailableRewards", substitutionVariables: ["SCENE":forScene])?.copy() as! NSFetchRequest
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
        return (try! _managedObjectContext.executeFetchRequest(fetchRequest)) as! [DRewardPool]
    }
    
    func makeAllRewardsAvailable(){
        let allRewardsInPool = getAllRewardsInPool()
        for item in allRewardsInPool!{
            item.available = true
        }
    }
    
    func findByName(name:String) -> DRewardPool!{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplateWithName("FetchRewardPoolByName", substitutionVariables: ["NAME":name])
        let rewards = try! _managedObjectContext.executeFetchRequest(fetchByName!) as! [DRewardPool]
        return rewards[0]
    }

    
}