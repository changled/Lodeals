//
//  Extensions.swift
//  Lodeals
//
//  Created by Rachel Chang on 5/9/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import Foundation
import UIKit

//taken from StackOverflow (kaan-dedeoglu)
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

//taken from StackOverflow (kaan-dedeoglu)
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
}
