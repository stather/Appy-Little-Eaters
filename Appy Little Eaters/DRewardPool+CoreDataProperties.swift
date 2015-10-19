//
//  DRewardPool+CoreDataProperties.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 19/10/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DRewardPool {

    @NSManaged var available: NSNumber?
    @NSManaged var creatureName: NSNumber?
    @NSManaged var imageName: String?
    @NSManaged var level: NSNumber?
    @NSManaged var positionX: NSNumber?
    @NSManaged var positionY: NSNumber?
    @NSManaged var scale: NSNumber?
    @NSManaged var rewardName: String?

}
