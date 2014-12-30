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


public class FoodPageViewController : UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate{

	public enum FoodColour:Int{
		case red = 0, orange, yellow, green, white, purple
	}
	
	required public init(coder aDecoder: NSCoder) {
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
	
	
	override public func viewDidLoad() {
		self.selectedFoodImage.hidden = true;
		self.tick.hidden = true;
		self.cross.hidden = true;
		
		super.viewDidLoad();
		self.theCollection.backgroundColor = UIColor.clearColor();
		self.theCollection.backgroundView = UIView(frame: CGRectZero)
		
		var lc:NSLayoutConstraint = NSLayoutConstraint(item: self.theCollection, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Height, multiplier: 0.333, constant: 0)
		self.mainView.addConstraint(lc)
		
		var filepath:String!
		
		switch (self.index){
		case FoodColour.red.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("red-background", ofType: "jpg")
			foods = NSArray(objects: "apple", "cherry", "raspberry", "redpepper", "strawberry", "tomato", "watermelon", "beetroot", "cranberries", "mystery_box", "persimmon", "pomegranate", "raddish", "red_onion", "red_potato", "rhubarb", "ruby_grapefruit")
			break;
		case FoodColour.orange.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("orange-background", ofType: "jpg")
			foods = NSArray(objects: "apricots", "carrot", "mango", "orange", "pumpkin", "pawpaw", "peach", "butternut", "mystery_box", "cantaloupe", "gem_squash", "gooseberries", "nectarine", "tangerine")
			break;
		case FoodColour.yellow.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("yellow-background", ofType: "jpg")
			foods = NSArray(objects: "banana", "corn", "lemon", "pear", "pineapple", "mystery_box", "yellowapple", "yellowpepper", "egg", "yellow_grapefruit", "yellow_watermelon")
			break;
		case FoodColour.green.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("green-background", ofType: "jpg")
			foods = NSArray(objects: "broccoli", "cucumber", "greenapple", "greengrapes", "lime", "peas", "sprouts", "asparagus", "celery", "honeydew", "mystery_box", "kale", "kiwifruit", "leek", "lettuce", "green_beans", "mustard_greens", "ocra", "peas", "spinach", "spring_onions", "swiss_chard")
			break;
		case FoodColour.white.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("white-background", ofType: "jpg")
			foods = NSArray(objects: "cauliflower", "chicken", "dates", "lentils", "nuts", "mystery_box", "potato", "whitecabbage", "egg")
			break;
		case FoodColour.purple.rawValue:
			filepath = NSBundle.mainBundle().pathForResource("purple-background", ofType: "jpg")
			foods = NSArray(objects: "blackberry", "eggplant", "grapes", "mystery_box", "olives", "plum", "raisins", "redcabbage", "radiccio", "sweet_potato")
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
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell:FoodCell = collectionView.dequeueReusableCellWithReuseIdentifier("FoodCell", forIndexPath: indexPath) as FoodCell
		cell.backgroundColor = UIColor.whiteColor()
		var index:NSInteger = indexPath.item
		var name:NSString = foods.objectAtIndex(index) as NSString
		var filepath:NSString = NSBundle.mainBundle().pathForResource(name, ofType: "png")!
		var image:UIImage = UIImage(contentsOfFile: filepath)!
		cell.foodImage.image = image;
		cell.foodImage.backgroundColor = UIColor.clearColor()
		cell.backgroundColor = UIColor.clearColor()
		cell.backgroundView = UIView(frame: CGRectZero)
		return cell;
	}
	
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var index:Int = indexPath.item
		var name:String = foods.objectAtIndex(index) as String
		var filepath = NSBundle.mainBundle().pathForResource(name, ofType: "png")
		var image:UIImage = UIImage(contentsOfFile: filepath!)!
		self.selectedFoodImage.image = image
		self.selectedFoodImage.hidden = false;
		self.theCollection.hidden = true;
		self.tick.hidden = false;
		self.cross.hidden = false;
		
		player = ResourceAudioPlayer(fromName: name)
		player.play()
		
	}
	
	public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		var height = self.theCollection.bounds.size.height;
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
	
	public func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
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
			var vc:RainbowPageViewController = segue.destinationViewController as RainbowPageViewController
			vc.colour = index
			vc.foodEaten = true
		}
		
		
	}
	
}
