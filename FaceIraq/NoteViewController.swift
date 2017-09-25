//
//  NoteViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/09/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView!
    
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewToNote()
    }

    func refreshNavBar() {
        if let bar = self.navigationController?.navigationBar {
            bar.barTintColor = AppSettings.shared.currentThemeColor
            bar.tintColor = AppSettings.shared.currentTintColor
            bar.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: AppSettings.shared.currentTintColor]
            bar.backItem?.backBarButtonItem?.tintColor = AppSettings.shared.currentTintColor
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.title = "Note".uppercased()
            bar.setNeedsLayout()
            bar.layoutIfNeeded()
            bar.setNeedsDisplay()
        }
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editNote))
        navigationItem.rightBarButtonItem = editButton
        
    }
    
    func adjustViewToNote() {
        guard let note = note else {
            noteTextTextView.text = "Something went wrong. Please, try again."
            urlLabel.isHidden = true
            dateLabel.isHidden = true
            return
        }
        urlLabel.text = note.urlString as String?
        dateLabel.text = (note.date as Date?)?.textDate
        noteTextTextView.text = note.text as String?
    }
    
    
    @objc private func editNote() {
        let addNoteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteVC.note = self.note
        
        addNoteVC.navigationItem.title = "EDIT NOTE"
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    }
}
