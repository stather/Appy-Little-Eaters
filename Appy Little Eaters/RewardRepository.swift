//
//  RewardRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 06/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData


open class RewardRepository{
    fileprivate var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()
    
    func createNewReward() -> DReward!{
        return NSEntityDescription.insertNewObject(forEntityName: "DReward", into: self._managedObjectContext) as! DReward
    }
    
    func getAllRewards() ->[DReward]{
        let fetchAllRewards = managedObjectModel?.fetchRequestTemplate(forName: "FetchAllRewards")
        return (try! _managedObjectContext.fetch(fetchAllRewards!)) as! [DReward]
        
    }
    
    func deleteReward(_ reward: DReward){
        _managedObjectContext.delete(reward)
    }

    func deleteAllRewards(){
        let allRewards = getAllRewards()
        for item in allRewards{
            deleteReward(item)
        }
    }
    
    func findByName(_ name:String) -> DReward!{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchRewardByName", substitutionVariables: ["NAME":name])
        let rewards = try! _managedObjectContext.fetch(fetchByName!) as! [DReward]
        return rewards[0]
    }
    
    func count() -> Int{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "DReward", in: _managedObjectContext)
        let c = try! _managedObjectContext.count(for: fetchRequest)
        return c
    }


}
