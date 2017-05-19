//
//  HistoryTableViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

/*
    History object is created (or upadated) every time that user is entering new website. 
*/
import UIKit
import RealmSwift
import MGSwipeTableCell
import Realm

class HistoryTableViewController: UITableViewController {

    @IBOutlet weak var searchTextField: UITextField!
    var history: [[History]] = [[]]
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
        tableView.sectionIndexBackgroundColor = .white
        tableView.sectionIndexTrackingBackgroundColor = .white
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
        let historyArray = realm.objects(History.self).sorted(byKeyPath: "dateOfLastVisit", ascending: false).toArray(ofType: History.self)
        
        var date1 = Date()
        var historySection = 0
        for object in historyArray {
            if Calendar.current.compare(date1, to: object.dateOfLastVisit, toGranularity: .day) == .orderedSame {
                history[historySection].append(object)
            } else {
                historySection += 1
                date1 = object.dateOfLastVisit
                history.append([object])
            }
        }
        print(history)
    }
    
    func refreshNavBar() {
        let bar = self.navigationController?.navigationBar
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
        return history.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return history[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViwCell
        
        let historyObject = history[indexPath.section][indexPath.row]
        
        if let title = historyObject.title { cell.host.text = title as String }
            else { cell.host.text = historyObject.host as String }
        if let url = historyObject.url { cell.url.text = url as String }
        

        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            let indexToRemove: IndexPath? = {
                for obj in self.history[indexPath.section] {
                    if obj == historyObject {
                        return IndexPath(row: self.history[indexPath.section].index(of: obj)!, section: indexPath.section)
                    }
                }
                return nil
            }()
            if self.realm.isInWriteTransaction == false {
                self.realm.beginWrite()}
            self.realm.delete(historyObject)
            try! self.realm.commitWrite()
            self.realm.refresh()
            self.computeHistory()
            
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexToRemove!], with: .automatic)
            tableView.endUpdates()
            
            return true
        }
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = .static
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("did end editing row: \(indexPath?.row)")
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let date = history[section].first?.dateOfLastVisit {
            let components = Calendar.current.dateComponents([.day,.month,.year], from: date)
            let sectionDate = Calendar.current.date(from: components)
            
            if Calendar.current.isDateInToday(date) {
                return "Today"
            }
            else if Calendar.current.isDateInYesterday(date){
                return "Yesterday"
            }
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/DD/YYYY"
                let stringFromDate = dateFormatter.string(from: sectionDate!)
                return stringFromDate
            }
        }
        return nil
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
        
        // search for new history objects
        var date = Date()
        var historySection = 0
        var newHistory: [[History]] = [[]]
        for section in history {
            for object in section {
                if object.url.contains(searchedText) {
                    if Calendar.current.compare(date, to: object.dateOfLastVisit, toGranularity: .day) == .orderedSame {
                        newHistory[historySection].append(object)
                    } else {
                        historySection += 1
                        date = object.dateOfLastVisit
                        newHistory.append([object])
                    }
                }
            }
        }
        history = newHistory
        self.tableView.reloadData()
    }
}
