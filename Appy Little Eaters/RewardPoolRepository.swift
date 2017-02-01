//
//  RewardPoolRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 06/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData


open class RewardPoolRepository{
    fileprivate var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()

    
    func createNewRewardPool() -> DRewardPool!{
        return NSEntityDescription.insertNewObject(forEntityName: "DRewardPool", into: self._managedObjectContext) as! DRewardPool
    }
    
    func getAllRewardsInPool() -> [DRewardPool?]!{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "DRewardPool", in: _managedObjectContext)
        
        let results:[DRewardPool?]! = try? _managedObjectContext.fetch(fetchRequest) as! [DRewardPool?]
        return results
    }
    
    func getAllRewardsInPool(_ forScene:String) -> [DRewardPool?]{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchRewardPoolByScene", substitutionVariables: ["SCENE":forScene])
        let rewards = try! _managedObjectContext.fetch(fetchByName!) as! [DRewardPool]
        return rewards
    }
    
    func deleteReward(_ reward:DRewardPool){
        _managedObjectContext.delete(reward)
    }
    

    
    func getAvailableRewardsOrderedByLevel(_ forScene:String) -> [DRewardPool]{
        let fetchRequest1 = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchAvailableRewards", substitutionVariables: ["SCENE":forScene])
        
//        let fetchRequest = fetchRequest1?.copy() as NSFetchRequest
//            ?.copy() as! NSFetchRequest
        fetchRequest1?.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
        return (try! _managedObjectContext.fetch(fetchRequest1!)) as! [DRewardPool]
    }
    
    func makeAllRewardsAvailable(){
        let allRewardsInPool = getAllRewardsInPool()
        for item in allRewardsInPool!{
            item?.available = true
        }
    }
    
    func findByName(_ name:String) -> DRewardPool!{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchRewardPoolByName", substitutionVariables: ["NAME":name])
        let rewards = try! _managedObjectContext.fetch(fetchByName!) as! [DRewardPool]
        return rewards[0]
    }
    
    func count() -> Int{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "DRewardPool", in: _managedObjectContext)
        let c = try! _managedObjectContext.count(for: fetchRequest)
        return c
    }

    
}
