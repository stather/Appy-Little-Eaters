//
//  AnimationRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 04/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

open class AnimationRepository{
    fileprivate var _managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        _managedObjectContext = managedObjectContext
    }
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()
    
    func createNewAnimation() -> DAnimation!{
        return NSEntityDescription.insertNewObject(forEntityName: "DAnimation", into: self._managedObjectContext) as! DAnimation
    }
    
    func getAllAnimation() -> [DAnimation?]!{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "DAnimation", in: _managedObjectContext)
        //fetchRequest.includesPropertyValues = false
        
        let results:[DAnimation?]! = try? _managedObjectContext.fetch(fetchRequest) as! [DAnimation?]
        return results
    }
    
    func deleteAnimation(_ food: DAnimation){
        _managedObjectContext.delete(food)
    }
    
    func animationByName(_ byName:String) -> DAnimation!{
        let fetchByName = managedObjectModel?.fetchRequestFromTemplate(withName: "FetchAnimationByName", substitutionVariables: ["NAME":byName])
        let anim = try! _managedObjectContext.fetch(fetchByName!) as! [DAnimation]
        if anim.count > 0{
            return anim[0]
        }
        return nil
    }
    
    func count() -> Int{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "DAnimation", in: _managedObjectContext)
        let c = try! _managedObjectContext.count(for: fetchRequest)
        return c
    }

    
}

