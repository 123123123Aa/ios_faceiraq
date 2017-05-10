//
//  ThemeColorTableViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

/*
    When user changes theme color the new one is written down in user defaults and loaded in loadTheme() method every time that app is starting. Tint color is depend on current theme color. If theme color is beige - tint color is black. Other cases tint color is white. 
*/
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
        refreshNavBar()
        self.navigationItem.title = "THEME COLOR"
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
    
    func navigateBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshNavBar() {
        let bar = self.navigationController?.navigationBar
        bar?.barTintColor = AppSettings.currentThemeColor
        bar?.tintColor = AppSettings.currentTintColor
        //bar?.backItem?.backBarButtonItem?.title = nil
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
        return themeColors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! ColorTableViewCell
        let color = themeColors[indexPath.row]
        cell.color = color
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
        if cell.colorPreview.backgroundColor == AppSettings.currentThemeColor {
            cell.checked.isHidden = false
        } else {
            cell.checked.isHidden = true
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ColorTableViewCell
        print("tableCell selected")
        AppSettings.setThemeColor(to: cell.color!)
        tableView.reloadData()
        refreshNavBar()
    }
}
