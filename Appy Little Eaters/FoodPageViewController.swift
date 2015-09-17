//
//  FoodPageViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 12/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData


public class FoodPageViewController : UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate{

	public enum FoodColour:Int{
		case red = 0, orange, yellow, green, white, purple
	}
	
	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}

	@IBOutlet weak public var mainView: UIView!
	@IBOutlet weak public var theCollection: UICollectionView!
	@IBOutlet weak public var backgroundImage: UIImageView!
	
	public var index:NSInteger = 0
	var foods:NSArray!
	@IBOutlet weak public var selectedFoodImage: UIImageView!
	@IBOutlet weak public var tick: UIButton!
	@IBOutlet weak public var cross: UIButton!
	var player:ResourceAudioPlayer!
	var endOfPlayAction:Int!
	
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    lazy var managedObjectModel : NSManagedObjectModel? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectModel
        }()

    func getFoodForColour(c:String) -> NSArray {
        let f = NSMutableArray()
        let fetchFoodByColour = managedObjectModel?.fetchRequestFromTemplateWithName("FetchFoodByColour", substitutionVariables: ["COLOUR":c])

        for item in (try! managedObjectContext?.executeFetchRequest(fetchFoodByColour!)) as! [DFood]{
            f.addObject(item.name)
        }
        return f
    }
	
	override public func viewDidLoad() {
		self.selectedFoodImage.hidden = true;
		self.tick.hidden = true;
		self.cross.hidden = true;
		
		super.viewDidLoad();
		self.theCollection.backgroundColor = UIColor.clearColor();
		self.theCollection.backgroundView = UIView(frame: CGRectZero)
		
		let lc:NSLayoutConstraint = NSLayoutConstraint(item: self.theCollection, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Height, multiplier: 0.333, constant: 0)
		self.mainView.addConstraint(lc)
		
		var filepath:String!
		
		switch (self.index){
		case FoodColour.red.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("red-background", ofType: "jpg")
            foods = getFoodForColour("Red")
			break;
		case FoodColour.orange.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("orange-background", ofType: "jpg")
            foods = getFoodForColour("Orange")
			break;
		case FoodColour.yellow.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("yellow-background", ofType: "jpg")
            foods = getFoodForColour("Yellow")
			break;
		case FoodColour.green.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("green-background", ofType: "jpg")
            foods = getFoodForColour("Green")
			break;
		case FoodColour.white.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("white-background", ofType: "jpg")
            foods = getFoodForColour("White")
			break;
		case FoodColour.purple.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("purple-background", ofType: "jpg")
            foods = getFoodForColour("Purple")
			break;
		default:
			return;
		}
		self.backgroundImage.image = UIImage(contentsOfFile: filepath)
		player = ResourceAudioPlayer(fromName: "yummyfoods")
		player.play()
	
	}
	
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return foods.count
	}
    
    func loadFood(name:String) -> UIImage{
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        let bundleID:String = NSBundle.mainBundle().bundleIdentifier!
        
        let possibleURLS:NSArray = fileManager.URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let appSupportDir:NSURL = possibleURLS[0] as! NSURL
        let dirPath = appSupportDir.URLByAppendingPathComponent(bundleID)
        let filename = dirPath.URLByAppendingPathComponent(name + "." + "png")
        let filepath = filename.path
        let image:UIImage = UIImage(contentsOfFile: filepath as String!)!
        return image;
        
    }
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell:FoodCell = collectionView.dequeueReusableCellWithReuseIdentifier("FoodCell", forIndexPath: indexPath) as! FoodCell
		cell.backgroundColor = UIColor.whiteColor()
		let index:NSInteger = indexPath.item
		let name:NSString = foods.objectAtIndex(index) as! NSString
		cell.foodImage.image = loadFood(name as String)
		cell.foodImage.backgroundColor = UIColor.clearColor()
		cell.backgroundColor = UIColor.clearColor()
		cell.backgroundView = UIView(frame: CGRectZero)
		return cell;
	}

	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let index:Int = indexPath.item
		let name:String = foods.objectAtIndex(index) as! String
		self.selectedFoodImage.image = loadFood(name)
		self.selectedFoodImage.hidden = false;
		self.theCollection.hidden = true;
		self.tick.hidden = false;
		self.cross.hidden = false;
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.speak("Have you eaten a " + name)
		
		//player = ResourceAudioPlayer(fromName: name)
		//player.play()
		
	}
	
	public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let height = self.theCollection.bounds.size.height;
		return CGSizeMake(height, height);
	}
	
	public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 0, 0, 0);
		
	}
	
	@IBAction func crossClicked(sender: AnyObject){
		self.endOfPlayAction = 0;
		player = ResourceAudioPlayer(fromName: "NOIHAVENOTEATEN")
		player.delegate = self
		player.play()
	}
	
	public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
		if (self.endOfPlayAction == 0)
		{
			self.selectedFoodImage.hidden = true;
			self.theCollection.hidden = false;
			self.tick.hidden = true;
			self.cross.hidden = true;
			
		}
		else if (self.endOfPlayAction == 1)
		{
			self.selectedFoodImage.hidden = true;
			self.theCollection.hidden = false;
			self.tick.hidden = true;
			self.cross.hidden = true;
			performSegueWithIdentifier("ToRainbowFromFood", sender: self)
		}
		
	}
	
	@IBAction func tickClicked(sender: AnyObject){
		self.endOfPlayAction = 1;
		player = ResourceAudioPlayer(fromName: "YESIHAVEEATEN")
		player.delegate = self
		player.play()
	}
	
	override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.destinationViewController.isKindOfClass(RainbowPageViewController){
			let vc:RainbowPageViewController = segue.destinationViewController as! RainbowPageViewController
			vc.colour = index
			vc.foodEaten = true
		}
		
		
	}
	
}
