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


@objc
public class RainbowPageViewController: UIViewController{
	
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
	
	public var colour: Int = 0
	public var foodEaten: Bool = false
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
	
    func fillBand(bandView:UIImageView, colour:UIColor){
        let r = bandView.bounds
        let image:UIImage = bandView.image!
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let r2 = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        UIGraphicsBeginImageContext(image.size)
        
        image.drawAtPoint(CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetBlendMode(context, CGBlendMode.SourceIn)
        CGContextSetFillColorWithColor(context, colour.CGColor)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextFillRect(context, r2)
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        bandView.image = im2
        bandView.setNeedsDisplay()
    }
	
	func drawAt(point: CGPoint){
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
		image.drawAtPoint(CGPoint.zero)
		let context = UIGraphicsGetCurrentContext()
		CGContextSetBlendMode(context, CGBlendMode.SourceIn)
//		var colour = UIColor.redColor()
		CGContextSetStrokeColorWithColor(context, paintColour.CGColor)
		CGContextSetLineCap(context, CGLineCap.Round)
		let rect = CGRect(x: (newPoint.x - (circleSize/2)), y: (newPoint.y - (circleSize/2)), width: circleSize, height: circleSize)
		CGContextSetFillColorWithColor(context, paintColour.CGColor)
		CGContextFillEllipseInRect(context, rect)
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
    
		var cgImage = theBand.image?.CGImage
		
		var sizew = theBand.image!.size.width
		var sizeh = theBand.image!.size.height
		sizew /= 10
		sizeh /= 10
		let s = CGSize(width: sizew, height: sizeh)
		UIGraphicsBeginImageContext(s)
		theBand.image!.drawInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: s))
        var i = UIGraphicsGetImageFromCurrentImageContext()
		let newImage = UIGraphicsGetImageFromCurrentImageContext()?.CGImage
		UIGraphicsEndImageContext()
		
	
		
