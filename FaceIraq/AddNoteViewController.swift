//
//  AddNoteViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/09/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note? // if user is adding new note this property will be empty. If user is editing existing one, the old note will be stored in here.
    
    var urlString: String?
    var text: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        noteTextView.delegate = self
        refreshNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        if note != nil {
            self.navigationItem.title = "Edit note".uppercased()
            noteTextView.text = note?.text as String?
        }
    }
    
    private func customize() {
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.borderWidth = 0.5
        noteTextView.layer.masksToBounds = true
        noteTextView.layer.cornerRadius = 5
        noteTextView.text = self.text ?? "Add comment"
    }
    
    
    func refreshNavBar() {
        if let bar = self.navigationController?.navigationBar {
            bar.barTintColor = AppSettings.shared.currentThemeColor
            bar.tintColor = AppSettings.shared.currentTintColor
            bar.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: AppSettings.shared.currentTintColor]
            bar.backItem?.backBarButtonItem?.tintColor = AppSettings.shared.currentTintColor
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.title = "Add note".uppercased()
            bar.setNeedsLayout()
            bar.layoutIfNeeded()
            bar.setNeedsDisplay()
        }
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        navigationItem.rightBarButtonItem?.tintColor = AppSettings.shared.currentTintColor.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem?.tintColor = AppSettings.shared.currentTintColor.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: UIControlState.normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: UIControlState.normal)
    }
    
    
    @objc private func saveNote() {
        if note == nil {
            let text = noteTextView.text == "Add comment" ? "" : noteTextView.text
            let note = Note(url: urlString, text: text)
            Database.shared.save(note)
        } else {
            try! Database.shared.write {
                note?.text = noteTextView.text as NSString?
                try! Database.shared.commitWrite()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancel() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add comment" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == " " {
            textView.text = "Add comment"
        }
    }
    
}
