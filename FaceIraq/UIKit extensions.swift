//
//  UIKit extensions.swift
//  FaceIraq
//
//  Created by HEMIkr on 17/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct AppColors {
    static var appBeige: UIColor {
        return UIColor.init(red: 245, green: 240, blue: 232, alpha: 1)
    }
    
    static var appRed: UIColor {
        return UIColor.init(red: 244, green: 67, blue: 55, alpha: 1)
    }
    
    static var appPink: UIColor {
        return UIColor.init(red: 232, green: 31, blue: 100, alpha: 1)
    }
    
    static var appPurple: UIColor {
        return UIColor.init(red: 156, green: 39, blue: 175, alpha: 1)
    }
    
    static var appDarkBlue: UIColor {
        return UIColor.init(red: 64, green: 81, blue: 181, alpha: 1)
    }
    
    static var appBlue: UIColor {
        return UIColor.init(red: 35, green: 151, blue: 245, alpha: 1)
    }
    
    static var appTurqoise: UIColor {
        return UIColor.init(red: 3, green: 189, blue: 214, alpha: 1)
    }
    
    static var appDarkGreen: UIColor {
        return UIColor.init(red: 1, green: 150, blue: 137, alpha: 1)
    }
    
    static var appGreen: UIColor {
        return UIColor.init(red: 77, green: 175, blue: 82, alpha: 1)
    }
    
    static var appYellow: UIColor {
        return UIColor.init(red: 255, green: 210, blue: 0, alpha: 1)
    }
    
    static var appOrange: UIColor {
        return UIColor.init(red: 255, green: 117, blue: 15, alpha: 1)
    }
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

    func dropShadow() {
    
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        self.layer.shadowRadius = 1
    }
}
