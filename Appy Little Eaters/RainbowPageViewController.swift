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
			performSegueWithIdentifier("RainbowToReward", sender: self);
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
	
	public override func viewWillAppear(animated: Bool) {
        Cloud1.addSwayAnimation()
        Cloud2.addSwayAnimation()
		if (NSUserDefaults.standardUserDefaults().boolForKey("RED")){
			RedBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("ORANGE")){
			OrangeBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("YELLOW")){
			YellowBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("GREEN")){
			GreenBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("BROWN")){
			BrownBand.hidden = false;
		}
		if (NSUserDefaults.standardUserDefaults().boolForKey("PURPLE")){
			PurpleBand.hidden = false;
		}
		if (foodEaten){
			switch colour
				{
			case 0:
				theBand = RedBand
				theColour = "RED"
                paintColour = UIColor.redColor()
				break;
			case 1:
				theBand = OrangeBand
				theColour = "ORANGE"
                paintColour = UIColor.orangeColor()
				break;
			case 2:
				theBand = YellowBand
				theColour = "YELLOW"
                paintColour = UIColor.yellowColor()
				break;
			case 3:
				theBand = GreenBand
				theColour = "GREEN"
                paintColour = UIColor.greenColor()
				break;
			case 4:
				theBand = BrownBand
				theColour = "BROWN"
                paintColour = UIColor.brownColor()
				break;
			case 5:
				theBand = PurpleBand
				theColour = "PURPLE"
                paintColour = UIColor.purpleColor()
				break;
			default:
				return;
			}
			theBand.hidden = false;
			theBand.alpha = 1.0;
			UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {UIView.setAnimationRepeatCount(5);self.theBand.alpha = 0;}, completion:{
				(Bool finished)-> Void in
				self.allowColouring = true
				self.theBand.alpha = 1
				self.theBand.hidden = false
			});

		}else{
			var soundFilePath:NSString
			player = ResourceAudioPlayer(fromName: "myfoodrainbow")
			player.play()
			
		}
	}
	
}