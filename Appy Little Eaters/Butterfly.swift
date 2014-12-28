//
//  Butterfly.swift
//  AppyLittleEaters
//
//  Created by Russell Stather on 28/12/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

import Foundation

public class Butterfly : ForestCreature, MoveableProtocol{

	
	override func didAddToScene() {
		pickRandomDestination()
	}
	
	func moveBy(amount: Float) {
		super.didAddToScene()
		fly(amount)
	}
	
	override func atDestination() {
		pickRandomDestination()
	}
	
	func pickRandomDestination(){
		var current = forestScene.originalPoint(position)
		var x = current.x
		var y = current.y
		let h = Int(arc4random_uniform(2))
		let v = Int(arc4random_uniform(2))
		let xdist = (Int(arc4random_uniform(3)) + 1) * 200
		let ydist = (Int(arc4random_uniform(3)) + 1) * 200
		switch h{
		case 0:
			horizontalDirection = HorizontalDirection.Left
			x -= CGFloat(xdist)
			break
		case 1:
			horizontalDirection = HorizontalDirection.Right
			x += CGFloat(xdist)
			break
		default:
			horizontalDirection = HorizontalDirection.Right
			x += CGFloat(xdist)
			break
		}
		switch v{
		case 0:
			verticalDirection = VerticalDirection.Down
			y -= CGFloat(ydist)
			break
		case 1:
			verticalDirection = VerticalDirection.Up
			y += CGFloat(ydist)
			break
		default:
			verticalDirection = VerticalDirection.Up
			y += CGFloat(ydist)
			break
		}
		if x <= 0 {
			x += CGFloat(xdist)
			horizontalDirection = HorizontalDirection.Right
		}
		if x >= 9000{
			x -= CGFloat(xdist)
			horizontalDirection = HorizontalDirection.Left
		}
		if y <= 0 {
			y += CGFloat(ydist)
			verticalDirection = VerticalDirection.Up
		}
		if y >= 1035{
			y -= CGFloat(ydist)
			verticalDirection = VerticalDirection.Down
			
		}
		destination = CGPoint(x: x, y: y)
	}

}