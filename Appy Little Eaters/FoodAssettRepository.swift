//
//  FoodAssettRepository.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 03/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit


open class FoodAssetRepository{
    fileprivate var _fileManager:FileManager
    
    public init(){
        _fileManager = FileManager.default
    }
    
    fileprivate func foodImagePath() -> URL{
        let bundleID:String = Bundle.main.bundleIdentifier!
        
        let possibleURLS:NSArray = _fileManager.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as NSArray
        let appSupportDir:URL = possibleURLS[0] as! URL
        let dirPath = appSupportDir.appendingPathComponent(bundleID)
        try! _fileManager.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
 
        return dirPath
    }
    
    open func getFoodImage(_ forName:String) -> UIImage{
        let dirPath = foodImagePath()
        let filename = dirPath.appendingPathComponent(forName + ".png")
        let filepath = filename.path
        let image:UIImage = UIImage(contentsOfFile: filepath as String!)!
        return image;
    }
    
    open func addFoodImage(_ foodName:String, data:Data){
        let dirPath = foodImagePath()
        let filename = dirPath.appendingPathComponent(foodName + ".png")
        let filepath = filename.path
        _ = _fileManager.createFile(atPath: filepath, contents: data, attributes: nil)
    }
    

}
