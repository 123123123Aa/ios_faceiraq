//
//  ColorTableViewCell.swift
//  FaceIraq
//
//  Created by HEMIkr on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorPreview: UILabel!
    @IBOutlet weak var colorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
