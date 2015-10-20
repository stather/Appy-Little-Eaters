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
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()
    
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
    
    func animationByName(byName:String) -> DAnimation!{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplateWithName("FetchAnimationByName", substitutionVariables: ["NAME":byName])
        let anim = try! _managedObjectContext.executeFetchRequest(fetchByName!) as! [DAnimation]
        return anim[0]
    }
    
}

