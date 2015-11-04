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
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var ukeplayer:ResourceAudioPlayer!
	var forestSoundsPlayer:ResourceAudioPlayer!
	var synth:AVSpeechSynthesizer?
	var preferredVoice:AVSpeechSynthesisVoice?
	
	func speak(text: String){
		let utter:AVSpeechUtterance = AVSpeechUtterance(string: text)
		utter.rate = AVSpeechUtteranceMinimumSpeechRate
		utter.voice = preferredVoice
		synth?.speakUtterance(utter)
		
	}

	func playTheUke(){
		ukeplayer = ResourceAudioPlayer(fromName: "uke1_01")
		ukeplayer.volume = 0.2
		ukeplayer.numberOfLoops = -1
		ukeplayer.play()
	}
	
	func stopTheUke(){
		ukeplayer.stop()
	}
	
	func playTheForestSounds(){
		forestSoundsPlayer = ResourceAudioPlayer(fromName: "forestsounds")
		forestSoundsPlayer.volume = 0.3
		forestSoundsPlayer.numberOfLoops = -1
		forestSoundsPlayer.play()
	}
	
	func stopTheForestSounds(){
		forestSoundsPlayer.stop()
	}
	
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
        Fabric.with([Crashlytics()])
		Crashlytics.startWithAPIKey("9151a746d6d01e3cf7ec2a3254ebb0c672760333")
		synth = AVSpeechSynthesizer()
		var v2 = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == "en-US" }
		preferredVoice = (v2[0] )
        InAppPurchaseManager.sharedInstance.requestProductInfo()
		return true
	}
    
    var animationProgress:UIProgressView?
    var foodProgress:UIProgressView?
    
    func downloadAnimations(progress:UIProgressView?){
        let api = AleApi()
        progress?.setProgress(0, animated: false)
        var i:Float = 0
        
        api.listAnimations { (animations) -> Void in
            for animation in animations{
                let uow = UnitOfWork()
                let dAnimation:DAnimation! = uow.animationRepository?.createNewAnimation()
                dAnimation.name = animation.name
                dAnimation.atlas = animation.atlas
                dAnimation.json = animation.json
                dAnimation.texture = animation.texture
                dAnimation.rewardImage = animation.rewardImage
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
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        progress?.setProgress(i / Float(animations.count), animated: false)
                    })
                }
                self.downloadQueue.addOperation(td)
            }
            
        }
    }
    
    func downloadFood(progress:UIProgressView?){
        let api = AleApi()
        progress?.setProgress(0, animated: false)
        var i:Float = 0
        api.listFood { (foods) -> Void in
            for food in foods{
                let uow = UnitOfWork()
                let dFood:DFood! = uow.foodRepository?.createNewFood()
                dFood.colour = food.colour
                dFood.name = food.name
                dFood.free = food.free
                dFood.visible = true
                uow.saveChanges()
                let id = ImageDownloader(url: food.image, name: food.name)
                self.downloadQueue.addOperation(id)
                let sd = SoundDownloader(url: food.sound, name: food.name)
                sd.completionBlock = {
                    i += 1
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        progress?.setProgress(i / Float(foods.count), animated: false)
                    })
                }
                self.downloadQueue.addOperation(sd)
            }
            
        }
    }
    
    func downloadRewards(progress:UIProgressView?){
        let api = AleApi()
        progress?.setProgress(0, animated: false)
        var i:Float = 0
        api.listRewardss { (rewards) -> Void in
            for reward in rewards{
                let uow = UnitOfWork()
                let dRewardPool:DRewardPool! = uow.rewardPoolRepository?.createNewRewardPool()
                dRewardPool.rewardName = reward.name
                dRewardPool.imageName = reward.animation
                dRewardPool.scale = 0.1
                dRewardPool.available = true
                dRewardPool.level = Int(reward.level)
                dRewardPool.positionX = reward.x
                dRewardPool.positionY = reward.y
                dRewardPool.scale = reward.scale
                uow.saveChanges()
                i += 1
                progress?.setProgress(i / Float(rewards.count), animated: false)
            }
        }
    }
    
    func deleteAllRewardsInPool(){
        let uow = UnitOfWork()
        let rewards = uow.rewardPoolRepository?.getAllRewardsInPool()
        for reward in rewards! {
            uow.rewardPoolRepository?.deleteReward(reward)
        }
        uow.saveChanges()
    }
    
    func deleteAllAnimations(){
        let uow = UnitOfWork()
        let animations = uow.animationRepository?.getAllAnimation()
        for animation in animations!{
            uow.animationRepository?.deleteAnimation(animation)
        }
        uow.saveChanges()
    }
    
    func deleteAllFood(){
        let uow = UnitOfWork()
        let foods = uow.foodRepository?.getAllFood()
        for food in foods!{
            uow.foodRepository?.deleteFood(food)
        }
        uow.saveChanges()
    }
	
	func seedDatabase(){
        return
		let fetchAllRewards = managedObjectModel.fetchRequestTemplateForName("FetchAllRewardsInPool")
		let error:NSErrorPointer = NSErrorPointer()
		let c = managedObjectContext?.countForFetchRequest(fetchAllRewards!, error: error)
		if c > 0{
			return
		}
		let fname = NSBundle.mainBundle().pathForResource("rewards", ofType: "csv")
		var data: NSString!
		do {
			data = try NSString(contentsOfFile: fname!, encoding: NSUTF8StringEncoding)
		} catch let error1 as NSError {
			error.memory = error1
			data = nil
		}
        let lines:[String] = data.componentsSeparatedByString("\n")
        
		//let lines:[String!] = data.componentsSeparatedByString("\n") as! [String!]
		for item in lines{
			var fields:[String] = item.componentsSeparatedByString(",")
			if fields.count >= 6 {
				let reward = NSEntityDescription.insertNewObjectForEntityForName("DRewardPool", inManagedObjectContext: managedObjectContext!) as! DRewardPool
			
				reward.creatureName = Int(fields[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
				reward.positionX = Int(fields[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
				reward.positionY = Int(fields[3].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
				reward.imageName = fields[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
				reward.level = Int(fields[4].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
				let scale = fields[5].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
				let fscale = (scale as NSString).floatValue
				reward.scale = fscale
				print("Loaded " + reward.creatureName!.stringValue)
			}
		}
		do {
			try managedObjectContext?.save()
		} catch let error1 as NSError {
			error.memory = error1
		}
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	
	// MARK: - Core Data stack
	
	lazy var applicationDocumentsDirectory: NSURL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "com.readysteadyrainbow.test2" in the application's documents Application Support directory.
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.count-1] 
		}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = NSBundle.mainBundle().URLForResource("AleModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
		}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("AleModel.sqlite")
		var error: NSError? = nil
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true])
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

