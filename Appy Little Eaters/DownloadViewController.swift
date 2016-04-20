//
//  DownloadViewController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 04/04/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet weak var StatusText: UILabel!
    @IBOutlet weak var StatusProgress: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.resetAll(StatusProgress, text: StatusText, done: {()->Void in
            self.presentNextMessage()
            
        })

    }
    
    func presentNextMessage(){
        let message = DownloadErrorManager.sharedInstance.Errors.popLast()
        if message == nil{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ContentDownloaded")
            performSegueWithIdentifier("UnwindFromDownload", sender: self)
        }
        let alert = UIAlertController(title: "Download", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { (action) in
            self.presentNextMessage()
        }
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: false, completion: { () -> Void in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
