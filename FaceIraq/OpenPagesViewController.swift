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
    }
    @IBAction func addNewPage(_ sender: Any) {
        let newPage = OpenPage(url: NSString(string: "faceiraq.net"),
                               screen: nil)
        realm?.beginWrite()
        realm?.add(newPage)
        try! realm?.commitWrite()
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
    }
    func goToCurrentPage() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension OpenPagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let realm = realm {
            return realm.objects(OpenPage.self).count }
        else { return 0}
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
        let page = realm?.objects(OpenPage.self)[indexPath.item]
        cell.page = page
        cell.closePageDelegate = self
        if let image = UIImage(data: (page?.screen as! Data)) {
            cell.pageScreen.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OpenPagesViewHeader", for: indexPath)
            return header
        
        default:
            print(kind)
        assert(false, "unexpected supplementary element")
        }
    }
}

extension OpenPagesViewController: OpenPagesRemovalDelegate {
    func closePage(page: OpenPage) {
        realm?.beginWrite()
        realm?.delete(page)
        try! realm?.commitWrite()
        collectionView.reloadData()
    }
}

protocol OpenURLDelegate {
    func remoteOpenURL(_ stringURL: String)
}
