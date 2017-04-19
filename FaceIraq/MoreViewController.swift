//
//  moreViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func contactUs(_ sender: Any) {
    }
    
    @IBAction func themeColor(_ sender: Any) {
    }
    
    @IBAction func history(_ sender: Any) {
    }
    
    @IBAction func myBookmarks(_ sender: Any) {
    }
    
    @IBAction func bookmarkThisPage(_ sender: Any) {
    }
    
    @IBAction func newPage(_ sender: Any) {
        print("new Page")
        self.presentingViewController?.dismiss(animated: false, completion: {})
        DispatchQueue.main.async {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.dismiss(animated: true, completion: nil)
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
