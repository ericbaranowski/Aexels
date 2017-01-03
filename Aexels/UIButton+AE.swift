//
//  UIButton+AE.swift
//  Aexels
//
//  Created by Joe Charlier on 1/2/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class ClosureSleeve {
	let closure: ()->()
	
	init (_ closure: @escaping ()->()) {
		self.closure = closure
	}
	
	@objc func invoke () {
		closure()
	}
}

extension UIButton {
	func addClosure (_ closure: @escaping ()->(), controlEvents: UIControlEvents) {
		let sleeve = ClosureSleeve(closure)
		addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
		objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
}
