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
	var player:AVAudioPlayer!
	var ukeplayer:AVAudioPlayer!

	
	override public func viewDidLoad() {
		var soundFilePath = NSBundle.mainBundle().pathForResource("intro", ofType: "m4a")!
		var fileURL = NSURL(fileURLWithPath: soundFilePath)
		player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
		player.play()
		
		soundFilePath = NSBundle.mainBundle().pathForResource("uke1_01", ofType: "m4a")!
		fileURL = NSURL(fileURLWithPath: soundFilePath)
		ukeplayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
		ukeplayer.volume = 0.2
		ukeplayer.numberOfLoops = -1
		ukeplayer.play()
		
	}
	
	@IBAction func unwindFromConfirmationForm(segue: UIStoryboardSegue ){
		
	}
	
	@IBAction func unwindToHomeView(segue: UIStoryboardSegue ){
		
	}
}


//@property (weak, nonatomic) IBOutlet CHomeIconView *iconTray;
//@property (weak, nonatomic) IBOutlet SKView *spriteView;



