//
//  Firefly.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class Firefly : ForestCreature{
	convenience init(){
		let t:SKTexture = SKTexture(imageNamed: "toadstool_03")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "FIREFLY"
	}
	
}