//
//  SettingsController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 02/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, InAppPurchaseDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func chooseFoods(sender: UIButton) {
    }
    
    @IBAction func buyFood(sender: UIButton) {
        InAppPurchaseManager.sharedInstance.BuyFood(self)
    }

    @IBAction func checkForUpdates(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.checkForUpdates(nil)
    }
    
    
    func FoodNotPurchased() {
        
        
    }
    
    func FoodPurchased() {
        
        
    }
}
