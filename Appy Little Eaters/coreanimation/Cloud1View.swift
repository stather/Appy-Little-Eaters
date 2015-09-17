//
// Cloud1View.swift
// Generated by Core Animator version 1.1.1 on 12/07/2015.
//
// DO NOT MODIFY THIS FILE. IT IS AUTO-GENERATED AND WILL BE OVERWRITTEN
//

import UIKit

@IBDesignable
class Cloud1View : UIView {

	var viewsByName: [String : UIView]!

	// - MARK: Life Cycle

	convenience init() {
		self.init(frame: CGRect(x: 0, y: 0, width: 556, height: 368))
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupHierarchy()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupHierarchy()
	}

	// - MARK: Scaling

	override func layoutSubviews() {
		super.layoutSubviews()

		if let scalingView = self.viewsByName["__scaling__"] {
			var xScale = self.bounds.size.width / scalingView.bounds.size.width
			var yScale = self.bounds.size.height / scalingView.bounds.size.height
			switch contentMode {
			case .ScaleToFill:
				break
			case .ScaleAspectFill:
				let scale = max(xScale, yScale)
				xScale = scale
				yScale = scale
			default:
				let scale = min(xScale, yScale)
				xScale = scale
				yScale = scale
			}
			scalingView.transform = CGAffineTransformMakeScale(xScale, yScale)
			scalingView.center = CGPoint(x:CGRectGetMidX(self.bounds), y:CGRectGetMidY(self.bounds))
		}
	}

	// - MARK: Setup

	func setupHierarchy() {
		var viewsByName: [String : UIView] = [:]
		let bundle = NSBundle(forClass:self.dynamicType)
		let __scaling__ = UIView()
		__scaling__.bounds = CGRect(x:0, y:0, width:556, height:368)
		__scaling__.center = CGPoint(x:278.0, y:184.0)
		self.addSubview(__scaling__)
		viewsByName["__scaling__"] = __scaling__

		let cloud1 = UIImageView()
		cloud1.bounds = CGRect(x:0, y:0, width:444.0, height:275.0)
		var imgCloud1: UIImage!
		if let imagePath = bundle.pathForResource("cloud1.png", ofType:nil) {
			imgCloud1 = UIImage(contentsOfFile:imagePath)
		}
		cloud1.image = imgCloud1
		cloud1.contentMode = .Center;
		cloud1.layer.position = CGPoint(x:274.285, y:197.565)
		__scaling__.addSubview(cloud1)
		viewsByName["cloud1"] = cloud1

		self.viewsByName = viewsByName
	}

	// - MARK: sway

	func addSwayAnimation() {
		addSwayAnimationWithBeginTime(0, fillMode: kCAFillModeBoth, removedOnCompletion: false)
	}

	func addSwayAnimation(removedOnCompletion removedOnCompletion: Bool) {
		addSwayAnimationWithBeginTime(0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion)
	}

	func addSwayAnimationWithBeginTime(beginTime: CFTimeInterval, fillMode: String, removedOnCompletion: Bool) {
		let linearTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		let anticipateTiming = CAMediaTimingFunction(controlPoints: 0.42, -0.30, 1.00, 1.00)

		let cloud1RotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
		cloud1RotationAnimation.duration = 10.000
		cloud1RotationAnimation.values = [0.000 as Float, 0.044 as Float, -0.082 as Float, 0.000 as Float]
		cloud1RotationAnimation.keyTimes = [0.000 as Float, 0.300 as Float, 0.700 as Float, 1.000 as Float]
		cloud1RotationAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming]
		cloud1RotationAnimation.repeatCount = HUGE
		cloud1RotationAnimation.beginTime = beginTime
		cloud1RotationAnimation.fillMode = fillMode
		cloud1RotationAnimation.removedOnCompletion = removedOnCompletion
		self.viewsByName["cloud1"]?.layer.addAnimation(cloud1RotationAnimation, forKey:"sway_Rotation")

