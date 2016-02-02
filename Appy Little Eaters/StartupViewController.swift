//
//  StartupViewController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 02/02/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit

class StartupViewController : UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var childsName: UITextField!
    
    @IBOutlet weak var accept: UISwitch!
    
    @IBOutlet weak var startEating: UIButton!
    
    @IBAction func acceptClicked(sender: AnyObject) {
        if accept.on{
            if !isValidEmail(emailAddress.text!){
                let al = UIAlertController(title: "Error", message: "You must enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
                al.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                presentViewController(al, animated: true, completion: nil)
                accept.on = false
                return
            }
            if childsName.text!.characters.count == 0{
                let al = UIAlertController(title: "Error", message: "You must enter your childs name", preferredStyle: UIAlertControllerStyle.Alert)
                al.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                presentViewController(al, animated: true, completion: nil)
                accept.on = false
                return
            }
            startEating.enabled = true
        }else{
            startEating.enabled = false
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().boolForKey("TC_Accepted"){
            performSegueWithIdentifier("Start2Home", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Start2Home" && !NSUserDefaults.standardUserDefaults().boolForKey("TC_Accepted"){
            let api = AleApi()
            api.addUser(emailAddress.text!)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "TC_Accepted")
        }
        
    }
    
}


