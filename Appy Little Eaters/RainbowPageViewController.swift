//
//  RainbowPageViewController.swift
//  Appy Little Eaters
//
//  Created by Russell Stather on 11/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



@objc
open class RainbowPageViewController: UIViewController{
	
    @IBOutlet weak var Cloud1: Cloud1View!
    @IBOutlet weak var Cloud2: Cloud2View!
	@IBOutlet weak var RedBand: UIImageView!
	@IBOutlet weak var OrangeBand: UIImageView!
	@IBOutlet weak var YellowBand: UIImageView!
	@IBOutlet weak var GreenBand: UIImageView!
	@IBOutlet weak var BrownBand: UIImageView!
	@IBOutlet weak var PurpleBand: UIImageView!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var Plane: ParentsrewardView!
	
	open var colour: Int = 0
	open var foodEaten: Bool = false
	var theBand:UIImageView!
	var theColour:NSString!
	var player:ResourceAudioPlayer!
	var allowColouring:Bool = false
	var alphaLevel:CGFloat = 0
	var lastPoint:CGPoint!
	let circleSize:CGFloat = 100
	var bandComplete:Bool = false
    var counting:Bool = false
    var segued:Bool = false
    var paintColour:UIColor!
    var RainbowComplete:Bool = false
	
    func fillBand(_ bandView:UIImageView, colour:UIColor){
        let image:UIImage = bandView.image!
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let r2 = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        context?.setBlendMode(CGBlendMode.sourceIn)
        context?.setFillColor(colour.cgColor)
        context?.setLineCap(CGLineCap.round)
        context?.fill(r2)
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        bandView.image = im2
        bandView.setNeedsDisplay()
    }
	
	func drawAt(_ point: CGPoint){
		let r = theBand.bounds
		let image:UIImage = theBand.image!
		let imageWidth = image.size.width
		let imageHeight = image.size.height
		let xfact = imageWidth / r.width
		let yfact = imageHeight / r.height
		let x = point.x * xfact
		let y = point.y * yfact
		let newPoint = CGPoint(x: x, y: y)
		UIGraphicsBeginImageContext(image.size)
		image.draw(at: CGPoint.zero)
		let context = UIGraphicsGetCurrentContext()
		context?.setBlendMode(CGBlendMode.sourceIn)
//		var colour = UIColor.redColor()
		context?.setStrokeColor(paintColour.cgColor)
		context?.setLineCap(CGLineCap.round)
		let rect = CGRect(x: (newPoint.x - (circleSize/2)), y: (newPoint.y - (circleSize/2)), width: circleSize, height: circleSize)
		context?.setFillColor(paintColour.cgColor)
		context?.fillEllipse(in: rect)
		//CGContextSetLineWidth(context, 15)
		//CGContextMoveToPoint(context, 0, 0)
		//CGContextAddLineToPoint(context, point.x, point.y)
		//CGContextStrokePath(context)
		let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		theBand.image = im2
		theBand.setNeedsDisplay()
	}

