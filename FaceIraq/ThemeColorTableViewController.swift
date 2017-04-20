//
//  ThemeColorTableViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class ThemeColorTableViewController: UITableViewController {

    var themeColors: [UIColor] = [
                                UIColor.AppColors.appBeige,
                                UIColor.AppColors.appRed,
                                UIColor.AppColors.appPink,
                                UIColor.AppColors.appPurple,
                                UIColor.AppColors.appDarkBlue,
                                UIColor.AppColors.appBlue,
                                UIColor.AppColors.appDarkGreen,
                                UIColor.AppColors.appGreen,
                                UIColor.AppColors.appYellow,
                                UIColor.AppColors.appOrange
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("themeColorTableVC loaded")
        
        self.navigationController?.isNavigationBarHidden = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return themeColors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTableViewCell
        let color = themeColors[indexPath.row]
        cell.colorPreview.backgroundColor = color
        switch color {
        case UIColor.AppColors.appBeige:
            cell.colorName.text = "Beige"
        case UIColor.AppColors.appRed:
            cell.colorName.text = "Red"
        case UIColor.AppColors.appPink:
            cell.colorName.text = "Pink"
        case UIColor.AppColors.appPurple:
            cell.colorName.text = "Purple"
        case UIColor.AppColors.appDarkBlue:
            cell.colorName.text = "Dark Blue"
        case UIColor.AppColors.appBlue:
            cell.colorName.text = "Blue"
        case UIColor.AppColors.appDarkGreen:
            cell.colorName.text = "Dark Green"
        case UIColor.AppColors.appGreen:
            cell.colorName.text = "Green"
        case UIColor.AppColors.appYellow:
            cell.colorName.text = "Yellow"
        case UIColor.AppColors.appOrange:
            cell.colorName.text = "Orange"
        default:
            break
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ColorTableViewCell
        Style.setThemeColor(to: cell.colorPreview.backgroundColor!)
    }
}
