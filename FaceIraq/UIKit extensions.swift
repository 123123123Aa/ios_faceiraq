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
        // UIColor.init(red: 245, green: 240, blue: 232, alpha: 1)
        return UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
    }
    
    static var appRed: UIColor {
        return UIColor(red:0.96, green:0.26, blue:0.22, alpha:1.0)
    }
    
    static var appPink: UIColor {
        return UIColor(red:0.91, green:0.12, blue:0.39, alpha:1.0)
    }
    
    static var appPurple: UIColor {
        return UIColor(red:0.61, green:0.15, blue:0.69, alpha:1.0)
    }
    
    static var appDarkBlue: UIColor {
        return UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
    }
    
    static var appBlue: UIColor {
        return UIColor(red:0.14, green:0.59, blue:0.96, alpha:1.0)
    }
    
    static var appTurqoise: UIColor {
        return UIColor(red:0.01, green:0.74, blue:0.84, alpha:1.0)
    }
    
    static var appDarkGreen: UIColor {
        return UIColor(red:0.00, green:0.59, blue:0.54, alpha:1.0)
    }
    
    static var appGreen: UIColor {
        return UIColor(red:0.30, green:0.69, blue:0.32, alpha:1.0)
    }
    
    static var appYellow: UIColor {
        return UIColor(red:1.00, green:0.82, blue:0.00, alpha:1.0)
    }
    
    static var appOrange: UIColor {
        return UIColor(red:1.00, green:0.85, blue:0.06, alpha:1.0)
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

extension UserDefaults {
    
        func set(_ color: UIColor, forKey key: String) {
            set(NSKeyedArchiver.archivedData(withRootObject: color), forKey: key)
        }
        func color(forKey key: String) -> UIColor? {
            guard let data = data(forKey: key) else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
        }
    
}
