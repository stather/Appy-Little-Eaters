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


open class HomeViewController : UIViewController{
	var player:ResourceAudioPlayer!

    @IBOutlet weak var ForestButton: UIButton!
    
    override open func viewWillAppear(_ animated: Bool) {
        let back = UserDefaults.standard.integer(forKey: "backgroundId")
        if back == 0 {
            let i = UIImage(named: "home-forest.png", in: nil, compatibleWith: nil)
            ForestButton.setBackgroundImage(i, for: UIControlState())
        }else{
            let i = UIImage(named: "My-Alien-World-2.png", in: nil, compatibleWith: nil)
            ForestButton.setBackgroundImage(i, for: UIControlState())
        }
        if !UserDefaults.standard.bool(forKey: "ContentDownloaded"){
            performSegue(withIdentifier: "Home2Download", sender: self)
        }

    }
	
	override open func viewDidLoad() {
		player = ResourceAudioPlayer(fromName: "intro")
		player.play()
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.playTheUke()
        
    
	}
	
	@IBAction func unwindFromConfirmationForm(_ segue: UIStoryboardSegue ){
		
	}
	
	@IBAction func unwindToHomeView(_ segue: UIStoryboardSegue ){
		
	}
    
    @IBAction func unwindFromDownload(_ sender: UIStoryboardSegue)
    {
        //let sourceViewController = sender.sourceViewController
    }

}




