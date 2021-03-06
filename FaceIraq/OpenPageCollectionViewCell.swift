//
//  OpenPageCollectionViewCell.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 18/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import RealmSwift

protocol OpenPagesRemovalDelegate {
    func closePage(page: OpenPage)
}

class OpenPageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageUrl: UILabel!
    @IBOutlet weak var view: UIView!
    var page: OpenPage? = nil
    @IBOutlet weak var pageScreen: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.dropShadow()
        
    
    }
}
