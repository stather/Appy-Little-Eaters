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
}




