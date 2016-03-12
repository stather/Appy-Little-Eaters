//
//  SpecialRewardViewController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 24/02/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class SpecialRewardViewController: UIViewController {

    @IBOutlet weak var RewardText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RewardText.text = NSUserDefaults.standardUserDefaults().stringForKey("SpecialReward")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setValue(RewardText.text, forKey: "SpecialReward")
    }


}