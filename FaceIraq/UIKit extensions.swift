//
//  UIKit extensions.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 17/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import Foundation

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
        return UIColor(red:1.00, green:117/255, blue:15/255, alpha:1.0)
    }
    }
}

extension UIView {
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        self.layer.shadowRadius = 1
    }
    
    // MARK: - Animations
    
    enum Fade {
        case into
        case out
    }
    
    func animateFade(_ fade: UIView.Fade, withDuration: Double, withDelay: Double, minAlpha: CGFloat?, completion: ((_ finished: Bool) -> Void)?) {
            switch fade {
            case .into:
                self.alpha = minAlpha ?? 0.0
                self.isHidden = false
                UIView.animate(withDuration: TimeInterval(withDuration), delay: withDelay, options: [], animations: {
                    self.alpha = 1.0
                }, completion: completion)
                
            case .out:
                self.isHidden = false
                self.alpha = 1.0
                UIView.animate(withDuration: TimeInterval(withDuration), delay: withDelay, options: [], animations: {
                    self.alpha = minAlpha ?? 0.0
                    self.isHidden = true
                }, completion: completion)
            }
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



extension Date {
    
    var textDate: String? {
        //let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let timestamp = DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .short)
        return timestamp
    }
}
