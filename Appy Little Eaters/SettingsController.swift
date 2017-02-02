//
//  SettingsController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 02/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, InAppPurchaseDelegate {

    @IBOutlet weak var StatusHolder: UIView!
    @IBOutlet weak var StatusText: UILabel!
    @IBOutlet weak var StatusProgress: UIProgressView!
    
    @IBOutlet weak var AdminHolder: UIView!
    @IBOutlet weak var ControlsToggleSwitch: UISwitch!
    @IBOutlet weak var AllFoodsToggle: UISwitch!
    
    @IBAction func ControlsToggle(_ sender: UISwitch) {
        if ControlsToggleSwitch.isOn{
            UserDefaults.standard.set(true, forKey: "AnimationControls")
        }else{
            UserDefaults.standard.set(false, forKey: "AnimationControls")
        }
    }
    
    @IBAction func MarkContentNotDownloaded(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "ContentDownloaded")
    }
    
    @IBAction func AllFoodsToggled(_ sender: AnyObject) {
        
        if AllFoodsToggle.isOn{
            InAppPurchaseManager.sharedInstance.setFoodsBought()
        }else{
            InAppPurchaseManager.sharedInstance.setFoodsNotBought()
        }
    }
    
    @IBAction func unwindToSettings(_ segue: UIStoryboardSegue ){
        
    }

    @IBAction func resetUser(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "TC_Accepted")
    }
    
    @IBAction func FillTheForest(_ sender: AnyObject) {
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        
        let backName = SettingsRepository().getCurrentBackground()
        
        let allRewardsInPool = uow.rewardPoolRepository?.getAllRewardsInPool(backName)

        for item in allRewardsInPool!{
            let reward = uow.rewardRepository?.createNewReward()
            
            reward!.creatureName = NSNumber(value: Int((item?.creatureName!)!) as Int)
            reward!.positionX = item?.positionX!
            //            reward!.positionY = 768 - Int(item.positionY!)
            reward!.positionY = Int((item?.positionY!)!) as NSNumber?
            reward!.scale = item?.scale!
            reward!.animationName = item?.imageName
            reward!.rewardName = item?.rewardName
            item?.available = false
        }
        uow.saveChanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        ControlsToggleSwitch.isOn = UserDefaults.standard.bool(forKey: "AnimationControls")
        AllFoodsToggle.isOn = InAppPurchaseManager.sharedInstance.allFoodsBought()
    }
    
    @IBAction func ClearRewards(_ sender: AnyObject) {
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        uow.rewardPoolRepository?.makeAllRewardsAvailable()
        uow.saveChanges()
    }
    
    @IBAction func ResetAll(_ sender: AnyObject) {
        StatusHolder.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetAll(StatusProgress, text: StatusText, done: {()->Void in
            self.StatusHolder.isHidden = true
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        let d = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"]
        if d == nil {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func buyFood(_ sender: UIButton) {
        let pg = ParentalGate.new { (success) in
            if success{
                InAppPurchaseManager.sharedInstance.BuyFood(self)
            }else{
                
            }
        }
        pg?.show()
    }

    @IBAction func checkForUpdates(_ sender: AnyObject) {
//        StatusHolder.isHidden = false
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.checkForUpdates(StatusProgress, text: StatusText, done: { () -> Void in
//            self.StatusHolder.isHidden = true
//        })
    }
    
    
    func FoodNotPurchased() {
        
        
    }
    
    func FoodPurchased() {
        
        
    }
    
    @IBAction func unwindFromDownload(_ sender: UIStoryboardSegue)
    {
        //let sourceViewController = sender.sourceViewController
    }
    
}
