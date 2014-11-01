//
//  Appy_Little_Eaters.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 01/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import CoreData

class DReward: NSManagedObject {

    @NSManaged var creatureName: NSNumber
    @NSManaged var positionX: NSNumber
    @NSManaged var positionY: NSNumber

}
