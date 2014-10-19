//
//  ResourceAudioPlayer.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 18/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation

public class ResourceAudioPlayer : AVAudioPlayer{
	
	var canPlay:Bool = true
	
	convenience init(fromName name:String){
		var soundFilePath = NSBundle.mainBundle().pathForResource(name, ofType: "m4a")?
		if soundFilePath != nil{
			var fileURL = NSURL(fileURLWithPath: soundFilePath!)
			self.init(contentsOfURL: fileURL, error: nil)
		}else{
			self.init()
			canPlay = false
		}
	}
	
	override public func play() -> Bool {
		if canPlay{
			return super.play()
		}else{
			return false
		}
	}
	

}