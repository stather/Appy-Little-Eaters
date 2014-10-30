//
//  RewardDefinition.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 26/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit

public class RewardDefinition{
	var rewardType:ForestCreature.CreatureName!
	var position:CGPoint!
	
	init(fromDictionary: NSDictionary){
		rewardType = ForestCreature.CreatureName( rawValue: fromDictionary.valueForKey("rewardType") as Int )
		var x:CGFloat = CGFloat(fromDictionary.valueForKey("x") as Int)
		var y:CGFloat = CGFloat(fromDictionary.valueForKey("y") as Int)
		
		position = CGPointMake(x, y)
		
	}
}