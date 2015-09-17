//
//  DFood.swift
//  
//
//  Created by RUSSELL STATHER on 14/09/2015.
//
//

import Foundation
import CoreData

class DFood: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var path: String
    @NSManaged var free: NSNumber
    @NSManaged var colour: String

}
