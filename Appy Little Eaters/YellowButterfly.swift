//
//  YellowButterfly.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 02/11/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import SpriteKit

public class YellowButterfly : ForestCreature{
	convenience init(){
		var t:SKTexture = SKTexture(imageNamed: "toadstool_03")
		self.init(texture: t, color:UIColor.blackColor(), size:t.size())
		name = "YELLOWBUTTERFLY"
	}
	
}