		let cloud1ScaleXAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
		cloud1ScaleXAnimation.duration = 10.000
		cloud1ScaleXAnimation.values = [1.000 as Float, 1.100 as Float, 1.000 as Float, 1.000 as Float]
		cloud1ScaleXAnimation.keyTimes = [0.000 as Float, 0.100 as Float, 0.200 as Float, 1.000 as Float]
		cloud1ScaleXAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming]
		cloud1ScaleXAnimation.repeatCount = HUGE
		cloud1ScaleXAnimation.beginTime = beginTime
		cloud1ScaleXAnimation.fillMode = fillMode
		cloud1ScaleXAnimation.removedOnCompletion = removedOnCompletion
		self.viewsByName["cloud1"]?.layer.addAnimation(cloud1ScaleXAnimation, forKey:"sway_ScaleX")

		let cloud1ScaleYAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
		cloud1ScaleYAnimation.duration = 10.000
		cloud1ScaleYAnimation.values = [1.000 as Float, 1.100 as Float, 1.000 as Float, 1.000 as Float]
		cloud1ScaleYAnimation.keyTimes = [0.000 as Float, 0.100 as Float, 0.200 as Float, 1.000 as Float]
		cloud1ScaleYAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming]
		cloud1ScaleYAnimation.repeatCount = HUGE
		cloud1ScaleYAnimation.beginTime = beginTime
		cloud1ScaleYAnimation.fillMode = fillMode
		cloud1ScaleYAnimation.removedOnCompletion = removedOnCompletion
		self.viewsByName["cloud1"]?.layer.addAnimation(cloud1ScaleYAnimation, forKey:"sway_ScaleY")

		let cloud1TranslationXAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		cloud1TranslationXAnimation.duration = 10.000
		cloud1TranslationXAnimation.values = [0.000 as Float, -27.615 as Float, 54.773 as Float, 35.120 as Float, -22.826 as Float, 0.000 as Float]
		cloud1TranslationXAnimation.keyTimes = [0.000 as Float, 0.200 as Float, 0.400 as Float, 0.600 as Float, 0.800 as Float, 1.000 as Float]
		cloud1TranslationXAnimation.timingFunctions = [anticipateTiming, anticipateTiming, anticipateTiming, anticipateTiming, anticipateTiming]
		cloud1TranslationXAnimation.repeatCount = HUGE
		cloud1TranslationXAnimation.beginTime = beginTime
		cloud1TranslationXAnimation.fillMode = fillMode
		cloud1TranslationXAnimation.removedOnCompletion = removedOnCompletion
		self.viewsByName["cloud1"]?.layer.addAnimation(cloud1TranslationXAnimation, forKey:"sway_TranslationX")

		let cloud1TranslationYAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
		cloud1TranslationYAnimation.duration = 10.000
		cloud1TranslationYAnimation.values = [0.000 as Float, 21.583 as Float, -11.427 as Float, 48.132 as Float, -53.861 as Float, 0.000 as Float]
		cloud1TranslationYAnimation.keyTimes = [0.000 as Float, 0.200 as Float, 0.400 as Float, 0.600 as Float, 0.800 as Float, 1.000 as Float]
		cloud1TranslationYAnimation.timingFunctions = [anticipateTiming, anticipateTiming, anticipateTiming, anticipateTiming, anticipateTiming]
		cloud1TranslationYAnimation.repeatCount = HUGE
		cloud1TranslationYAnimation.beginTime = beginTime
		cloud1TranslationYAnimation.fillMode = fillMode
		cloud1TranslationYAnimation.removedOnCompletion = removedOnCompletion
		self.viewsByName["cloud1"]?.layer.addAnimation(cloud1TranslationYAnimation, forKey:"sway_TranslationY")
	}

	func removeSwayAnimation() {
		self.viewsByName["cloud1"]?.layer.removeAnimationForKey("sway_Rotation")
		self.viewsByName["cloud1"]?.layer.removeAnimationForKey("sway_ScaleX")
		self.viewsByName["cloud1"]?.layer.removeAnimationForKey("sway_ScaleY")
		self.viewsByName["cloud1"]?.layer.removeAnimationForKey("sway_TranslationX")
		self.viewsByName["cloud1"]?.layer.removeAnimationForKey("sway_TranslationY")
	}

	func removeAllAnimations() {
		for subview in viewsByName.values {
			subview.layer.removeAllAnimations()
		}
	}
}