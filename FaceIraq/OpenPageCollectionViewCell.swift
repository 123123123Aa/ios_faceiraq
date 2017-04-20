//
//  OpenPageCollectionViewCell.swift
//  FaceIraq
//
//  Created by HEMIkr on 18/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import RealmSwift

protocol OpenPagesRemovalDelegate {
    func closePage(page: OpenPage)
}

class OpenPageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonTemplate: UIButton!
    @IBOutlet weak var view: UIView!
    //var closePageDelegate: OpenPagesRemovalDelegate?
    var page: OpenPage? = nil
    @IBOutlet weak var pageScreen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.dropShadow()
        view.backgroundColor = Style.currentThemeColor
        buttonTemplate.backgroundColor = .clear
    }
}
