//
//  FoodRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 03/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

public class FoodRepository{
    private var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }

    func createNewFood() -> DFood!{
        return NSEntityDescription.insertNewObjectForEntityForName("DFood", inManagedObjectContext: self._managedObjectContext) as! DFood
    }
    
    func getAllFood() -> [DFood!]!{
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("DFood", inManagedObjectContext: _managedObjectContext)
        //fetchRequest.includesPropertyValues = false
        
        let results:[DFood!]! = try? _managedObjectContext.executeFetchRequest(fetchRequest) as! [DFood!]
        return results
    }
    
    func deleteFood(food: DFood){
        _managedObjectContext.deleteObject(food)
    }
    
}