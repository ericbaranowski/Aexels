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
	
	init (text: String) {
		self.text = text
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.clear
	}
	required init? (coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
	
// UIView ==========================================================================================
	override func draw (_ rect: CGRect) {
		let c = UIGraphicsGetCurrentContext()!
		
		c.setFillColor(UIColor.black.cgColor)
		c.setShadow(offset: CGSize.zero, blur: 4, color: UIColor(white: 0.2, alpha: 0.8).cgColor)
		let attributes = AEAttributes()
		attributes.font = UIFont.aexelFont(size: 72)
		attributes.color = UIColor.black
		(text as NSString).draw(at: CGPoint(x: 5, y: 5), withAttributes: attributes.attributes)
	}
}
