//
//  HistoryTableViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import Realm

class HistoryTableViewController: UITableViewController {

    var history: [History] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.backgroundColor = Style.currentThemeColor
        print("historyTVC loaded")
        history = realm.objects(History.self).sorted(byKeyPath: "dateOfLastVisit", ascending: true).toArray(ofType: History.self)
        refreshNavBar()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "HISTORY"
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshNavBar() {
        let bar = self.navigationController?.navigationBar
        bar?.barTintColor = Style.currentThemeColor
        bar?.tintColor = Style.currentTintColor
        //bar?.backItem?.backBarButtonItem?.title = nil
        bar?.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: Style.currentTintColor]
        tableView.backgroundColor = Style.currentThemeColor
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
        return history.count
        
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViwCell
        let historyObject = history[indexPath.row]
        
        cell.host.text = historyObject.host as String?
        cell.url.text = historyObject.url as String?
        //cell.pageImage = historyObject
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print("didSelect row")
    }

}
