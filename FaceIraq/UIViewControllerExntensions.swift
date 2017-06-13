//
//  UIViewControllerExntensions.swift
//  FaceIraq
//
//  Created by HEMIkr on 13/06/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true)
            
        }))
        self.present(alert, animated: true)
    }
}
