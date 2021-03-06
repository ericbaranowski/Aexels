//
//  KinematicsView.swift
//  Aexels
//
//  Created by Joe Charlier on 2/18/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumLib
import UIKit

class KinematicsView: UIView, Simulation {
	var Xl: V2 = V2(0,0)							// loop position
	var Vl: V2 = V2(0,0)							// loop velocity
	var Xa: V2 = V2(0,0)							// aether position
	var Va: V2 = V2(0,0)							// aether velocity
	var aetherVisible: Bool = true
	
	var x: Int = 3
	var y: Int = 3
	var o: Int = 1
	
	let timer = AXTimer()
	
	var image: UIImage?
	var hexes: UIImage?
	
	var ord: [V2] = []
	
	var onTic: ((V2)->()) = {V2 in}
	
	init() {
		let q = 0.3
		let sn = sin(Double.pi/6)
		let cs = cos(Double.pi/6)
		
		ord.append(V2(0, 1))
		ord.append(V2(cs, sn))
		ord.append(V2(cs, -sn))
		ord.append(V2(0, -1))
		ord.append(V2(-cs, sn))
		ord.append(V2(-cs, -sn))
		
		Xl = V2(0, 0)
		Vl = V2(-cs*q/2, -sn*q/4)
		
		Xa = V2(0,0)
		Va = V2(0.5, -1.5)
		
		super.init(frame: CGRect.zero)
		
		self.backgroundColor = UIColor.clear
		timer.configure(interval: 1.0/60.0) {
			self.tic()
		}
	}
	required init? (coder aDecoder: NSCoder) {fatalError()}
	
	func render() {
		let s: CGFloat = 30.0
		let sn: CGFloat = s*CGFloat(sin(Double.pi/6))
		let cs: CGFloat = s*CGFloat(cos(Double.pi/6))
		
		let w: CGFloat = width+2*(s+sn)
		let h: CGFloat = height+2*cs
		let n = (Int(w/(2*(s+sn))))+1
		let m = (Int(h/(2*cs)))+1
		var x: CGFloat = 1
		var y: CGFloat = 1
		
		UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 0)
		let c = UIGraphicsGetCurrentContext()!

		let path = CGMutablePath()

		for _ in 0..<n {
			for _ in 0..<m {
				path.move(to: CGPoint(x: x+sn, y: y))
				path.addLine(to: CGPoint(x: x+sn+s, y: y))
				path.addLine(to: CGPoint(x: x+2*sn+s, y: y+cs))
				path.addLine(to: CGPoint(x: x+sn+s, y: y+2*cs))
				path.addLine(to: CGPoint(x: x+sn, y: y+2*cs))
				path.addLine(to: CGPoint(x: x, y: y+cs))
				path.closeSubpath()
				
				y += 2*cs;
			}
			
			x += 3*s;
			y = 1;
		}
		x = sn+s+1;
		y = cs+1;
		for _ in 0..<n {
			for _ in 0..<m {
				path.move(to: CGPoint(x: x+sn, y: y))
				path.addLine(to: CGPoint(x: x+sn+s, y: y))
				path.addLine(to: CGPoint(x: x+2*sn+s, y: y+cs))
				path.addLine(to: CGPoint(x: x+sn+s, y: y+2*cs))
				path.addLine(to: CGPoint(x: x+sn, y: y+2*cs))
				path.addLine(to: CGPoint(x: x, y: y+cs))
				path.closeSubpath()
				
				y += 2*cs;
			}
			
			x += 3*s;
			y = cs+1;
		}

		c.addPath(path)
		c.setStrokeColor(UIColor.white.cgColor)
		c.drawPath(using: .stroke)
		
		self.hexes = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	func jump (_ n: Int) {
		if n == 0 {
			y -= 1
		} else if n == 3 {
			y += 3
		} else {
			o = o==1 ? 0 : 1
		}

		if n == 1 && o == 0 {
			x += 1
		} else if n == 2 && o == 0 {
			x += 1
		} else if n == 4 && o == 1 {
			x -= 1
		} else if n == 5 && o == 1 {
			x -= 1
		}
		
		if n == 1 && o == 1 {
			y -= 1
		} else if n == 2 && o == 0 {
			y += 1
		} else if n == 4 && o == 1 {
			y -= 1
		} else if n == 5 && o == 0 {
			y += 1
		}
	}
	
	func move() {
		var zero: Bool = false
		var A: Int = 0
		
		for i in 0..<6 {
			if V2.innerAngle(ord[i], Vl) < Double.pi/3 {
				if i == 0 {
					zero = true
				} else if i == 1 && zero {
					A = 0
					break
				} else {
					A = i
					break
				}
			} else if i == 1 && zero {
				A = 5
				break
			} else if i == 3 {
				A = 4
				break
			}
		}
		
		let B: Int = (A+1)%6
		
		let vx = Vl.x
		let vy = Vl.y
		let Ax = ord[A].x
		let Ay = ord[A].y
		let Bx = ord[B].x
		let By = ord[B].y
		
		var a: Double
		var b: Double
		
		if Ax != 0 && Bx != 0 {
			a = (vy-vx*By/Bx)/(Ay-Ax*By/Bx)
			b = (vy-vx*Ay/Ax)/(By-Bx*Ay/Ax)
		} else {
			a = (vx-vy*Bx/By)/(Ax-Ay*Bx/By)
			b = (vx-vy*Ax/Ay)/(Bx-By*Ax/Ay)
		}
		
		let r = Double(arc4random_uniform(10000))/9999
		
		if r < a {
			jump(A)
		} else if r < a+b {
			jump(B)
		}
	}
	
