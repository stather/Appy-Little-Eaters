//
//  DownloadErrorManager.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 11/04/2016.
//  Copyright © 2016 Ready Steady Rainbow. All rights reserved.
//

import Foundation


public class DownloadErrorManager{
    static let sharedInstance = DownloadErrorManager()
    
    var Errors:[String]
    
    init(){
        Errors = [String]()
    }
    
    func AddError(Message: String)  {
        Errors.append(Message)
    }
    
}