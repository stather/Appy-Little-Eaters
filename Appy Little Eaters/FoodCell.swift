//
//  FoodCell.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 18/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit

open class FoodCell : UICollectionViewCell{

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBOutlet weak var foodImage:UIImageView!
    @IBOutlet weak var FoodLabel: UILabel!
	
}
