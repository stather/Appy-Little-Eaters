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
    
    func downloadData() -> NSData?{
        let b = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let u:NSURL = NSURL(string: b!)!
        
        let d:NSData? = NSData(contentsOfURL: u)
        return d
    }

    func saveContentsOfUrl(name:String, ext:String, srcUrl:String){
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let bundleID:String = NSBundle.mainBundle().bundleIdentifier!
        
        let possibleURLS:NSArray = fileManager.URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let appSupportDir:NSURL = possibleURLS[0] as! NSURL
        let dirPath = appSupportDir.URLByAppendingPathComponent(bundleID)
        try! fileManager.createDirectoryAtURL(dirPath, withIntermediateDirectories: true, attributes: nil)
        let filename = dirPath.URLByAppendingPathComponent(name + "." + ext)
        let filepath = filename.path
        
        let d:NSData? = downloadData()
        if d != nil {
            _ = fileManager.createFileAtPath(filepath!, contents: d, attributes: nil)
        }
        
        
    }

}

class ImageDownloader: BaseDownloader {
    
    override init(url:String, name:String){
        super.init(url: url, name: name)
    }
    
    override func main() {
        print("Downloading: " + self.url)
        let d = downloadData()
        if d != nil{
            let uow = UnitOfWork()
            let rep = uow.foodAssetRepository
            rep?.addFoodImage(filename, data: d!)
        }
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

class AtlasDownloader: BaseDownloader{
    
    override init(url: String, name: String) {
        super.init(url: url, name: name)
    }
    
    override func main() {
        print("Downloading: " + self.url)
        saveContentsOfUrl(self.filename, ext: "atlas", srcUrl: self.url)
        print("Done downloading: " + self.url)
    }
}

class JsonDownloader: BaseDownloader{
    
    override init(url: String, name: String) {
        super.init(url: url, name: name)
    }
    
    override func main() {
        print("Downloading: " + self.url)
        saveContentsOfUrl(self.filename, ext: "json", srcUrl: self.url)
        print("Done downloading: " + self.url)
    }
}

