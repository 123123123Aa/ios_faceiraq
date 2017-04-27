//
//  ColorTableViewCell.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ColorTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var checked: UIImageView!
    @IBOutlet weak var colorPreview: UILabel!
    @IBOutlet weak var colorName: UILabel!
    var color: UIColor?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
