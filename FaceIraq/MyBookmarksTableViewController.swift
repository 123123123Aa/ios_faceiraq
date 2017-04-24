//
//  MyBookmarksTableViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import MGSwipeTableCell

class MyBookmarksTableViewController: UITableViewController {

    var remoteOpenURLDelegate: OpenURLDelegate!
    var bookmarks: [Bookmark] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bookmarksVC loaded")
        refreshNavBar()
        computeBookmarks()
        tableView.alwaysBounceVertical = false
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
        bookmarks = realm.objects(Bookmark.self).toArray(ofType: Bookmark.self)
    }
    
    func refreshNavBar() {
        let bar = self.navigationController?.navigationBar
        bar?.barTintColor = Style.currentThemeColor
        bar?.tintColor = Style.currentTintColor
        bar?.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: Style.currentTintColor]
        bar?.backItem?.backBarButtonItem?.tintColor = Style.currentTintColor
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
        cell.textLabel?.text = theBookmark.url as String
        if let iconData = theBookmark.icon {
            cell.icon.image = UIImage(data: Data.init(referencing: iconData))
        }
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            let realm = try! Realm()
            if realm.isInWriteTransaction == false {
                realm.beginWrite()}
            realm.delete(theBookmark)
            try! realm.commitWrite()
            realm.refresh()
            self.computeBookmarks()
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
