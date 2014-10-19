//
//  HomeViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 12/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation

public class HomeViewController : UIViewController{
	var player:ResourceAudioPlayer!
	var ukeplayer:ResourceAudioPlayer!

	
	override public func viewDidLoad() {
		player = ResourceAudioPlayer(fromName: "intro")
		player.play()
		
		ukeplayer = ResourceAudioPlayer(fromName: "uke1_01")
		ukeplayer.volume = 0.2
		ukeplayer.numberOfLoops = -1
		ukeplayer.play()
		
	}
	
	@IBAction func unwindFromConfirmationForm(segue: UIStoryboardSegue ){
		
	}
	
	@IBAction func unwindToHomeView(segue: UIStoryboardSegue ){
		
	}
}




