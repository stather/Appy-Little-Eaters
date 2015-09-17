//
//  ImageDownloader.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 13/09/2015.
//  Copyright (c) 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class BaseDownloader : NSOperation {
    var url:String
    var filename:String
    
    init(url:String, name:String){
        self.url = url
        self.filename = name
    }

    func saveContentsOfUrl(name:String, ext:String, srcUrl:String){
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let bundleID:String = NSBundle.mainBundle().bundleIdentifier!
        
        let possibleURLS:NSArray = fileManager.URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let appSupportDir:NSURL = possibleURLS[0] as! NSURL
        let dirPath = appSupportDir.URLByAppendingPathComponent(bundleID)
        var error:NSError?
        do {
            try fileManager.createDirectoryAtURL(dirPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error1 as NSError {
            error = error1
        }
        let filename = dirPath.URLByAppendingPathComponent(name + "." + ext)
        let filepath = filename.path
        let b = srcUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let u:NSURL = NSURL(string: b!)!
        
        let d:NSData? = NSData(contentsOfURL: u)
        if d != nil {
            let res = fileManager.createFileAtPath(filepath!, contents: d, attributes: nil)
        }
        
        
    }

}

class ImageDownloader: BaseDownloader {
    
    override init(url:String, name:String){
        super.init(url: url, name: name)
    }
    
    override func main() {
        print("Downloading: " + self.url)
        saveContentsOfUrl(self.filename, ext: "png", srcUrl: self.url)
        print("Done downloading: " + self.url)
    }

}

class SoundDownloader: BaseDownloader {
    
    override init(url:String, name:String){
        super.init(url: url, name: name)
    }
    
    override func main() {
        print("Downloading: " + self.url)
        saveContentsOfUrl(self.filename, ext: "m4a", srcUrl: self.url)
        print("Done downloading: " + self.url)
    }
    
}
