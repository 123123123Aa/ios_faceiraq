//
//  OpenPagesViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 17/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

/*
    Controller loads OpenPages objects from Realm database and shows them as cells.
    When user tapps on cell Controller opens BrowserController and triggers remoteOpenURL(stringURL:) method -> if cell has valid OpenPage object assing to it. In other cases BrowerController.openHomePage() is executed.
*/

import UIKit
import Realm
import RealmSwift
import HFCardCollectionViewLayout

protocol OpenURLDelegate {
    func remoteOpenURL(stringURL: String?)
}

class OpenPagesViewController: UIViewController {
    
    @IBOutlet weak var pagesCounter: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var closePageDelegate: OpenPagesRemovalDelegate!
    var collectionLayout: HFCardCollectionViewLayout!
    var remoteOperURLDelegate: OpenURLDelegate!
    var pages: [OpenPage] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionLayout = collectionView.collectionViewLayout as! HFCardCollectionViewLayout
        collectionView.bounces = true
        
        navigationController?.navigationBar.backgroundColor = AppSettings.shared.currentThemeColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        orderPages()
        countPages()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    func orderPages() {
        let newOrder = (Database.shared.objects(OpenPage.self).sorted(byKeyPath: "dateOfLastVisit", ascending: true).toArray(ofType:OpenPage.self))
        pages = newOrder
    }
    
    func countPages() {
        pagesCounter.text = "\(pages.count)"
    }
    
    @IBAction func addNewPage(_ sender: Any) {
        let newPage = OpenPage(url: nil, host: nil, screen: nil)
        Database.shared.save(newPage)
        self.orderPages()
        self.countPages()
        
        var desiredIndexPath: IndexPath?
        for page in pages {
            if page == newPage {
                desiredIndexPath =  IndexPath(item: pages.index(of: newPage)!, section: 0)
            }
        }
        collectionView.insertItems(at: [desiredIndexPath!])
        collectionView.scrollToItem(at: desiredIndexPath!, at: .bottom, animated: true)
    }
    
    @IBAction func goToHomePage(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToNewHomePage(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToMore(_ sender: Any) {
        // opens popUpVC and set .openPagesVCIsParet to true, due to hide not needed buttons.
        print("go to more")
        let moreVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.delegate = self
        moreVC.openPagesVCIsParent = true
        self.present(moreVC, animated: true, completion: {})
    }
    
    func goToCurrentPage() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func closePage(selector: CloseButton) {
        guard selector.page != nil && !selector.page.isInvalidated else {
            collectionView.reloadData()
            collectionView.reloadInputViews()
            collectionView.collectionViewLayout.finalizeCollectionViewUpdates()
            return
        }
        var indexPathRow: Int?
        for page in pages {
            if page == selector.page {
                indexPathRow = pages.index(of: page)
            }
        }
        
        Database.shared.remove(selector.page)
        
        orderPages()
        countPages()
        print(pages.count)
        
        collectionView.deleteItems(at: [IndexPath.init(row: indexPathRow!, section: 0)])
        collectionView.reloadData()
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
        
        let cell = collectionView.cellForItem(at: indexPath) as! OpenPageCollectionViewCell
        print("cell created")
        if let page = cell.page {
            print("page object present")
            
            // if page.host is empty that means object is New Page and we need to open it in new BrowserVC.openHomePage way.
            let browserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
            
            if page.host != nil {
                print("url present")
                print(page.url! as String)
                browserVC.remoteOpenURL(stringURL: page.url! as String)
            }
            browserVC.pageFromPagesController = page
            print("push new browserVC")
            
            self.navigationController?.pushViewController(browserVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "openPage", for: indexPath) as! OpenPageCollectionViewCell
        
        cell.backgroundColor = .clear
        cell.view.backgroundColor = AppSettings.shared.currentThemeColor
        cell.pageUrl.textColor = AppSettings.shared.currentTintColor
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
        
        // configure page properties
        let page = pages[indexPath.item]
        cell.page = page
        if page.screen != nil {
            print(page.host as! String)
            print(page.url as! String)
            if let image = UIImage(data: (page.screen as! Data)) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.pageScreen?.image = image
                    })
                }
                cell.pageUrl.text = page.host as String?
            }
        } else {
            // setup for newly created OpenPage object
            // host is nil
            cell.pageScreen?.isHidden = true
            cell.pageUrl.text = "New Page"
        }
        
        let closeButton = CloseButton(passing: page)
        closeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        closeButton.backgroundColor = .clear
        closeButton.setImage({() -> UIImage in
                        if AppSettings.shared.currentTintColor != .white { return UIImage(named: "openPagesClose")!
                        } else { return UIImage(named: "openPagesCloseWhite")!
                        }}(), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: -3, left: -10, bottom: 5, right: 7)
        closeButton.addTarget(self, action: #selector(closePage(selector:)), for: .touchDown)
        closeButton.isUserInteractionEnabled = true
        closeButton.isExclusiveTouch = true
        cell.addSubview(closeButton)
        
        return cell
    }
}

extension OpenPagesViewController: MoreDelegate {
    func newPage() {
        print("open new page")
        let newBrowser = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(newBrowser, animated: true)
    }
    
    func goToThemeColor() {
        print("goToThemeColor")
        let themeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeColorTableViewController") as! ThemeColorTableViewController
        self.navigationController?.pushViewController(themeVC, animated: true)
    }
    
    func goToMyBookmarks() {
        print("goToMyBookmarks")
        let bookmarkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyBookmarksTableViewController") as! MyBookmarksTableViewController
        self.navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    
    func addBookmark() {
        // empty, because OpenPagesVC doesn't support addBookmark()
    }
    
    func goToHistory() {
        let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func goToContactUs() {
        let contactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
}

class CloseButton: UIButton {
    var page: OpenPage!
   required init(passing page: OpenPage) {
        self.page = page
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
