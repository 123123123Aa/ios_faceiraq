//
//  ThemeColors.swift
//  FaceIraq
//
//  Created by HEMIkr on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit


struct Style {
    
    static var currentThemeColor = UIColor.AppColors.appBeige
    
    static func loadTheme() {
        // when app starts load choosed theme color from UserDefaults
        print("loading theme color: \(currentThemeColor)")
    }
    
    static func setThemeColor(to color: UIColor) {
        
        currentThemeColor = color
        loadTheme()
    }
}
