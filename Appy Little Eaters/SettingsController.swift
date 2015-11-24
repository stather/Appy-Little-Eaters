//
//  SettingsController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 02/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController, InAppPurchaseDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")
        switch indexPath.row{
        case 0:
            cell?.textLabel?.text = "Buy complete food selection"
            break
        case 1:
            cell?.textLabel?.text = "Choose foods to eat"
            break
        case 2:
            cell?.textLabel?.text = "Check for updates"
            break
        default:
            break
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            InAppPurchaseManager.sharedInstance.BuyFood(self)
            break
        case 1:
            performSegueWithIdentifier("FoodSettingsSeque", sender: self)
            break
        case 2:
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.checkForUpdates(nil)
            break
        default:
            break
        }
    }
    
    func FoodNotPurchased() {
        
        
    }
    
    func FoodPurchased() {
        
        
    }
}
