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
        let soundFilePath = NSBundle.mainBundle().pathForResource(name, ofType: "m4a")
        if soundFilePath != nil{
            let fileURL = NSURL(fileURLWithPath: soundFilePath!)
            try! self.init(contentsOfURL: fileURL)
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

