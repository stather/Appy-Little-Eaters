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
    
    @IBAction func ControlsToggle(sender: UISwitch) {
        if ControlsToggleSwitch.on{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "AnimationControls")
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "AnimationControls")
        }
    }
    
    @IBAction func MarkContentNotDownloaded(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "ContentDownloaded")
    }
    
    @IBAction func AllFoodsToggled(sender: AnyObject) {
        
        if AllFoodsToggle.on{
            InAppPurchaseManager.sharedInstance.setFoodsBought()
        }else{
            InAppPurchaseManager.sharedInstance.setFoodsNotBought()
        }
    }
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue ){
        
    }

    @IBAction func resetUser(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "TC_Accepted")
    }
    
    @IBAction func FillTheForest(sender: AnyObject) {
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        
        let backName = SettingsRepository().getCurrentBackground()
        
        let allRewardsInPool = uow.rewardPoolRepository?.getAllRewardsInPool(backName)

        for item in allRewardsInPool!{
            let reward = uow.rewardRepository?.createNewReward()
            
            reward!.creatureName = NSNumber(integer: Int(item.creatureName!))
            reward!.positionX = item.positionX!
            //            reward!.positionY = 768 - Int(item.positionY!)
            reward!.positionY = Int(item.positionY!)
            reward!.scale = item.scale!
            reward!.animationName = item.imageName
            reward!.rewardName = item.rewardName
            item.available = false
        }
        uow.saveChanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        ControlsToggleSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("AnimationControls")
        AllFoodsToggle.on = InAppPurchaseManager.sharedInstance.allFoodsBought()
    }
    
    @IBAction func ClearRewards(sender: AnyObject) {
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        uow.rewardPoolRepository?.makeAllRewardsAvailable()
        uow.saveChanges()
    }
    
    @IBAction func ResetAll(sender: AnyObject) {
        StatusHolder.hidden = false
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.resetAll(StatusProgress, text: StatusText, done: {()->Void in
            self.StatusHolder.hidden = true
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        let d = NSProcessInfo.processInfo().environment["SIMULATOR_DEVICE_NAME"]
        if d == nil {
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func buyFood(sender: UIButton) {
        InAppPurchaseManager.sharedInstance.BuyFood(self)
    }

    @IBAction func checkForUpdates(sender: AnyObject) {
        StatusHolder.hidden = false
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.checkForUpdates(StatusProgress, text: StatusText, done: { () -> Void in
            self.StatusHolder.hidden = true
        })
    }
    
    
    func FoodNotPurchased() {
        
        
    }
    
    func FoodPurchased() {
        
        
    }
    
    @IBAction func unwindFromDownload(sender: UIStoryboardSegue)
    {
        //let sourceViewController = sender.sourceViewController
    }
    
}
