//
//  DAnimation+CoreDataProperties.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 17/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DAnimation {

    @NSManaged var atlas: String?
    @NSManaged var json: String?
    @NSManaged var name: String?
    @NSManaged var rewardImage: String?
    @NSManaged var texture: String?
    @NSManaged var version: NSNumber?

}
