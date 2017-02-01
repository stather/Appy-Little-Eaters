//
// ParentsrewardView.swift
// Generated by Core Animator version 1.3 on 29/02/2016.
//
// DO NOT MODIFY THIS FILE. IT IS AUTO-GENERATED AND WILL BE OVERWRITTEN
//

import UIKit

@IBDesignable
class ParentsrewardView : UIView, CAAnimationDelegate {


	var animationCompletions = Dictionary<CAAnimation, (Bool) -> Void>()
	var viewsByName: [String : UIView]!

	// - MARK: Life Cycle

	convenience init() {
		self.init(frame: CGRect(x: 0, y: 0, width: 566, height: 418))
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
			case .scaleToFill:
				break
			case .scaleAspectFill:
				let scale = max(xScale, yScale)
				xScale = scale
				yScale = scale
			default:
				let scale = min(xScale, yScale)
				xScale = scale
				yScale = scale
			}
			scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
			scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
		}
	}

	// - MARK: Setup

	func setupHierarchy() {
		var viewsByName: [String : UIView] = [:]
		let bundle = Bundle(for:type(of: self))
		let __scaling__ = UIView()
		__scaling__.bounds = CGRect(x:0, y:0, width:566, height:418)
		__scaling__.center = CGPoint(x:283.0, y:209.0)
		self.addSubview(__scaling__)
		viewsByName["__scaling__"] = __scaling__

		let airplane01 = UIImageView()
		airplane01.bounds = CGRect(x:0, y:0, width:1115.0, height:196.0)
		var imgAirplane01: UIImage!
		if let imagePath = bundle.path(forResource: "Airplane-01.png", ofType:nil) {
			imgAirplane01 = UIImage(contentsOfFile:imagePath)
		}else {
			print("** Warning: Could not create image from 'Airplane-01.png'. Please make sure that it is added to the project directly (not in a folder reference).")
		}
		airplane01.image = imgAirplane01
		airplane01.contentMode = .center
		airplane01.layer.position = CGPoint(x:836.364, y:135.141)
		airplane01.transform = CGAffineTransform(scaleX: 0.48, y: 0.49)
		__scaling__.addSubview(airplane01)
		viewsByName["Airplane-01"] = airplane01

		self.viewsByName = viewsByName
	}

	// - MARK: sway

	func addSwayAnimation() {
		addSwayAnimationWithBeginTime(0, fillMode: kCAFillModeBoth, removedOnCompletion: false, completion: nil)
	}

	func addSwayAnimation(_ completion: ((Bool) -> Void)?) {
		addSwayAnimationWithBeginTime(0, fillMode: kCAFillModeBoth, removedOnCompletion: false, completion: completion)
	}

	func addSwayAnimation(removedOnCompletion: Bool) {
		addSwayAnimationWithBeginTime(0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion, completion: nil)
	}

	func addSwayAnimation(removedOnCompletion: Bool, completion: ((Bool) -> Void)?) {
		addSwayAnimationWithBeginTime(0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion, completion: completion)
	}

	func addSwayAnimationWithBeginTime(_ beginTime: CFTimeInterval, fillMode: String, removedOnCompletion: Bool, completion: ((Bool) -> Void)?) {
		let linearTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		if let complete = completion {
			let representativeAnimation = CABasicAnimation(keyPath: "not.a.real.key")
			representativeAnimation.duration = 14.000
			representativeAnimation.delegate = self
			self.layer.add(representativeAnimation, forKey: "Sway")
			self.animationCompletions[layer.animation(forKey: "Sway")!] = complete
		}

		let airplane01TranslationXAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		airplane01TranslationXAnimation.duration = 14.000
		airplane01TranslationXAnimation.values = [0.000 as Float, -1500.000 as Float]
        airplane01TranslationXAnimation.keyTimes = [NSNumber(value:0.000 as Float), NSNumber(value:1.000 as Float)]
		airplane01TranslationXAnimation.timingFunctions = [linearTiming]
		airplane01TranslationXAnimation.repeatCount = HUGE
		airplane01TranslationXAnimation.beginTime = beginTime
		airplane01TranslationXAnimation.fillMode = fillMode
		airplane01TranslationXAnimation.isRemovedOnCompletion = removedOnCompletion
		self.viewsByName["Airplane-01"]?.layer.add(airplane01TranslationXAnimation, forKey:"sway_TranslationX")
	}

	func removeSwayAnimation() {
		self.layer.removeAnimation(forKey: "Sway")
		self.viewsByName["Airplane-01"]?.layer.removeAnimation(forKey: "sway_TranslationX")
	}
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let completion = self.animationCompletions[anim] {
            self.animationCompletions.removeValue(forKey: anim)
            completion(flag)
        }
    }


	func removeAllAnimations() {
		for subview in viewsByName.values {
			subview.layer.removeAllAnimations()
		}
		self.layer.removeAnimation(forKey: "Sway")
	}
}
