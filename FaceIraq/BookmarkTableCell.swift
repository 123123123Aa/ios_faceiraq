//
//  BookmarkTableCell.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import RealmSwift
class BookmarkTableCell: MGSwipeTableCell {

    @IBOutlet weak var smallerLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    var theBookmark: Bookmark?
    

}
