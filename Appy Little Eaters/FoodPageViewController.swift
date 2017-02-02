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


open class FoodPageViewController : UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate, InAppPurchaseDelegate{
    @IBOutlet weak var BuyFoodsButton: UIButton!

	public enum FoodColour:Int{
		case red = 0, orange, yellow, green, white, purple
	}
	
	required public init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}

	@IBOutlet weak open var mainView: UIView!
	@IBOutlet weak open var theCollection: UICollectionView!
	@IBOutlet weak open var backgroundImage: UIImageView!
	
	open var index:NSInteger = 0
	var foods:NSArray!
	@IBOutlet weak open var selectedFoodImage: UIImageView!
	@IBOutlet weak open var tick: UIButton!
	@IBOutlet weak open var cross: UIButton!
	var player:AVAudioPlayer?
	var endOfPlayAction:Int!
	
    
    @IBAction func BuyFoods(_ sender: AnyObject) {
        let pg = ParentalGate.new { (success) in
            if success{
                InAppPurchaseManager.sharedInstance.BuyFood(self)
            }else{
                
            }
        }
        pg?.show()
    }
    
    open func FoodNotPurchased() {
        
        
    }
    
    open func FoodPurchased() {
        
        
    }
    
    func getFoodForColour(_ c:String) -> NSArray {

        let uow = UnitOfWork()
        var foods:[DFood]
        
        if InAppPurchaseManager.sharedInstance.allFoodsBought(){
            foods = (uow.foodRepository?.getVisibleFood(c))!
        }else{
            foods = (uow.foodRepository?.getFreeVisibleFood(c))!
        }
        let f = NSMutableArray()
        for item in foods{
            f.add(item.name!)
        }
        
        return f
    }
	
	override open func viewDidLoad() {
        
        if InAppPurchaseManager.sharedInstance.allFoodsBought(){
            BuyFoodsButton.isHidden = true
        }

        
		self.selectedFoodImage.isHidden = true
		self.tick.isHidden = true
		self.cross.isHidden = true
		
		super.viewDidLoad()
		self.theCollection.backgroundColor = UIColor.clear
		self.theCollection.backgroundView = UIView(frame: CGRect.zero)
		
		let lc:NSLayoutConstraint = NSLayoutConstraint(item: self.theCollection, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.height, multiplier: 0.333, constant: 0)
		self.mainView.addConstraint(lc)
		
		var filepath:String!
		
		switch (self.index){
		case FoodColour.red.rawValue:
			filepath = Bundle.main.path(forResource: "red-background", ofType: "jpg")
            foods = getFoodForColour("Red")
            player = ResourceAudioPlayer(fromName: "RED")
			break;
		case FoodColour.orange.rawValue:
			filepath = Bundle.main.path(forResource: "orange-background", ofType: "jpg")
            foods = getFoodForColour("Orange")
            player = ResourceAudioPlayer(fromName: "ORANGE")
			break;
		case FoodColour.yellow.rawValue:
			filepath = Bundle.main.path(forResource: "yellow-background", ofType: "jpg")
            foods = getFoodForColour("Yellow")
            player = ResourceAudioPlayer(fromName: "YELLOW")
			break;
		case FoodColour.green.rawValue:
			filepath = Bundle.main.path(forResource: "green-background", ofType: "jpg")
            foods = getFoodForColour("Green")
            player = ResourceAudioPlayer(fromName: "GREEN")
			break;
		case FoodColour.white.rawValue:
			filepath = Bundle.main.path(forResource: "white-background", ofType: "jpg")
            foods = getFoodForColour("White")
            player = ResourceAudioPlayer(fromName: "BROWN")
			break;
		case FoodColour.purple.rawValue:
			filepath = Bundle.main.path(forResource: "purple-background", ofType: "jpg")
            foods = getFoodForColour("Purple")
            player = ResourceAudioPlayer(fromName: "PURPLE")
			break;
		default:
			return;
		}
		self.backgroundImage.image = UIImage(contentsOfFile: filepath)
		player?.play()
	
	}
	
	
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return foods.count
	}
    
	
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell:FoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
		cell.backgroundColor = UIColor.white
		let index:NSInteger = indexPath.item
		let name:NSString = foods.object(at: index) as! NSString
		cell.foodImage.image = UnitOfWork().foodAssetRepository?.getFoodImage(name as String)
		cell.foodImage.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear
		cell.backgroundView = UIView(frame: CGRect.zero)
        cell.FoodLabel.text = name as String
		return cell;
	}

	open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let index:Int = indexPath.item
		let name:String = foods.object(at: index) as! String
		self.selectedFoodImage.image = UnitOfWork().foodAssetRepository?.getFoodImage(name as String)
		self.selectedFoodImage.isHidden = false;
		self.theCollection.isHidden = true;
		self.tick.isHidden = false;
		self.cross.isHidden = false;
		
		//let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		//appDelegate.speak("Have you eaten a " + name)
		
//		player = try! DownloadedAudioPlayer(fromName: name)
        player = ResourceAudioPlayer(fromName: name)
		player?.play()
		
	}
	
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height = self.theCollection.bounds.size.height;
		return CGSize(width: height, height: height);
	}
	
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 0, 0, 0);
		
	}
	
	@IBAction func crossClicked(_ sender: AnyObject){
		self.endOfPlayAction = 0;
		player = ResourceAudioPlayer(fromName: "NOIHAVENOTEATEN")
		player?.delegate = self
		player?.play()
	}
	
	open func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if (self.endOfPlayAction == 0)
		{
			self.selectedFoodImage.isHidden = true;
			self.theCollection.isHidden = false;
			self.tick.isHidden = true;
			self.cross.isHidden = true;
			
		}
		else if (self.endOfPlayAction == 1)
		{
			self.selectedFoodImage.isHidden = true;
			self.theCollection.isHidden = false;
			self.tick.isHidden = true;
			self.cross.isHidden = true;
			performSegue(withIdentifier: "ToRainbowFromFood", sender: self)
		}
		
	}
	
	@IBAction func tickClicked(_ sender: AnyObject){
		self.endOfPlayAction = 1;
		player = ResourceAudioPlayer(fromName: "YESIHAVEEATEN")
		player?.delegate = self
		player?.play()
	}
	
	override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination.isKind(of: RainbowPageViewController.self){
			let vc:RainbowPageViewController = segue.destination as! RainbowPageViewController
			vc.colour = index
			vc.foodEaten = true
		}
		
		
	}
	
}
