//
//  HistoryTableViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import Realm

class HistoryTableViewController: UITableViewController {

    @IBOutlet weak var searchTextField: UITextField!
    var history: [History] = []
    let realm = try! Realm()
    var remoteOpenURLDelegate: OpenURLDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("historyTVC loaded")
        computeHistory()
        refreshNavBar()
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
    
    func computeHistory() {
        history = realm.objects(History.self).sorted(byKeyPath: "dateOfLastVisit", ascending: false).toArray(ofType: History.self)
    }
    
    func refreshNavBar() {
        let bar = self.navigationController?.navigationBar
        bar?.barTintColor = Style.currentThemeColor
        bar?.tintColor = Style.currentTintColor
        //bar?.backItem?.backBarButtonItem?.title = nil
        bar?.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: Style.currentTintColor]
        //tableView.backgroundColor = Style.currentThemeColor
        bar?.backItem?.backBarButtonItem?.tintColor = Style.currentTintColor
        self.navigationItem.backBarButtonItem?.title = ""
        bar?.setNeedsLayout()
        bar?.layoutIfNeeded()
        bar?.setNeedsDisplay()
    }
    
    func deleteHistoryObject(sender: DeleteButton) {
        print("delete history object")
        
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
        
        if let title = historyObject.title { cell.host.text = title as String }
            else { cell.host.text = historyObject.host as String }
        if let url = historyObject.url { cell.url.text = url as String }
        

        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Convenience callback for swipe buttons!")
            if self.realm.isInWriteTransaction == false {
                self.realm.beginWrite()}
            self.realm.delete(historyObject)
            try! self.realm.commitWrite()
            self.realm.refresh()
            self.computeHistory()
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            return true
        }
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = .static
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HistoryTableViwCell
        print("didSelect row")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        vc.remoteOpenURL(stringURL: cell.url.text)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HistoryTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("text field should return")
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditin")
        computeHistory()
        tableView.reloadData()
        guard textField.text != nil && textField.text != "" && textField.text != " " else {
            print("no relevant textField content")
            return
        }
        print("relevant textField content")
        let searchedText = self.searchTextField.text!
        var newHistory: [History] = []
        for object in history {
            if object.url.contains(searchedText) {
                newHistory.append(object)
            }
        }
        history = newHistory
        self.tableView.reloadData()
    }
}


class DeleteButton: MGSwipeButton {
    var historyObject: History?
}
