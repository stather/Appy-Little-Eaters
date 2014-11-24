//
//  AppyLittleEaters.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

class DReward: NSManagedObject {
	
	@NSManaged var creatureName: NSNumber
	@NSManaged var positionX: NSNumber
	@NSManaged var positionY: NSNumber
	@NSManaged var scale: NSNumber
}


class DRewardPool: NSManagedObject {
	
	@NSManaged var creatureName: NSNumber
	@NSManaged var available: NSNumber
	@NSManaged var positionX: NSNumber
	@NSManaged var positionY: NSNumber
	@NSManaged var imageName: String
	@NSManaged var level: NSNumber
	@NSManaged var scale: NSNumber
}