	func countRed(){
    
		var sizew = theBand.image!.size.width
		var sizeh = theBand.image!.size.height
		sizew /= 10
		sizeh /= 10
		let s = CGSize(width: sizew, height: sizeh)
		UIGraphicsBeginImageContext(s)
		theBand.image!.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: s))
        var i = UIGraphicsGetImageFromCurrentImageContext()
		let newImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
		UIGraphicsEndImageContext()
		
	
		
		let provider = newImage?.dataProvider
		let bitmapData = provider?.data
		var data = CFDataGetBytePtr(bitmapData)
		let width = newImage?.width
		let height = newImage?.height
		var total = width! * height!
		var white = 0
		var nonwhite = 0
		while total > 0{
			total -= 1
			let vr = Float((data?[0])!)/255.0
			let r = CGFloat(vr)
			let vg = Float((data?[1])!)/255.0
			let g = CGFloat(vg)
			let vb = Float((data?[2])!)/255.0
			let b = CGFloat(vb)
			if r == 1 && g == 1 && b == 1 {
				white += 1
			}else if r > 0 || g > 0 || b > 0 {
				nonwhite += 1
			}
			data = data! + 4
			_ = UIColor(red: r, green: g, blue: b, alpha: 1.0)
		}
		if white > 0 && nonwhite / white > 18{
			print("Done so lets segue")
			bandComplete = true
		}
        i = nil
		print("white: " + white.description + " nonwhite: " + nonwhite.description)
	}
	
	@IBAction func RedBandPanned(_ sender: UIPanGestureRecognizer) {
		if bandComplete && !segued{
            segued = true
            if RainbowComplete {
                DoThePlane()
            }else{
                performSegue(withIdentifier: "RainbowToReward", sender: self);
            }
			return
		}
		if !allowColouring{
			return
		}
		if sender.numberOfTouches > 0 {
			let p = sender.location(ofTouch: 0, in: theBand)
			drawAt(p)
            if (counting){
                print("Already counting")
                return
            }
            counting = true
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.countRed()
                self.counting = false
            }
		}
		
		
	}
	
	
	
	@IBAction func tapped(_ sender: UITapGestureRecognizer) {
		/*
		theBand.hidden = false;
		theBand.alpha = 1.0;
		UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {
			UIView.setAnimationRepeatCount(5);
			self.theBand.alpha = 0;
			}, completion:{(Bool finished)-> Void in
				self.theBand.alpha = 1.0
				self.performSegueWithIdentifier("RainbowToReward", sender: self);
		});
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: theColour);
*/
	}
	
	
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
    
    open override func viewDidAppear(_ animated: Bool) {
//        if foodEaten{
//            fillBand(theBand, colour: paintColour)
//            theBand.startGlowingWithColor(UIColor.redColor(), intensity: 1.0)
//        }
        //home.startGlowing()
    }
    
    func drawText(_ text:NSString, inImage:UIImage, atPoint:CGPoint) -> UIImage{
        // Setup the font specific variables
        let textColor: UIColor = UIColor.red
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 36)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        
        //Now Draw the text into an image.
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
        
    }
    
    func DoThePlane() -> Void {
        let pview:UIImageView = Plane.viewsByName["Airplane-01"] as! UIImageView
        let rewardText = UserDefaults.standard.string(forKey: "SpecialReward")
        if rewardText != nil && rewardText?.characters.count > 0{
            let newimage = drawText(rewardText! as NSString, inImage: pview.image!, atPoint: CGPoint(x: 350,y: 75))
            pview.image = newimage
            Plane.addSwayAnimation({ (Bool) -> Void in
                UserDefaults.standard.set(false, forKey: "RED")
                UserDefaults.standard.set(false, forKey: "ORANGE")
                UserDefaults.standard.set(false, forKey: "YELLOW")
                UserDefaults.standard.set(false, forKey: "GREEN")
                UserDefaults.standard.set(false, forKey: "BROWN")
                UserDefaults.standard.set(false, forKey: "PURPLE")
                UserDefaults.standard.setValue("", forKey: "SpecialReward")
                self.performSegue(withIdentifier: "RainbowToReward", sender: self);
            })
        }else{
            self.performSegue(withIdentifier: "RainbowToReward", sender: self);
        }
    }
    
    func DoThePlaneForever() -> Void {
        let pview:UIImageView = Plane.viewsByName["Airplane-01"] as! UIImageView
        let rewardText = UserDefaults.standard.string(forKey: "SpecialReward")
        if rewardText != nil && rewardText?.characters.count > 0{
            let newimage = drawText(rewardText! as NSString, inImage: pview.image!, atPoint: CGPoint(x: 350,y: 75))
            pview.image = newimage
            Plane.addSwayAnimation()
        }
    }
    
	
	open override func viewWillAppear(_ animated: Bool) {
        Cloud1.addSwayAnimation()
        Cloud2.addSwayAnimation()
        var NumberOfBands = 0

        if (UserDefaults.standard.bool(forKey: "RED")){
			RedBand.isHidden = false
            RedBand.alpha = 1.0
            fillBand(RedBand, colour: UIColor(red: 216/256, green: 73/256, blue: 69/256, alpha: 1))
            NumberOfBands += 1
		}
		if (UserDefaults.standard.bool(forKey: "ORANGE")){
			OrangeBand.isHidden = false
            OrangeBand.alpha = 1.0
            fillBand(OrangeBand, colour: UIColor(red: 234/256, green: 156/256, blue: 52/256, alpha: 1))
            NumberOfBands += 1
		}
		if (UserDefaults.standard.bool(forKey: "YELLOW")){
			YellowBand.isHidden = false
            YellowBand.alpha = 1.0
            fillBand(YellowBand, colour: UIColor(red: 249/256, green: 237/256, blue: 98/256, alpha: 1))
            NumberOfBands += 1
		}
		if (UserDefaults.standard.bool(forKey: "GREEN")){
			GreenBand.isHidden = false
            GreenBand.alpha = 1.0
            fillBand(GreenBand, colour: UIColor(red: 163/256, green: 207/256, blue: 97/256, alpha: 1))
            NumberOfBands += 1
		}
		if (UserDefaults.standard.bool(forKey: "BROWN")){
			BrownBand.isHidden = false
            BrownBand.alpha = 1.0
            fillBand(BrownBand, colour: UIColor(red: 147/256, green: 103/256, blue: 72/256, alpha: 1))
            NumberOfBands += 1
		}
		if (UserDefaults.standard.bool(forKey: "PURPLE")){
			PurpleBand.isHidden = false
            PurpleBand.alpha = 1.0
            fillBand(PurpleBand, colour: UIColor(red: 65/256, green: 83/256, blue: 191/256, alpha: 1))
            NumberOfBands += 1
		}
        if NumberOfBands == 6{
            RainbowComplete = true
            if !foodEaten {
                DoThePlaneForever()
            }
        }
		if (foodEaten){
			switch colour
				{
			case 0:
				theBand = RedBand
				theColour = "RED"
                paintColour = UIColor(red: 216/256, green: 73/256, blue: 69/256, alpha: 1)
                if (!UserDefaults.standard.bool(forKey: "RED")){
                    NumberOfBands += 1;
                }
				break;
			case 1:
				theBand = OrangeBand
				theColour = "ORANGE"
                paintColour = UIColor(red: 234/256, green: 156/256, blue: 52/256, alpha: 1)
                if (!UserDefaults.standard.bool(forKey: "ORANGE")){
                    NumberOfBands += 1;
                }
				break;
			case 2:
				theBand = YellowBand
				theColour = "YELLOW"
                paintColour = UIColor(red: 249/256, green: 237/256, blue: 98/256, alpha: 1)
                if (!UserDefaults.standard.bool(forKey: "YELLOW")){
                    NumberOfBands += 1;
                }
				break;
			case 3:
				theBand = GreenBand
				theColour = "GREEN"
                paintColour = UIColor(red: 163/256, green: 207/256, blue: 97/256, alpha: 1)
                if (!UserDefaults.standard.bool(forKey: "GREEN")){
                    NumberOfBands += 1;
                }
				break;
			case 4:
				theBand = BrownBand
				theColour = "BROWN"
                paintColour = UIColor(red: 147/256, green: 103/256, blue: 72/256, alpha: 1)
                if (!UserDefaults.standard.bool(forKey: "BROWN")){
                    NumberOfBands += 1;
                }
				break;
			case 5:
				theBand = PurpleBand
				theColour = "PURPLE"
                paintColour = UIColor(red: 65/256, green: 83/256, blue: 191/256, alpha: 1)
                if (!UserDefaults.standard.bool(forKey: "PURPLE")){
                    NumberOfBands += 1;
                }
				break;
			default:
				return;
			}
            if NumberOfBands == 6{
                RainbowComplete = true
            }
            UserDefaults.standard.set(true, forKey: theColour as String)
			theBand.isHidden = false
			theBand.alpha = 1.0
            fillBand(theBand, colour: paintColour)
			UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.autoreverse, animations: {UIView.setAnimationRepeatCount(5);self.theBand.alpha = 0;}, completion:{
				(finished)-> Void in
				self.allowColouring = true
				self.theBand.alpha = 1
				self.theBand.isHidden = false
                self.fillBand(self.theBand, colour: UIColor.white)
			});

		}else{
			player = ResourceAudioPlayer(fromName: "myfoodrainbow")
			player.play()
			
		}
	}
	
}
