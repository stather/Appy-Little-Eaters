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
    
    @IBAction func acceptClicked(_ sender: AnyObject) {
        if accept.isOn{
            /*
            if !isValidEmail(emailAddress.text!){
                let al = UIAlertController(title: "Error", message: "You must enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
                al.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                presentViewController(al, animated: true, completion: nil)
                accept.on = false
                return
            }
 */
            if childsName.text!.characters.count == 0{
                let al = UIAlertController(title: "Error", message: "You must enter your childs name", preferredStyle: UIAlertControllerStyle.alert)
                al.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                present(al, animated: true, completion: nil)
                accept.isOn = false
                return
            }
            startEating.isEnabled = true
        }else{
            startEating.isEnabled = false
        }
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "TC_Accepted"){
            performSegue(withIdentifier: "Start2Home", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Start2Home" && !UserDefaults.standard.bool(forKey: "TC_Accepted"){
            let api = AleApi()
            api.addUser(emailAddress.text!)
            UserDefaults.standard.set(true, forKey: "TC_Accepted")
        }
        
    }
    
    @IBAction func unwindToStartPage(_ segue: UIStoryboardSegue ){
        
    }

    
}