		let provider = CGImageGetDataProvider(newImage)
		let bitmapData = CGDataProviderCopyData(provider)
		var data = CFDataGetBytePtr(bitmapData)
		let width = CGImageGetWidth(newImage)
		let height = CGImageGetHeight(newImage)
		var total = width * height
		var white = 0
		var nonwhite = 0
		while total > 0{
			total--
			let vr = Float(data[0])/255.0
			let r = CGFloat(vr)
			let vg = Float(data[1])/255.0
			let g = CGFloat(vg)
			let vb = Float(data[2])/255.0
			let b = CGFloat(vb)
			if r == 1 && g == 1 && b == 1 {
				white += 1
			}else if r > 0 || g > 0 || b > 0 {
				nonwhite += 1
			}
			data += 4
			var returnColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
		}
		if white > 0 && nonwhite / white > 18{
			print("Done so lets segue")
			bandComplete = true
		}
        i = nil
		print("white: " + white.description + " nonwhite: " + nonwhite.description)
	}
	
	@IBAction func RedBandPanned(sender: UIPanGestureRecognizer) {
		if bandComplete && !segued{
            segued = true
            if RainbowComplete {
                DoThePlane()
            }else{
                performSegueWithIdentifier("RainbowToReward", sender: self);
            }
			return
		}
		if !allowColouring{
			return
		}
		if sender.numberOfTouches() > 0 {
			let p = sender.locationOfTouch(0, inView: theBand)
			drawAt(p)
            if (counting){
                print("Already counting")
                return
            }
            counting = true
			if #available(iOS 8.0, *) {
			    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)){
    				self.countRed()
                    self.counting = false
    			}
			} else {
			    // Fallback on earlier versions
			}
		}
		
		
	}
	
	
	
	@IBAction func tapped(sender: UITapGestureRecognizer) {
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
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}
    
    public override func viewDidAppear(animated: Bool) {
//        if foodEaten{
//            fillBand(theBand, colour: paintColour)
//            theBand.startGlowingWithColor(UIColor.redColor(), intensity: 1.0)
//        }
        //home.startGlowing()
    }
    
    func drawText(text:NSString, inImage:UIImage, atPoint:CGPoint) -> UIImage{
        // Setup the font specific variables
        let textColor: UIColor = UIColor.redColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 36)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        text.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
        
    }
    
    func DoThePlane() -> Void {
        let pview:UIImageView = Plane.viewsByName["Airplane-01"] as! UIImageView
        let rewardText = NSUserDefaults.standardUserDefaults().stringForKey("SpecialReward")
        if rewardText != nil && rewardText?.characters.count > 0{
            let newimage = drawText(rewardText!, inImage: pview.image!, atPoint: CGPoint(x: 350,y: 75))
            pview.image = newimage
            Plane.addSwayAnimation({ (Bool) -> Void in
                self.performSegueWithIdentifier("RainbowToReward", sender: self);
            })
        }
    }
    
    func DoThePlaneForever() -> Void {
        let pview:UIImageView = Plane.viewsByName["Airplane-01"] as! UIImageView
        let rewardText = NSUserDefaults.standardUserDefaults().stringForKey("SpecialReward")
        if rewardText != nil && rewardText?.characters.count > 0{
            let newimage = drawText(rewardText!, inImage: pview.image!, atPoint: CGPoint(x: 350,y: 75))
            pview.image = newimage
            Plane.addSwayAnimation()
        }
    }
    
	
	public override func viewWillAppear(animated: Bool) {
        Cloud1.addSwayAnimation()
        Cloud2.addSwayAnimation()
        var NumberOfBands = 0

        if (NSUserDefaults.standardUserDefaults().boolForKey("RED")){
			RedBand.hidden = false
            RedBand.alpha = 1.0
            fillBand(RedBand, colour: UIColor(red: 216/256, green: 73/256, blue: 69/256, alpha: 1))
            NumberOfBands++
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("ORANGE")){
			OrangeBand.hidden = false
            OrangeBand.alpha = 1.0
            fillBand(OrangeBand, colour: UIColor(red: 234/256, green: 156/256, blue: 52/256, alpha: 1))
            NumberOfBands++
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("YELLOW")){
			YellowBand.hidden = false
            YellowBand.alpha = 1.0
            fillBand(YellowBand, colour: UIColor(red: 249/256, green: 237/256, blue: 98/256, alpha: 1))
            NumberOfBands++
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("GREEN")){
			GreenBand.hidden = false
            GreenBand.alpha = 1.0
            fillBand(GreenBand, colour: UIColor(red: 163/256, green: 207/256, blue: 97/256, alpha: 1))
            NumberOfBands++
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("BROWN")){
			BrownBand.hidden = false
            BrownBand.alpha = 1.0
            fillBand(BrownBand, colour: UIColor(red: 147/256, green: 103/256, blue: 72/256, alpha: 1))
            NumberOfBands++
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("PURPLE")){
			PurpleBand.hidden = false
            PurpleBand.alpha = 1.0
            fillBand(PurpleBand, colour: UIColor(red: 65/256, green: 83/256, blue: 191/256, alpha: 1))
            NumberOfBands++
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
                if (!NSUserDefaults.standardUserDefaults().boolForKey("RED")){
                    NumberOfBands++;
                }
				break;
			case 1:
				theBand = OrangeBand
				theColour = "ORANGE"
                paintColour = UIColor(red: 234/256, green: 156/256, blue: 52/256, alpha: 1)
                if (!NSUserDefaults.standardUserDefaults().boolForKey("ORANGE")){
                    NumberOfBands++;
                }
				break;
			case 2:
				theBand = YellowBand
				theColour = "YELLOW"
                paintColour = UIColor(red: 249/256, green: 237/256, blue: 98/256, alpha: 1)
                if (!NSUserDefaults.standardUserDefaults().boolForKey("YELLOW")){
                    NumberOfBands++;
                }
				break;
			case 3:
				theBand = GreenBand
				theColour = "GREEN"
                paintColour = UIColor(red: 163/256, green: 207/256, blue: 97/256, alpha: 1)
                if (!NSUserDefaults.standardUserDefaults().boolForKey("GREEN")){
                    NumberOfBands++;
                }
				break;
			case 4:
				theBand = BrownBand
				theColour = "BROWN"
                paintColour = UIColor(red: 147/256, green: 103/256, blue: 72/256, alpha: 1)
                if (!NSUserDefaults.standardUserDefaults().boolForKey("BROWN")){
                    NumberOfBands++;
                }
				break;
			case 5:
				theBand = PurpleBand
				theColour = "PURPLE"
                paintColour = UIColor(red: 65/256, green: 83/256, blue: 191/256, alpha: 1)
                if (!NSUserDefaults.standardUserDefaults().boolForKey("PURPLE")){
                    NumberOfBands++;
                }
				break;
			default:
				return;
			}
            if NumberOfBands == 6{
                RainbowComplete = true
            }
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: theColour as String)
			theBand.hidden = false
			theBand.alpha = 1.0
            fillBand(theBand, colour: paintColour)
			UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {UIView.setAnimationRepeatCount(5);self.theBand.alpha = 0;}, completion:{
				(Bool finished)-> Void in
				self.allowColouring = true
				self.theBand.alpha = 1
				self.theBand.hidden = false
                self.fillBand(self.theBand, colour: UIColor.whiteColor())
			});

		}else{
			var soundFilePath:NSString
			player = ResourceAudioPlayer(fromName: "myfoodrainbow")
			player.play()
			
		}
	}
	
}