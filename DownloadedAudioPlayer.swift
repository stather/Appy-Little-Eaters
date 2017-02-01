//
//  DownloadedAudioPlayer.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 25/01/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation

open class DownloadedAudioPlayer : AVAudioPlayer{
    
    var canPlay:Bool = true
    
    convenience init?(fromName name:String) throws{
        let soundFilePath = DownloadedAudioPlayer.getAudioFile(name)
        let fileURL = URL(fileURLWithPath: soundFilePath)
        var error:NSError? = nil
        if (fileURL as NSURL).checkResourceIsReachableAndReturnError(&error){
            try self.init(contentsOf: fileURL)
        }else{
            return nil
        }
    }


    static fileprivate func audioFilePath() -> URL{
        let bundleID:String = Bundle.main.bundleIdentifier!
        
        let possibleURLS:NSArray = FileManager.default.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as NSArray
        let appSupportDir:URL = possibleURLS[0] as! URL
        let dirPath = appSupportDir.appendingPathComponent(bundleID)
        try! FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
        
        return dirPath
    }
    
    static fileprivate func getAudioFile(_ forName:String) -> String{
        let dirPath = audioFilePath()
        let filename = dirPath.appendingPathComponent(forName + ".m4a")
        let filepath = filename.path
        return filepath;
    }
    
    
    
    override open func play() -> Bool {
        if canPlay{
            return super.play()
        }else{
            return false
        }
    }
    
}

