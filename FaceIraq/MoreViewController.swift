//
//  moreViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var addToBookmarkButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var delegate: MoreDelegate!
    var openPagesVCIsParent: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = Style.currentThemeColor
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cancelButton.backgroundColor = Style.currentThemeColor
        if openPagesVCIsParent {
            addToBookmarkButton.removeFromSuperview()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func contactUs(_ sender: Any) {
        self.dismiss(animated: true)
        delegate.goToContactUs()
    }
    
    @IBAction func themeColor(_ sender: Any) {
        print("themeColor triggered")
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol MoreDelegate {
    func newPage();
    func goToThemeColor();
    func goToMyBookmarks();
    func addBookmark();
    func goToHistory();
    func goToContactUs()
}











