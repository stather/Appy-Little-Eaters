//
//  FoodSelectCell.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 03/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class FoodSelectCell: UITableViewCell {

    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var TheSwitdh: UISwitch!
    @IBAction func FoodSwitch(_ sender: AnyObject) {
        let s = sender as! UISwitch
        let uow = UnitOfWork()
        let food = uow.foodRepository?.getFood(byName: FoodName.text!)
        if s.isOn{
            food!.visible = true
        }else{
            food!.visible = false
        }
        uow.saveChanges()
    }
    
    @IBOutlet weak var FoodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
