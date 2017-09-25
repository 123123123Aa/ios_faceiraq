//
//  NotesViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/09/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var notes: [Note] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        refreshNavBar()
        fetchNotes()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
    }

    
    
    private func refreshNavBar() {
        if let bar = self.navigationController?.navigationBar {
            bar.barTintColor = AppSettings.shared.currentThemeColor
            bar.tintColor = AppSettings.shared.currentTintColor
            bar.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: AppSettings.shared.currentTintColor]
            bar.backItem?.backBarButtonItem?.tintColor = AppSettings.shared.currentTintColor
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.title = "Notes"
            bar.setNeedsLayout()
            bar.layoutIfNeeded()
            bar.setNeedsDisplay()
        }
        
    }
    
    fileprivate func fetchNotes() {
        notes = Database.shared.objects(Note.self).toArray(ofType: Note.self)
    }

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! NoteTableViewCell
        
        let noteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteVC.note = cell.note
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell") as! NoteTableViewCell
        let note = notes[indexPath.row]
        
        cell.note = note
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            let indexToRemove: IndexPath? = {
                for obj in self.notes {
                    if obj == note {
                        return IndexPath(row: self.notes.index(of: obj)!, section: 0)
                    }
                }
                return nil
            }()
            
            if Database.shared.isInWriteTransaction == false {
                Database.shared.beginWrite()}
            
            Database.shared.delete(note)
            try! Database.shared.commitWrite()
            Database.shared.refresh()
            
            self.fetchNotes()
            
            tableView.deleteRows(at: [indexToRemove!], with: .automatic)
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.reloadData()
            return true
        }
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = .static
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.3))
        view.backgroundColor = self.tableView.separatorColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.3
    }
}
