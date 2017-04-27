//
//  ThemeColors.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

struct Style {
    
    static var currentThemeColor = UIColor.AppColors.appBeige
    static var currentTintColor: UIColor {
        if currentThemeColor == UIColor.AppColors.appBeige {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    static func loadTheme() {
        print("loadTheme")
        if let color = UserDefaults.standard.color(forKey: "themeColor") {
            Style.currentThemeColor = color
        }
        print("loading theme color")
    }
    
    static func setThemeColor(to color: UIColor) {
        print("setThemeColor")
        UserDefaults.standard.set(color, forKey: "themeColor")
        currentThemeColor = color
    }
}
