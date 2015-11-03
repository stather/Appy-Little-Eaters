//
//  FoodAssettRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 03/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit


public class FoodAssetRepository{
    private var _fileManager:NSFileManager
    
    public init(){
        _fileManager = NSFileManager.defaultManager()
    }
    
    private func foodImagePath() -> NSURL{
        let bundleID:String = NSBundle.mainBundle().bundleIdentifier!
        
        let possibleURLS:NSArray = _fileManager.URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let appSupportDir:NSURL = possibleURLS[0] as! NSURL
        let dirPath = appSupportDir.URLByAppendingPathComponent(bundleID)
        var error:NSError?
        do {
            try _fileManager.createDirectoryAtURL(dirPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error1 as NSError {
            error = error1
        }

        return dirPath
    }
    
    public func getFoodImage(forName:String) -> UIImage{
        let dirPath = foodImagePath()
        let filename = dirPath.URLByAppendingPathComponent(forName + ".png")
        let filepath = filename.path
        let image:UIImage = UIImage(contentsOfFile: filepath as String!)!
        return image;
    }
    
    public func addFoodImage(foodName:String, data:NSData){
        let dirPath = foodImagePath()
        let filename = dirPath.URLByAppendingPathComponent(foodName + ".png")
        let filepath = filename.path
        _ = _fileManager.createFileAtPath(filepath!, contents: data, attributes: nil)
    }
    

}