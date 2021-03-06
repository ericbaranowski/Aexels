//
//  NexusLabel.swift
//  Aexels
//
//  Created by Joe Charlier on 1/2/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class NexusLabel: UIView {
	var text: String = ""
	var size: CGFloat = 72
	
	init (text: String, size: CGFloat) {
		self.text = text
		self.size = size
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.clear
	}
	required init? (coder aDecoder: NSCoder) {fatalError()}
	
// UIView ==========================================================================================
	override func draw (_ rect: CGRect) {
		let c = UIGraphicsGetCurrentContext()!
		
		c.setFillColor(UIColor.black.cgColor)
		c.setShadow(offset: CGSize.zero, blur: 4, color: UIColor(white: 0.2, alpha: 0.8).cgColor)
		let format = Format()
		format.font = UIFont.aexelFont(size: size)
		format.color = UIColor.black
		(text as NSString).draw(at: CGPoint(x: 5, y: 5), withAttributes: format.attributes)
	}
}
