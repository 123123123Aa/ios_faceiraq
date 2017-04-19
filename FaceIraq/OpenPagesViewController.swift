//
//  OpenPagesViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 17/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class OpenPagesViewController: UIViewController {
    
    
    @IBOutlet weak var pagesCounter: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var realm: Realm?
    var closePageDelegate: OpenPagesRemovalDelegate!
    var remoteOperURLDelegate: OpenURLDelegate?
    var pages: [OpenPage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let backGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(goToCurrentPage))
        backGesture.edges = [.left]
        closePageDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        //let backGesture = UIGestureRecognizer(target: self, action: #selector(goToCurrentPage))
        self.view.addGestureRecognizer(backGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        realm = try! Realm()
        orderPages()
        countPages()
    }
    
    func orderPages() {
        pages = (realm?.objects(OpenPage.self).toArray(ofType:OpenPage.self))!
    }
    
    func countPages() {
        pagesCounter.text = "\(pages.count)"
    }
    
    @IBAction func addNewPage(_ sender: Any) {
        let newPage = OpenPage(url: NSString(string: "http://faceiraq.net"),
                               screen: nil)
        realm?.beginWrite()
        realm?.add(newPage)
        try! realm?.commitWrite()
        orderPages()
        countPages()
        collectionView.reloadData()
    }
    
    @IBAction func goToHomePage(_ sender: Any) {
        if (self.navigationController?.viewControllers[0]) != nil {
            print("root VC removed")
            navigationController?.viewControllers.remove(at: 0)
        }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToMore(_ sender: Any) {
        print("go to more")
        let moreVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        self.present(moreVC, animated: true, completion: {})
    }
    
    func goToCurrentPage() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OpenPagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item selected")
        if (self.navigationController?.viewControllers[0]) != nil {
            print("root VC removed")
            navigationController?.viewControllers.remove(at: 0)
        }
        let cell = collectionView.cellForItem(at: indexPath) as! OpenPageCollectionViewCell
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        if let page = cell.page {
            let urlToOpen = page.url! as String
            vc.pageFromPagesController = page
            vc.remoteOpenURL(urlToOpen)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "openPage", for: indexPath) as! OpenPageCollectionViewCell
        
        cell.closePageDelegate = self
        let page = pages[indexPath.item]
        cell.page = page
        
        if page.screen != nil {
            if let image = UIImage(data: (page.screen as! Data)) {
                cell.pageScreen.image = image
            }
        }
        return cell
    }
}

extension OpenPagesViewController: OpenPagesRemovalDelegate {
    func closePage(page: OpenPage) {
        print("closePage")
        realm?.beginWrite()
        realm?.delete(page)
        try! realm?.commitWrite()
        orderPages()
        countPages()
        collectionView.reloadData()
    }
}

protocol OpenURLDelegate {
    func remoteOpenURL(_ stringURL: String)
}



