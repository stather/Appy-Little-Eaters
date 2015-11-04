//
//  DFood+CoreDataProperties.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 04/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DFood {

    @NSManaged var colour: String?
    @NSManaged var free: NSNumber?
    @NSManaged var name: String?
    @NSManaged var path: String?
    @NSManaged var visible: NSNumber?

}
