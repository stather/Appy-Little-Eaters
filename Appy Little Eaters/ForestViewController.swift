//
//  ForestViewController.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 20/10/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit


open class ForestViewController : UIViewController{

	@IBOutlet weak var upButton: UIButton!
	@IBOutlet weak var downButton: UIButton!
	@IBOutlet weak var leftButton: UIButton!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var biggerButton: UIButton!
	@IBOutlet weak var smallerButton: UIButton!
	@IBOutlet weak var mirrorButton: UIButton!
	@IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var LeftLotsButton: UIButton!
    @IBOutlet weak var RightsLotsButton: UIButton!
	
	
	var spriteView:SKView!
	@IBOutlet weak var mainView:UIView!
	var startAnchor:CGPoint!
	@IBOutlet weak var homeButton:UIButton!
	var anchorLimit:CGFloat!
	var forest:ForestScene!
	
    @IBAction func done(_ sender: AnyObject) {
        forest.done()
    }
    
	
	var StartStop:Bool = true
	
	@IBAction func StartStop(_ sender: AnyObject) {
		if StartStop {
			forest.StopScrolling()
			StartStopButton.titleLabel?.text = "Start"
		}else{
			forest.StartScrolling()
			StartStopButton.titleLabel?.text = "Stop"
		}
		StartStop = !StartStop
	}
	
	@IBAction func Mirror(_ sender: AnyObject) {
		forest.Mirror()
	}
	
	@IBAction func Up(_ sender: AnyObject) {
		forest.MoveUp()
	}
	
	
	@IBAction func Down(_ sender: AnyObject) {
		forest.MoveDown()
	}
	
	@IBAction func Right(_ sender: AnyObject) {
		forest.MoveRight()
	}
	
    @IBAction func RightLots(_ sender: AnyObject) {
        forest.MoveRightLots()
    }
    
	@IBAction func Left(_ sender: AnyObject) {
		forest.MoveLeft()
	}
	
    @IBAction func LeftLots(_ sender: AnyObject) {
        forest.MoveLeftLots()
    }
	
	@IBAction func Smaller(_ sender: AnyObject) {
		forest.Smaller()
	}
	
	@IBAction func Bigger(_ sender: AnyObject) {
		forest.Bigger()
	}
	
	override open func viewWillAppear(_ animated: Bool) {
		spriteView = SKView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
		spriteView.isOpaque = false
        spriteView.allowsTransparency = true
		spriteView.showsDrawCount = false
		spriteView.showsNodeCount = false
		spriteView.showsFPS = false
		mainView.insertSubview(spriteView, belowSubview: homeButton)
		forest = ForestScene(size: CGSize(width: 1024, height: 768))
        if UserDefaults.standard.bool(forKey: "AnimationControls"){
            forest.AnimateCreatures = false
        }
		spriteView.presentScene(forest)
        
        if !UserDefaults.standard.bool(forKey: "AnimationControls"){
			upButton.isHidden = true
			downButton.isHidden = true
			leftButton.isHidden = true
			rightButton.isHidden = true
			biggerButton.isHidden = true
			smallerButton.isHidden = true
			mirrorButton.isHidden = true
			StartStopButton.isHidden = true
            DoneButton.isHidden = true
            LeftLotsButton.isHidden = true
            RightsLotsButton.isHidden = true
		}
	}
	
	
	open override func viewDidLoad() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.stopTheUke()
		appDelegate.playSceneSound()
		//appDelegate.speak("Welcome to the forest")
		
	}
	
	open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.stopSceneSound()
		appDelegate.playTheUke()
	}
	
	
}

