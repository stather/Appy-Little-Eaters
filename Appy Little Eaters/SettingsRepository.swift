//
//  SettingsRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 10/02/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import Foundation


public class SettingsRepository{
    
    func getCurrentBackground() -> String{
        let back = NSUserDefaults.standardUserDefaults().integerForKey("backgroundId")
        var backName:String
        switch back{
        case 0:
            backName = "Magic Forest"
            break
        case 1:
            backName = "Magic Planet"
            break
        default:
            backName = "Magic Forest"
            break
            
        }
        return backName
    }
}