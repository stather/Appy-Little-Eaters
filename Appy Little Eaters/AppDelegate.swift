//
//  AppDelegate.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 30/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData
import Fabric
import Crashlytics
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var ukeplayer:ResourceAudioPlayer!
	var forestSoundsPlayer:ResourceAudioPlayer!
	var synth:AVSpeechSynthesizer?
	var preferredVoice:AVSpeechSynthesisVoice?
	
	func speak(_ text: String){
		let utter:AVSpeechUtterance = AVSpeechUtterance(string: text)
		utter.rate = AVSpeechUtteranceMinimumSpeechRate
		utter.voice = preferredVoice
		synth?.speak(utter)
		
	}
    
    func playTheUke(){
        ukeplayer = ResourceAudioPlayer(fromName: "My_Life_Is_Good_full")
        ukeplayer.volume = 0.2
        ukeplayer.numberOfLoops = -1
        ukeplayer.play()
    }
    
    func stopTheUke(){
        ukeplayer.stop()
    }
    
    func playSceneSound(){
        let back = UserDefaults.standard.integer(forKey: "backgroundId")
        switch (back){
        case 0:
            playTheForestSounds()
            break
        case 1:
            playTheSpaceSound()
            break
        default:
            playTheForestSounds()
        }
    }
    
    func stopSceneSound(){
        forestSoundsPlayer.stop()
    }
    
    fileprivate func playTheSpaceSound(){
        forestSoundsPlayer = ResourceAudioPlayer(fromName: "space")
        forestSoundsPlayer.volume = 0.4
        forestSoundsPlayer.numberOfLoops = -1
        forestSoundsPlayer.play()
    }
    
	
	fileprivate func playTheForestSounds(){
		forestSoundsPlayer = ResourceAudioPlayer(fromName: "forestsounds")
		forestSoundsPlayer.volume = 0.3
		forestSoundsPlayer.numberOfLoops = -1
		forestSoundsPlayer.play()
	}
	
	
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
		//Crashlytics.startWithAPIKey("9151a746d6d01e3cf7ec2a3254ebb0c672760333")
		synth = AVSpeechSynthesizer()
		var v2 = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == "en-US" }
		preferredVoice = (v2[0] )
        InAppPurchaseManager.sharedInstance.requestProductInfo()
		return true
	}
    
    var animationProgress:UIProgressView?
    var foodProgress:UIProgressView?
    
    func resetAll(_ progress:UIProgressView?, text:UILabel?, done:@escaping ()->Void){
        text?.text = "Deleting rewards"
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        uow.saveChanges()
        text?.text = "Deleting animations"
        deleteAllAnimations()
        text?.text = "Deleting available rewards"
        deleteAllRewardsInPool()
        text?.text = "Deleting food"
        deleteAllFood()
        let c = uow.animationRepository!.count()
        let c2 = uow.rewardPoolRepository!.count()
        let c3 = uow.rewardRepository!.count()
        
        checkForUpdates(progress, text: text, done: done)
    }
    
    func checkForUpdates(_ progress:UIProgressView?, text:UILabel?, done:@escaping ()->Void){
        let uow = UnitOfWork()
        uow.rewardRepository?.deleteAllRewards()
        uow.saveChanges()
        text?.text = "Downloading food updates"
        
        
        downloadFood(progress) { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                text?.text = "Downloading animation updates"
            })
            self.downloadAnimations(progress, done: { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    text?.text = "Downloading reward updates"
                })
                self.downloadRewards(progress, done: { () -> Void in
                    done()
                })
            })
        }
    }
    
    func downloadAnimations(_ progress:UIProgressView?, done:@escaping () -> Void){
        let api = AleApi()
        progress?.setProgress(0, animated: true)
        var i:Float = 0
        
        let animations = api.listAnimations()
            for animation in animations{
                let uow = UnitOfWork()
                var dAnimation:DAnimation?
                dAnimation = (uow.animationRepository?.animationByName(animation.name))
                if dAnimation == nil || dAnimation?.version?.intValue < animation.version{
                    if dAnimation == nil{
                        dAnimation = (uow.animationRepository?.createNewAnimation())
                    }
                    dAnimation!.name = animation.name
                    dAnimation!.atlas = animation.atlas
                    dAnimation!.json = animation.json
                    dAnimation!.texture = animation.texture
                    dAnimation!.rewardImage = animation.rewardImage
                    dAnimation!.version = animation.version as NSNumber?
                    uow.saveChanges()
                    let ad = AtlasDownloader(url: animation.atlas, name: animation.name)
                    self.downloadQueue.addOperation(ad)
                    let jd = JsonDownloader(url: animation.json, name: animation.name)
                    self.downloadQueue.addOperation(jd)
                    let rid = ImageDownloader(url: animation.rewardImage, name: animation.name + "RewardImage")
                    self.downloadQueue.addOperation(rid)
                    let td = ImageDownloader(url: animation.texture, name: animation.name)
                    td.completionBlock = {
                        i += 1
                        DispatchQueue.main.async(execute: { () -> Void in
                            progress?.setProgress(i / Float(animations.count), animated: true)
                        })
                        if i == Float(animations.count){
                            done()
                        }
                    }
                    self.downloadQueue.addOperation(td)
                }else{
                    i += 1
                    progress?.setProgress(i / Float(animations.count), animated: true)
                    if i == Float(animations.count){
                        done()
                    }
                }
        }
    }

    func downloadFood(_ progress:UIProgressView?, done:@escaping ()->Void){
        let api = AleApi()
        progress?.setProgress(0, animated: true)
        var i:Float = 0
        let foods = api.listFood()
            for food in foods{
                let uow = UnitOfWork()
                var dFood:DFood?
                dFood = uow.foodRepository?.getFood(byName: food.name)
                if dFood == nil || dFood?.version?.intValue < food.version{
                    if dFood == nil{
                        dFood = uow.foodRepository?.createNewFood()
                    }
                    dFood!.colour = food.colour
                    dFood!.name = food.name
                    dFood!.free = food.free as NSNumber?
                    dFood!.visible = true
                    dFood!.version = food.version as NSNumber?
                    uow.saveChanges()
                    let id = ImageDownloader(url: food.image, name: food.name)
                    self.downloadQueue.addOperation(id)
                    let sd = SoundDownloader(url: food.sound, name: food.name)
                    sd.completionBlock = {
                        i += 1
                        DispatchQueue.main.async(execute: { () -> Void in
                            progress?.setProgress(i / Float(foods.count), animated: true)
                        })
                        if i == Float(foods.count){
                            done()
                        }
                    }
                    self.downloadQueue.addOperation(sd)
                }else{
                    i += 1
                    DispatchQueue.main.async(execute: { () -> Void in
                        progress?.setProgress(i / Float(foods.count), animated: true)
                    })
                    if i == Float(foods.count){
                        done()
                    }
                }
            }
            
    }
    
    func downloadRewards(_ progress:UIProgressView?, done:@escaping () -> Void){
        let api = AleApi()
        progress?.setProgress(0, animated: true)
        var i:Float = 0
        let rewards = api.listRewards()
            for reward in rewards{
                let uow = UnitOfWork()
                let dRewardPool:DRewardPool! = uow.rewardPoolRepository?.createNewRewardPool()
                dRewardPool.rewardName = reward.name
                dRewardPool.imageName = reward.animation
                dRewardPool.scale = 0.1
                dRewardPool.available = true
                dRewardPool.level = (reward.level as NSString).integerValue as NSNumber?
                dRewardPool.positionX = reward.x as NSNumber?
                dRewardPool.positionY = reward.y as NSNumber?
                dRewardPool.scale = reward.scale as NSNumber?
                dRewardPool.scene = reward.scene
                uow.saveChanges()
                i += 1
                DispatchQueue.main.async(execute: { () -> Void in
                    progress?.setProgress(i / Float(rewards.count), animated: true)
                })
            }
            done()
    }
    
    func deleteAllRewardsInPool(){
        let uow = UnitOfWork()
        let rewards = uow.rewardPoolRepository?.getAllRewardsInPool()
        for reward in rewards! {
            uow.rewardPoolRepository?.deleteReward(reward!)
        }
        uow.saveChanges()
    }
    
    func deleteAllAnimations(){
        let uow = UnitOfWork()
        let animations = uow.animationRepository?.getAllAnimation()
        for animation in animations!{
            uow.animationRepository?.deleteAnimation(animation!)
        }
        uow.saveChanges()
    }
    
    func deleteAllFood(){
        let uow = UnitOfWork()
        let foods = uow.foodRepository?.getAllFood()
        for food in foods!{
            uow.foodRepository?.deleteFood(food!)
        }
        uow.saveChanges()
    }
	
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	
	// MARK: - Core Data stack
	
	lazy var applicationDocumentsDirectory: URL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "com.readysteadyrainbow.test2" in the application's documents Application Support directory.
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count-1] 
		}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = Bundle.main.url(forResource: "AleModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
		}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.appendingPathComponent("AleModel.sqlite")
		var error: NSError? = nil
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true])
		} catch var error1 as NSError {
			error = error1
			coordinator = nil
			// Report any error we got.
			let dict = NSMutableDictionary()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
			dict[NSLocalizedFailureReasonErrorKey] = failureReason
			dict[NSUnderlyingErrorKey] = error
            //error = NSError(domain: "", code: 9999, userInfo: dict)
			
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: [:])
            
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(error), \(error!.userInfo)")
			abort()
		} catch {
			fatalError()
		}
		
		return coordinator
		}()
	
	lazy var managedObjectContext: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		if coordinator == nil {
			return nil
		}
		var managedObjectContext = NSManagedObjectContext()
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
		}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		if let moc = self.managedObjectContext {
			var error: NSError? = nil
			if moc.hasChanges {
				do {
					try moc.save()
				} catch let error1 as NSError {
					error = error1
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					NSLog("Unresolved error \(error), \(error!.userInfo)")
					abort()
				}
			}
		}
	}
	
}

