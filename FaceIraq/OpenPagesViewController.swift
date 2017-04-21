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
import HFCardCollectionViewLayout

protocol OpenURLDelegate {
    func remoteOpenURL(_ stringURL: String)
}

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
        //closePageDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(backGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        realm = try! Realm()
        orderPages()
        countPages()
        collectionView.reloadData()
        collectionView.reloadInputViews()
    }
    
    func orderPages() {
        let newOrder = (realm?.objects(OpenPage.self).sorted(byKeyPath: "dateOfLastVisit", ascending: true).toArray(ofType:OpenPage.self))!
        pages = newOrder
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
        //collectionView.insertItems(at: collectionView.subviews)
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
        moreVC.delegate = self
        self.present(moreVC, animated: true, completion: {})
    }
    
    func goToCurrentPage() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func closeAllPages(_ sender: Any) {
        print("closeAllPages")
        realm?.beginWrite()
        for page in pages {
            realm?.delete(page)
        }
        try! realm?.commitWrite()
        orderPages()
        countPages()
        //collectionView.reloadData()
        //collectionView.
    }
    
    func closePage(selector: CloseButton) {
        guard selector.page != nil && !selector.page.isInvalidated else {
            collectionView.reloadData()
            collectionView.reloadInputViews()
            collectionView.collectionViewLayout.finalizeCollectionViewUpdates()
            print("closePage return")
            return
        }
        print(pages.count)
        print("closePage")
        print(selector.page?.url as! String )
        realm?.beginWrite()
        realm?.delete(selector.page)
        try! realm?.commitWrite()
        realm?.refresh()
        
        //collectionView.deleteItems(at: [selector.indexPath!])
        orderPages()
        countPages()
        print(pages.count)
        collectionView.reloadData()
        collectionView.reloadInputViews()
        collectionView.collectionViewLayout.finalizeCollectionViewUpdates()
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
        
        cell.backgroundColor = .clear
        cell.view.layer.cornerRadius = 5.0
        cell.view.layer.borderWidth = 1.0
        cell.view.layer.borderColor = UIColor.clear.cgColor
        cell.view.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: -2, height: -5.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.view.layer.cornerRadius).cgPath
        let page = pages[indexPath.item]
        cell.page = page
        
        let closeButton = CloseButton(page: page)
        closeButton.indexPath = indexPath
        closeButton.frame = cell.buttonTemplate.frame
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        //let closeButtonHorizontalConst = NSLayoutConstraint.constraints(withVisualFormat: "H:[closeButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: ["closeButton":closeButton])
        //let closeButtonVerticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[closeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: ["closeButton":closeButton])
 
        
        closeButton.backgroundColor = .blue
        //closeButton.setImage(UIImage(named: "openPagesClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(closePage(selector:)), for: .touchDown)
        closeButton.isUserInteractionEnabled = true
        closeButton.isExclusiveTouch = true
        cell.addSubview(closeButton)
        //closeButton.addConstraints(closeButtonVerticalConst)
        //closeButton.addConstraints(closeButtonHorizontalConst)
        
 
        
        //cell.buttonTemplate.isExclusiveTouch = true
        if page.screen != nil {
            if let image = UIImage(data: (page.screen as! Data)) {
                cell.pageScreen.image = image
            }
        }
        return cell
    }
}

extension OpenPagesViewController: MoreDelegate {
    func newPage() {
        print("open new page")
        let newBrowser = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.dismiss(animated: true, completion: {})
        self.navigationController?.pushViewController(newBrowser, animated: true)
        
    }
    
    func goToThemeColor() {
        print("goToThemeColor")
        let themeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeColorTableViewController") as! ThemeColorTableViewController
        self.navigationController?.pushViewController(themeVC, animated: true)
    }
    
    func goToMyBookmarks() {
        print("goToMyBookmarks")
    }
    
    func addBookmark() {
        print("addBookmark")
    }
    
    func goToHistory() {
        print("goToHistory")
    }
    
    func goToContactUs() {
        print("go to contact us")
    }
}

class CloseButton: UIButton {
    var page: OpenPage!
    var indexPath: IndexPath?
    required init(page: OpenPage) {
        self.page = page
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

