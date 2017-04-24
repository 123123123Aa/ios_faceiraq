//
//  BookmarkTableCell.swift
//  FaceIraq
//
//  Created by HEMIkr on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import RealmSwift
class BookmarkTableCell: MGSwipeTableCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    var theBookmark: Bookmark?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
