//
//  ResourceAudioPlayer.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 18/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation

open class ResourceAudioPlayer : AVAudioPlayer{
    
    var canPlay:Bool = true
    
    convenience init(fromName name:String){
        let soundFilePath = Bundle.main.path(forResource: name, ofType: "m4a")
        if soundFilePath != nil{
            let fileURL = URL(fileURLWithPath: soundFilePath!)
            try! self.init(contentsOf: fileURL)
        }else{
            self.init()
            canPlay = false
        }
    }
    
    override open func play() -> Bool {
        if canPlay{
            return super.play()
        }else{
            return false
        }
    }
    
    
}

