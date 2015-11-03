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
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectModel
    }()

    func createNewFood() -> DFood!{
        return NSEntityDescription.insertNewObjectForEntityForName("DFood", inManagedObjectContext: self._managedObjectContext) as! DFood
    }
    
    func getAllFood() -> [DFood!]!{
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("DFood", inManagedObjectContext: _managedObjectContext)
        let results:[DFood!]! = try? _managedObjectContext.executeFetchRequest(fetchRequest) as! [DFood!]
        return results
    }
    
    func getFood(forColour:String) -> [DFood]!{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplateWithName("FetchFoodByColour", substitutionVariables: ["COLOUR":forColour])
        
        return try! _managedObjectContext.executeFetchRequest(fetchFoodByColour!) as! [DFood]
    }
    
    func getCountOfFood(forColour:String) -> Int{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplateWithName("FetchFoodByColour", substitutionVariables: ["COLOUR":forColour])
        let error:NSErrorPointer = NSErrorPointer()
        let c = _managedObjectContext.countForFetchRequest(fetchFoodByColour!, error: error)
        return c
    }

    func getCountOfFreeFood(forColour:String) -> Int{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplateWithName("FetchFreeFoodByColour", substitutionVariables: ["COLOUR":forColour])
        let error:NSErrorPointer = NSErrorPointer()
        let c = _managedObjectContext.countForFetchRequest(fetchFoodByColour!, error: error)
        return c
    }
    
    func getFreeFood(forColour:String) -> [DFood]!{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplateWithName("FetchFreeFoodByColour", substitutionVariables: ["COLOUR":forColour])
        
        return try! _managedObjectContext.executeFetchRequest(fetchFoodByColour!) as! [DFood]
    }
    
    func deleteFood(food: DFood){
        _managedObjectContext.deleteObject(food)
    }
    
}