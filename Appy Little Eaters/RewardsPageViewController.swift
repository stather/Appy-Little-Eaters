//
//  RewardsPageViewController.swift
//  Appy Little Eaters
//
//  Created by Russell Stather on 28/09/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RewardsPageViewController: UIViewController{
	
	var chosen:DRewardPool!
	var lhs:DRewardPool!
	var rhs:DRewardPool!
	
    @IBOutlet weak var BackgroundImage: UIImageView!
	
	@IBOutlet weak var DoneButton: UIButton!
	
	@IBAction func DonePressed(_ sender: UIButton) {
        if chosen != nil{
            let uow = UnitOfWork()
            let reward = uow.rewardRepository?.createNewReward()
		
            reward!.positionX = chosen.positionX!
            reward!.positionY = chosen.positionY!
            reward!.scale = chosen.scale!
            reward!.animationName = chosen.imageName!
            reward!.rewardName = chosen.rewardName!
            chosen.available = false
            uow.saveChanges()
        }
        
		performSegue(withIdentifier: "RewardToForest", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
	}
	
	@IBOutlet weak var RightReward: UIImageView!
	
	@IBOutlet weak var LeftReward: UIImageView!
	
	@IBAction func LeftImageTapped(_ sender: UITapGestureRecognizer) {
		LeftReward.backgroundColor = UIColor.red
		RightReward.backgroundColor = UIColor.clear
		chosen = lhs
		DoneButton.isEnabled = true
	}
	
	@IBAction func RightImageTapped(_ sender: UITapGestureRecognizer) {
		RightReward.backgroundColor = UIColor.red
		LeftReward.backgroundColor = UIColor.clear
		chosen = rhs
		DoneButton.isEnabled = true
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
    
    func loadRewardImage(_ name:String) -> UIImage{
        let fileManager:FileManager = FileManager.default
        let bundleID:String = Bundle.main.bundleIdentifier!
        
        let possibleURLS:NSArray = fileManager.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as NSArray
        let appSupportDir:URL = possibleURLS[0] as! URL
        let dirPath = appSupportDir.appendingPathComponent(bundleID)
        let filename = dirPath.appendingPathComponent(name + "RewardImage." + "png")
        let filepath = filename.path
        
        let newpath = Bundle.main.path(forResource: name + "RewardImage", ofType: "png")
        let image:UIImage = UIImage(contentsOfFile: newpath as String!)!
        return image;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let back = UserDefaults.standard.integer(forKey: "backgroundId")
        if back == 0 {
            BackgroundImage.image = UIImage(named: "reward-background.jpg", in: nil, compatibleWith: nil)
        }else{
            BackgroundImage.image = UIImage(named: "spaceback.jpg", in: nil, compatibleWith: nil)
        }
    }

	
	override func viewDidLoad() {
        let uow = UnitOfWork()
        let backName = SettingsRepository().getCurrentBackground()
        let rewards:[DRewardPool] = (uow.rewardPoolRepository?.getAvailableRewardsOrderedByLevel(backName))!
        
        if rewards.count == 0 {
            let alert = UIAlertController(title: "Rewards", message: "Sorry no more rewards are available", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (action) in
                print(action)
            }
            alert.addAction(cancelAction)
            
            present(alert, animated: false, completion: { () -> Void in
            
            })
            return
            
        }
		LeftReward.image = loadRewardImage(rewards[0].imageName!)
		lhs = rewards[0]

		RightReward.image = loadRewardImage(rewards[1].imageName!)
		rhs = rewards[1]
		DoneButton.isEnabled = false;
	}
}
