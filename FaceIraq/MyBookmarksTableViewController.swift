//
//  MyBookmarksTableViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

/*
    Bookmark can be created only in BrowserController/MoreViewController.
*/

import UIKit
import Realm
import RealmSwift
import MGSwipeTableCell

class MyBookmarksTableViewController: UITableViewController {

    @IBOutlet weak var searchTextField: UITextField!
    var remoteOpenURLDelegate: OpenURLDelegate!
    var bookmarks: [Bookmark] = []
    var filterString: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bookmarksVC loaded")
        refreshNavBar()
        computeBookmarks()
        searchTextField.delegate = self
        tableView.alwaysBounceVertical = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func computeBookmarks() {
        let realm = try! Realm()
        guard filterString == nil || filterString == "" else { return }
        bookmarks = realm.objects(Bookmark.self).toArray(ofType: Bookmark.self)
    }
    
    func refreshNavBar() {
        let bar = self.navigationController?.navigationBar
        bar?.isHidden = false
        bar?.barTintColor = AppSettings.currentThemeColor
        bar?.tintColor = AppSettings.currentTintColor
        bar?.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: AppSettings.currentTintColor]
        bar?.backItem?.backBarButtonItem?.tintColor = AppSettings.currentTintColor
        self.navigationItem.backBarButtonItem?.title = ""
        bar?.setNeedsLayout()
        bar?.layoutIfNeeded()
        bar?.setNeedsDisplay()
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableCell", for: indexPath) as! BookmarkTableCell

        let theBookmark = bookmarks[indexPath.row]
        cell.theBookmark = theBookmark
        if theBookmark.title != nil {
            cell.textLabel?.text = theBookmark.title as String
        } else {
            cell.textLabel?.text = theBookmark.host as String
        }
        if let url = theBookmark.url { cell.smallerLabel.text = url as String }
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            let realm = try! Realm()
            
            let indexToRemove: IndexPath? = {
                for obj in self.bookmarks {
                    if obj == theBookmark {
                        return IndexPath(row: self.bookmarks.index(of: obj)!, section: 0)
                    }
                }
                return nil
            }()
            if realm.isInWriteTransaction == false {
                realm.beginWrite()}
            
            realm.delete(theBookmark)
            try! realm.commitWrite()
            realm.refresh()
            self.computeBookmarks()
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexToRemove!], with: .automatic)
            tableView.endUpdates()
            return true
        }
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = .static

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookmarkTableCell
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        
        vc.remoteOpenURL(stringURL: cell.theBookmark!.url as String)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyBookmarksTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("text field should return")
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditin")
    
        computeBookmarks()
        tableView.reloadData()
        print(textField.text)
        guard textField.text != nil && textField.text != "" && textField.text != " " else {
            print("no relevant textField content")
            return
        }
        print("relevant textField content")
        let searchedText = self.searchTextField.text!
        var newBookmars: [Bookmark] = []
        for object in bookmarks {
            if object.url.contains(searchedText) {
                newBookmars.append(object)
            }
        }
        bookmarks = newBookmars
        self.tableView.reloadData()
        }
}
