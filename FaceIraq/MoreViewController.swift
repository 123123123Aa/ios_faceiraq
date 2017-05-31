//
//  moreViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var notificationsOutlet: UISwitch!
    @IBOutlet weak var currentThemeColorOutlet: UILabel!
    @IBOutlet weak var notificationButtonView: UIView!
    @IBOutlet weak var addToBookmarkButtonView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    var delegate: MoreDelegate!
    var openPagesVCIsParent: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsStackView.spacing = 0.5
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        let cancelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancel(_:)))
        self.view.addGestureRecognizer(cancelGestureRecognizer)
        setNotificationOutlet()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("moreVC viewWillAppear")
        cancelButton.backgroundColor = AppSettings.shared.currentThemeColor
        cancelButton.setTitleColor(AppSettings.shared.currentTintColor, for: .normal)
        currentThemeColorOutlet.backgroundColor = AppSettings.shared.currentThemeColor
        notificationsOutlet.isOn = AppSettings.shared.areNotificationsOn
        if openPagesVCIsParent {
            addToBookmarkButtonView.removeFromSuperview()
        }
    }
    
    func setNotificationOutlet() {
        notificationsOutlet.isOn = AppSettings.shared.areNotificationsOn
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func contactUs(_ sender: Any) {
        self.dismiss(animated: true)
        delegate.goToContactUs()
    }
    
    @IBAction func themeColor(_ sender: Any) {
        self.dismiss(animated: true)
        delegate.goToThemeColor()
    }
    
    @IBAction func history(_ sender: Any) {
        self.dismiss(animated: true)
        delegate.goToHistory()
    }
    
    @IBAction func myBookmarks(_ sender: Any) {
        self.dismiss(animated: true)
        delegate.goToMyBookmarks()
    }
    
    @IBAction func bookmarkThisPage(_ sender: Any) {
        self.dismiss(animated: true)
        delegate.addBookmark()
    }
    
    @IBAction func newPage(_ sender: Any) {
        delegate.newPage()
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func changeNotificationSettings(_ sender: UISwitch) {
        AppSettings.shared.setNotifications(isOn: sender.isOn)
    }
}

protocol MoreDelegate {
    func newPage();
    func goToThemeColor();
    func goToMyBookmarks();
    func addBookmark();
    func goToHistory();
    func goToContactUs()
}

