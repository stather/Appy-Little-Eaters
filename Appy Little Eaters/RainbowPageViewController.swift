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
	var theBand:UIView!
	var theColour:NSString!
	var player:ResourceAudioPlayer!
	var allowColouring:Bool = false
	var alphaLevel:CGFloat = 0
	var lastPoint:CGPoint!
	let circleSize:CGFloat = 100
	var bandComplete:Bool = false
    var counting:Bool = false
    var segued:Bool = false
	
	
	func drawAt(point: CGPoint){
		var r = RedBand.bounds
		var image:UIImage = RedBand.image!
		var imageWidth = image.size.width
		var imageHeight = image.size.height
		var xfact = imageWidth / r.width
		var yfact = imageHeight / r.height
		var x = point.x * xfact
		var y = point.y * yfact
		var newPoint = CGPoint(x: x, y: y)
		UIGraphicsBeginImageContext(image.size)
		image.drawAtPoint(CGPoint.zeroPoint)
		var context = UIGraphicsGetCurrentContext()
		CGContextSetBlendMode(context, kCGBlendModeSourceIn)
		var colour = UIColor.redColor()
		CGContextSetStrokeColorWithColor(context, colour.CGColor)
		CGContextSetLineCap(context, kCGLineCapRound)
		var rect = CGRect(x: (newPoint.x - (circleSize/2)), y: (newPoint.y - (circleSize/2)), width: circleSize, height: circleSize)
		CGContextSetFillColorWithColor(context, colour.CGColor)
		CGContextFillEllipseInRect(context, rect)
		//CGContextSetLineWidth(context, 15)
		//CGContextMoveToPoint(context, 0, 0)
		//CGContextAddLineToPoint(context, point.x, point.y)
		//CGContextStrokePath(context)
		var im2 = UIGraphicsGetImageFromCurrentImageContext()
		RedBand.image = im2
		RedBand.setNeedsDisplay()
	}

	func countRed(){
    
		var cgImage = RedBand.image?.CGImage
		
		var sizew = RedBand.image!.size.width
		var sizeh = RedBand.image!.size.height
		sizew /= 10
		sizeh /= 10
		var s = CGSize(width: sizew, height: sizeh)
		UIGraphicsBeginImageContext(s)
		RedBand.image!.drawInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: s))
        var i = UIGraphicsGetImageFromCurrentImageContext()
		var newImage = UIGraphicsGetImageFromCurrentImageContext()?.CGImage
		UIGraphicsEndImageContext()
		
	
		
		var provider = CGImageGetDataProvider(newImage)
		var bitmapData = CGDataProviderCopyData(provider)
		var data = CFDataGetBytePtr(bitmapData)
		var width = CGImageGetWidth(newImage)
		var height = CGImageGetHeight(newImage)
		var total = width * height
		var white = 0
		var nonwhite = 0
		while total > 0{
			total--
			var vr = Float(data[0])/255.0
			var r = CGFloat(vr)
			var vg = Float(data[1])/255.0
			var g = CGFloat(vg)
			var vb = Float(data[2])/255.0
			var b = CGFloat(vb)
			if r == 1 && g == 1 && b == 1 {
				white += 1
			}else if r > 0 || g > 0 || b > 0 {
				nonwhite += 1
			}
			data += 4
			var returnColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
		}
		if nonwhite / white > 18{
			println("Done so lets segue")
			bandComplete = true
		}
        i = nil
		println("white: " + white.description + " nonwhite: " + nonwhite.description)
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
			var p = sender.locationOfTouch(0, inView: RedBand)
			drawAt(p)
            if (counting){
                println("Already counting")
                return
            }
            counting = true
			dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)){
				self.countRed()
                self.counting = false
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
	
	
	
	public required init(coder aDecoder: NSCoder) {
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
				theBand = RedBand;
				theColour = "RED"
				break;
			case 1:
				theBand = OrangeBand;
				theColour = "ORANGE"
				break;
			case 2:
				theBand = YellowBand;
				theColour = "YELLOW"
				break;
			case 3:
				theBand = GreenBand;
				theColour = "GREEN"
				break;
			case 4:
				theBand = BrownBand;
				theColour = "BROWN"
				break;
			case 5:
				theBand = PurpleBand;
				theColour = "PURPLE"
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