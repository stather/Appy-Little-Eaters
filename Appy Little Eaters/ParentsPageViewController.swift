//
//  ParentsPageViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 19/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import CoreData

open class ParentsPageViewController : UIViewController{
	
	var currentPage:Int = 1
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	@IBOutlet weak var theText: UIImageView!
	
    @IBOutlet weak var animationProgress: UIProgressView!
    @IBOutlet weak var foodProgress: UIProgressView!
    @IBOutlet weak var rewardProgress: UIProgressView!
	@IBOutlet weak var facebook: UIButton!
	@IBOutlet weak var webLink: UIButton!
	override open func viewDidLoad() {
		backButton.isHidden = true
		facebook.isHidden = true
		webLink.isHidden = true
	}
    
    @IBAction func linkPressed(_ sender: AnyObject) {
        if currentPage == 1 {
            let pg = ParentalGate.new { (success) in
                if success{
                    UIApplication.shared.openURL(URL(string: "http://www.readysteadyrainbow.com")!)
                }else{
                    
                }
            }
            pg?.show()
            
        }
    }
	
	@IBAction func backPressed(_ sender: AnyObject) {
		currentPage -= 1
		setupPage()
	}
	
	@IBAction func nextPressed(_ sender: AnyObject) {
		currentPage += 1
		setupPage()
	}
	
	func setupPage(){
		switch currentPage{
		case 1:
			theText.image = UIImage(named: "PARENTS-PAGE-1.png")
			backButton.isHidden = true
			break
		case 2:
			theText.image = UIImage(named: "PARENTS-PAGE-2.png")
			backButton.isHidden = false
			break
		case 3:
			theText.image = UIImage(named: "PARENTS-PAGE-3.png")
			break
		case 4:
			theText.image = UIImage(named: "PARENTS-PAGE4.png")
			nextButton.isHidden = false
			facebook.isHidden = true
			webLink.isHidden = true
			break
		case 5:
			theText.image = UIImage(named: "PARENTS-PAGE5.png")
			nextButton.isHidden = true
			facebook.isHidden = false
			webLink.isHidden = false
			break
		default:
			break
		}
	}
	
	
	
	@IBAction func facebookPressed(_ sender: AnyObject) {
        let pg = ParentalGate.new { (success) in
            if success{
                UIApplication.shared.openURL(URL(string: "https://www.facebook.com/Appy-Little-Eaters-513014552138440/")!)
            }else{
                
            }
        }
        pg?.show()
		
	}
	
	@IBAction func webLinkPressed(_ sender: AnyObject) {
        let pg = ParentalGate.new { (success) in
            if success{
                UIApplication.shared.openURL(URL(string: "http://www.readysteadyrainbow.com")!)
            }else{
                
            }
        }
        pg?.show()
	}
	
}