	func tic() {
		let s: Double = 30.0
		let sn: Double = s*sin(Double.pi/6)
		let cs: Double = s*cos(Double.pi/6)

		move()
		
		Xa.x += Va.x
		if Xa.x > 0 {
			Xa.x -= 2*(s+sn)
			x += 1
		} else if Xa.x < -2*(s+sn) {
			Xa.x += 2*(s+sn)
			x -= 1
		}
		
		Xa.y -= Va.y;
		if Xa.y > 0 {
			Xa.y -= 2*cs
			y += 1
		} else if Xa.y < -2*cs {
			Xa.y += 2*cs
			y -= 1
		}
		
		let xL = 1 + (o==1 ? sn+s : 0) + Double(x)*3*s + Xa.x
		let yL = 1 + (o==1 ? cs : 0) + Double(y)*2*cs + Xa.y
		let w = Double(width)
		let h = Double(height)
		
		// Bounce
		Xl.x = xL+s
		Xl.y = yL+cs
		let V = V2(Vl.x+Va.x/(2*cs),Vl.y+Va.y/(2*cs))
		if (Xl.x<0 && V.x<0) || (Xl.x>w && V.x>0) {
			Vl.x = -(Vl.x+Va.x/cs)
		}
		if (Xl.y<0 && V.y>0) || (Xl.y>h && V.y<0) {
			Vl.y = -(Vl.y+Va.y/cs)
		}
		
		// Rendering
		UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 0)
		let c = UIGraphicsGetCurrentContext()!
		
		var path = CGMutablePath()
		
		path.move(to: CGPoint(x: xL+sn, y: yL))
		path.addLine(to: CGPoint(x: xL+sn+s, y: yL))
		path.addLine(to: CGPoint(x: xL+2*sn+s, y: yL+cs))
		path.addLine(to: CGPoint(x: xL+sn+s, y: yL+2*cs))
		path.addLine(to: CGPoint(x: xL+sn, y: yL+2*cs))
		path.addLine(to: CGPoint(x: xL, y: yL+cs))
		path.closeSubpath()
		
		c.addPath(path)
		c.setFillColor(OOColor.lavender.uiColor.withAlphaComponent(0.5).cgColor)
		if aetherVisible {
			c.drawPath(using: .fill)
		} else {
			c.setStrokeColor(UIColor.white.cgColor)
			c.drawPath(using: .fillStroke)
		}
		c.drawPath(using: .stroke)
		
		path = CGMutablePath()
		path.addEllipse(in: CGRect(x: Xl.x-1.5, y: Xl.y-1.5, width: 3, height: 3))
		path.move(to: CGPoint(x: Xl.x, y: Xl.y))
		path.addLine(to: CGPoint(x: Xl.x+Vl.x*cs*cs/5, y: Xl.y-Vl.y*cs*cs/5))
		
		c.addPath(path)
		c.setStrokeColor(UIColor.white.cgColor)
		c.drawPath(using: .stroke)
		
		if aetherVisible {
			hexes?.draw(at: CGPoint(x: Xa.x, y: Xa.y))
		}
		
		self.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		DispatchQueue.main.async {
			self.setNeedsDisplay()
		}
		
		// Callback
		onTic(Vl)
	}
	
	func refresh() {
		let s: Double = 30.0
		let sn: Double = s*sin(Double.pi/6)
		let cs: Double = s*cos(Double.pi/6)

		let xL = 1 + (o==1 ? sn+s : 0) + Double(x)*3*s + Xa.x
		let yL = 1 + (o==1 ? cs : 0) + Double(y)*2*cs + Xa.y
		let w = Double(width)
		let h = Double(height)
		
		// Rendering
		UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 0)
		let c = UIGraphicsGetCurrentContext()!
		
		var path = CGMutablePath()
		
		path.move(to: CGPoint(x: xL+sn, y: yL))
		path.addLine(to: CGPoint(x: xL+sn+s, y: yL))
		path.addLine(to: CGPoint(x: xL+2*sn+s, y: yL+cs))
		path.addLine(to: CGPoint(x: xL+sn+s, y: yL+2*cs))
		path.addLine(to: CGPoint(x: xL+sn, y: yL+2*cs))
		path.addLine(to: CGPoint(x: xL, y: yL+cs))
		path.closeSubpath()
		
		c.addPath(path)
		c.setFillColor(OOColor.lavender.uiColor.withAlphaComponent(0.5).cgColor)
		if aetherVisible {
			c.drawPath(using: .fill)
		} else {
			c.setStrokeColor(UIColor.white.cgColor)
			c.drawPath(using: .fillStroke)
		}
		c.drawPath(using: .stroke)
		
		path = CGMutablePath()
		path.addEllipse(in: CGRect(x: Xl.x-1.5, y: Xl.y-1.5, width: 3, height: 3))
		path.move(to: CGPoint(x: Xl.x, y: Xl.y))
		path.addLine(to: CGPoint(x: Xl.x+Vl.x*cs*cs/5, y: Xl.y+Vl.y*cs*cs/5))
		
		c.addPath(path)
		c.setStrokeColor(UIColor.white.cgColor)
		c.drawPath(using: .stroke)
		
		if aetherVisible {
			hexes?.draw(at: CGPoint(x: Xa.x, y: Xa.y))
		}
		
		self.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		DispatchQueue.main.async {
			self.setNeedsDisplay()
		}		
	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		if hexes == nil {
			render()
		}
	}
	override func draw(_ rect: CGRect) {
		guard let image = image else {return}
		image.draw(at: CGPoint.zero)
	}
	
// Simulation ======================================================================================
	func play() {
		timer.start()
	}
	func stop() {
		timer.stop()
	}
	func reset() {
		x = 3
		y = 3
		o = 0
	}
}
