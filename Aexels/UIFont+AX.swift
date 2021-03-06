//
//  UIFont+AX.swift
//  Aexels
//
//  Created by Joe Charlier on 1/2/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

extension UIFont {
	static func aexelFont (size: CGFloat) -> UIFont {
		return UIFont(name: "Trajan Pro", size: size)!
	}
	static func aexelFontBold (size: CGFloat) -> UIFont {
		return UIFont(name: "TrajanPro-Bold", size: size)!
	}
}
