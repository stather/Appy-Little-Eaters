//
//  DownloadedAudioPlayer.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 25/01/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation

public class DownloadedAudioPlayer : AVAudioPlayer{
    
    var canPlay:Bool = true
    
    convenience init(fromName name:String){
        let soundFilePath = DownloadedAudioPlayer.getAudioFile(name)
        let fileURL = NSURL(fileURLWithPath: soundFilePath)
        do{
            try self.init(contentsOfURL: fileURL)
        }catch{
        }
    }


    static private func audioFilePath() -> NSURL{
        let bundleID:String = NSBundle.mainBundle().bundleIdentifier!
        
        let possibleURLS:NSArray = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let appSupportDir:NSURL = possibleURLS[0] as! NSURL
        let dirPath = appSupportDir.URLByAppendingPathComponent(bundleID)
        try! NSFileManager.defaultManager().createDirectoryAtURL(dirPath, withIntermediateDirectories: true, attributes: nil)
        
        return dirPath
    }
    
    static private func getAudioFile(forName:String) -> String{
        let dirPath = audioFilePath()
        let filename = dirPath.URLByAppendingPathComponent(forName + ".m4a")
        let filepath = filename.path
        return filepath!;
    }
    
    
    
    override public func play() -> Bool {
        if canPlay{
            return super.play()
        }else{
            return false
        }
    }
    
}

