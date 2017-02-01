//
//  ImageDownloader.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 13/09/2015.
//  Copyright (c) 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class BaseDownloader : Operation {
    var url:String
    var filename:String
    
    init(url:String, name:String){
        self.url = url
        self.filename = name
    }
    
    func downloadData() -> Data?{
        let b = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let u:URL = URL(string: b!)!
        
        let d:Data? = try? Data(contentsOf: u)
        if d == nil{
            DownloadErrorManager.sharedInstance.AddError(url)
        }
        return d
    }

    func saveContentsOfUrl(_ name:String, ext:String, srcUrl:String){
        let fileManager:FileManager = FileManager.default
        let bundleID:String = Bundle.main.bundleIdentifier!
        
        let possibleURLS:NSArray = fileManager.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as NSArray
        let appSupportDir:URL = possibleURLS[0] as! URL
        let dirPath = appSupportDir.appendingPathComponent(bundleID)
        try! fileManager.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
        let filename = dirPath.appendingPathComponent(name + "." + ext)
        let filepath = filename.path
        
        let d:Data? = downloadData()
        if d != nil {
            _ = fileManager.createFile(atPath: filepath, contents: d, attributes: nil)
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

