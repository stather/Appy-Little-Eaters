//
//  FoodRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 03/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

open class FoodRepository{
    fileprivate var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectModel
    }()

    func createNewFood() -> DFood!{
        return NSEntityDescription.insertNewObject(forEntityName: "DFood", into: self._managedObjectContext) as! DFood
    }
    
    func getAllFood() -> [DFood?]!{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "DFood", in: _managedObjectContext)
        let results:[DFood?]! = try? _managedObjectContext.fetch(fetchRequest) as! [DFood?]
        return results
    }
    
    func getFood(_ forColour:String) -> [DFood]!{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchFoodByColour", substitutionVariables: ["COLOUR":forColour])
        
        return try! _managedObjectContext.fetch(fetchFoodByColour!) as! [DFood]
    }
    
    func getVisibleFood(_ forColour:String) -> [DFood]!{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchVisibleFoodByColour", substitutionVariables: ["COLOUR":forColour])
        
        return try! _managedObjectContext.fetch(fetchFoodByColour!) as! [DFood]
    }
    
    func getCountOfFood(_ forColour:String) -> Int{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchFoodByColour", substitutionVariables: ["COLOUR":forColour])
        let c = try! _managedObjectContext.count(for: fetchFoodByColour!)
        return c
    }

    func getCountOfFreeFood(_ forColour:String) -> Int{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchFreeFoodByColour", substitutionVariables: ["COLOUR":forColour])
        let c = try! _managedObjectContext.count(for: fetchFoodByColour!)
        return c
    }
    
    func getFreeFood(_ forColour:String) -> [DFood]!{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchFreeFoodByColour", substitutionVariables: ["COLOUR":forColour])
        
        return try! _managedObjectContext.fetch(fetchFoodByColour!) as! [DFood]
    }
    
    func getFreeVisibleFood(_ forColour:String) -> [DFood]!{
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchFreeVisibleFoodByColour", substitutionVariables: ["COLOUR":forColour])
        
        return try! _managedObjectContext.fetch(fetchFoodByColour!) as! [DFood]
    }
    
    func getFood(byName:String) -> DFood?{
        let fetchFoodByName = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchFoodByName", substitutionVariables: ["NAME":byName])
        let f = try! _managedObjectContext.fetch(fetchFoodByName!)
        if f.count > 0 {
            return f[0] as? DFood
        }else{
            return nil
        }
    }
    
    func deleteFood(_ food: DFood){
        _managedObjectContext.delete(food)
    }
    
}
