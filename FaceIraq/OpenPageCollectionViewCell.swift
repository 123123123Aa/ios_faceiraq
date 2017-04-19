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
    
    var closePageDelegate: OpenPagesRemovalDelegate?
    var page: OpenPage? = nil
    @IBOutlet weak var pageScreen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func closePage(_ sender: Any) {
        print("close page")
        closePageDelegate?.closePage(page: page!)
    }
}
