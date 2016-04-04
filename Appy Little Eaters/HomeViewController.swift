//
//  HomeViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 12/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


public class HomeViewController : UIViewController{
	var player:ResourceAudioPlayer!

    @IBOutlet weak var ForestButton: UIButton!
    
    override public func viewWillAppear(animated: Bool) {
        let back = NSUserDefaults.standardUserDefaults().integerForKey("backgroundId")
        if back == 0 {
            let i = UIImage(named: "home-forest.png", inBundle: nil, compatibleWithTraitCollection: nil)
            ForestButton.setBackgroundImage(i, forState: UIControlState.Normal)
        }else{
            let i = UIImage(named: "My-Alien-World-2.png", inBundle: nil, compatibleWithTraitCollection: nil)
            ForestButton.setBackgroundImage(i, forState: UIControlState.Normal)
        }
        if !NSUserDefaults.standardUserDefaults().boolForKey("ContentDownloaded"){
            performSegueWithIdentifier("Home2Download", sender: self)
        }

    }
	
	override public func viewDidLoad() {
		player = ResourceAudioPlayer(fromName: "intro")
		player.play()
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.playTheUke()
        
    
	}
	
	@IBAction func unwindFromConfirmationForm(segue: UIStoryboardSegue ){
		
	}
	
	@IBAction func unwindToHomeView(segue: UIStoryboardSegue ){
		
	}
    
    @IBAction func unwindFromDownload(sender: UIStoryboardSegue)
    {
        //let sourceViewController = sender.sourceViewController
    }

}




