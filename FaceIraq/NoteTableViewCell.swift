//
//  NoteTableViewCell.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/09/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NoteTableViewCell: MGSwipeTableCell {
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    
    var note: Note? {
        didSet {
            adjustCell()
        }
    }
    
    private func adjustCell() {
        guard let note = note else {
            contentView.alpha = 0
            return
        }
        urlLabel.text = note.urlString as String?
        dateLabel.text = (note.date as Date?)?.textDate
        noteTextLabel.text = note.text as String?
    }
    
    
    
}
