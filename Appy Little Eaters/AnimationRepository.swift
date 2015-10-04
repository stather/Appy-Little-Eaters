//
//  AnimationRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 04/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

public class AnimationRepository{
    private var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    func createNewAnimation() -> DAnimation!{
        return NSEntityDescription.insertNewObjectForEntityForName("DAnimation", inManagedObjectContext: self._managedObjectContext) as! DAnimation
    }
    
    func getAllAnimation() -> [DAnimation!]!{
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("DAnimation", inManagedObjectContext: _managedObjectContext)
        //fetchRequest.includesPropertyValues = false
        
        let results:[DAnimation!]! = try? _managedObjectContext.executeFetchRequest(fetchRequest) as! [DAnimation!]
        return results
    }
    
    func deleteAnimation(food: DAnimation){
        _managedObjectContext.deleteObject(food)
    }
    
}