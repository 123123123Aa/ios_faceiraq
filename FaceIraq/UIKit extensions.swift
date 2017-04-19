//
//  UIKit extensions.swift
//  FaceIraq
//
//  Created by HEMIkr on 17/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

extension UIColor {
    func appColor() -> UIColor {
        return UIColor.init(red: 23, green: 12, blue: 56, alpha: 1)
    }
}

extension UIFont {
    func appFont() -> UIFont {
        return UIFont(name: "Futura-medium", size: 12)!
    }
}

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
