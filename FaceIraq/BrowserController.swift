//
//  ViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 14/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

/*
    Initial VC of application. 
    If created when app starts or after opening empty card (OpenPage object without data), VC runs openHomePage() method and load www.faceiraq.net. 
    If created after triggering OpenPage/History/Bookmark object (in OpenPagesVC, HistoryTableVC or MyBookmarksTableVC) the remoteOpenPage(url:) is executed. After tapping OpenPage object it become assngned to BrowserViewController.pageFormPagesController, so Controller knows that it's already in OpenPages.
 
 
    UI:
    WebView is declared in viewWillAppear() and has frame equal to webViewLayoutTemplate.
*/

import UIKit
import WebKit
import RealmSwift
import SystemConfiguration

class BrowserViewController: UIViewController {

    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var bookmarkAdded: UILabel!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var webNavigationBar: UIView!
    @IBOutlet weak var webViewLayoutTemplate: UIView!
    @IBOutlet weak var goToOpenedSites: UIButton!
    @IBOutlet weak var goToMore: UIButton!
    @IBOutlet weak var goToHomeSite: UIButton!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var buttonsTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var openPagesCount: UILabel!
    @IBOutlet weak var timeAndDateLabel: UILabel!
    
    
    
    var floatingButton: UIButton!
    var pageFromNotification: NotificationPage? = nil
    var pageFromPagesController: OpenPage? = nil
    var webView: WKWebView?
    fileprivate var screen: NSData? = nil
    fileprivate weak var pageURL: NSString?
    fileprivate weak var pageHost: NSString?
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
        manageBackArrow()
        countOpenPages()
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.scrollView.delegate = self
        webView?.layoutIfNeeded()
        configureWebViewLayout()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        
        addFloatingNotesButton()
        
        openHomePage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        setupWebView()
        configureColors()
        countOpenPages()
        view.layoutSubviews()
        
        if AppSettings.shared.notificationPage != nil {
            pageFromNotification = AppSettings.shared.notificationPage
            openFromPushNotification()
        } else if let page = pageFromPagesController {
            screen = page.screen
            pageURL = page.url
            pageHost = page.host
        }
        
        manageTimeAndDate()
        configureWebViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.viewControllers = [self]
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        addToOpenPagesCollection()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    // MARK: - UI methods
    
    func configureWebViewLayout() {
        if webView == nil {
            webView = WKWebView()
            webView?.navigationDelegate = self
            webView?.uiDelegate = self
            webView?.allowsBackForwardNavigationGestures = true
            webView?.scrollView.delegate = self
            webView?.scrollView.showsHorizontalScrollIndicator = true
            webView?.scrollView.showsVerticalScrollIndicator = true
            webView?.translatesAutoresizingMaskIntoConstraints = false
            webView?.scrollView.delegate = self
            webView?.layoutIfNeeded()
        }
        webView?.frame = webViewLayoutTemplate.frame
        webViewLayoutTemplate.addSubview(webView!)
        let webViewHorizontalConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", options: [], metrics: [:], views: ["webView":webView, "webViewLayoutTemplate":webViewLayoutTemplate])
        let webViewVerticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[webView]-0-|", options: [], metrics: [:], views: ["webView":webView])
        NSLayoutConstraint.activate(webViewVerticalConst)
        NSLayoutConstraint.activate(webViewHorizontalConst)
        webView?.configuration.userContentController = WKUserContentController()
    }
    
    fileprivate func configureColors() {
        // details in Model/Settings and ViewControllers/ThemeColorTableViewController
        webNavigationBar.backgroundColor = AppSettings.shared.currentThemeColor
        navigationController?.navigationBar.backgroundColor = AppSettings.shared.currentThemeColor
        openPagesCount.textColor = AppSettings.shared.currentTintColor
        cancelOutlet.setTitleColor(AppSettings.shared.currentTintColor, for: .normal)
        if AppSettings.shared.currentTintColor == .white {
            goBack.setImage(UIImage.init(named: "browserBackArrowWhite"), for: .normal)
            goToMore.setImage(UIImage.init(named: "openPagesMore"), for: .normal)
            goToHomeSite.setImage(UIImage.init(named: "openPagesHome"), for: .normal)
            goToOpenedSites.setImage(UIImage.init(named: "openPagesSquare"), for: .normal)
        } else {
            goBack.setImage(UIImage.init(named: "browserBackArrow"), for: .normal)
            goToMore.setImage(UIImage.init(named: "browserMore"), for: .normal)
            goToHomeSite.setImage(UIImage.init(named: "browserHome"), for: .normal)
            goToOpenedSites.setImage(UIImage.init(named: "browserSquare"), for: .normal)
        }
    }
    
    private func setupWebView() {
        guard webView == nil else { return }
        webView = WKWebView()
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        webView?.allowsBackForwardNavigationGestures = true
        webView?.scrollView.delegate = self
        webView?.scrollView.showsHorizontalScrollIndicator = true
        webView?.scrollView.showsVerticalScrollIndicator = true
    }
    
    fileprivate func manageBackArrow() {
        //back arrow is visable only if webView has possibility to go back.      
        guard let webView = webView else { return }
        if webView.canGoBack || webView.url?.absoluteString.contains("faceiraq") == false {
            self.goBack.isHidden = false
        } else {
            self.goBack.isHidden = true
        }
    }
    
    fileprivate func addFloatingNotesButton() {
        floatingButton = UIButton()
        let buttonConstant: CGFloat = 40.0
        floatingButton.frame.size = CGSize(width: buttonConstant, height: buttonConstant)
        floatingButton.frame.origin = CGPoint(x: view.frame.maxX - buttonConstant * 1.5, y: view.frame.maxY - buttonConstant * 1.5)
        
        floatingButton.backgroundColor = UIColor(red: 236/255, green: 96/255, blue: 25/255, alpha: 1)
        floatingButton.layer.cornerRadius = buttonConstant/2
        
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.masksToBounds = false
        floatingButton.setBackgroundImage(UIImage(named: "note"), for: UIControlState())
        floatingButton.setBackgroundImage(UIImage(named: "note"), for: .highlighted)
        floatingButton.addTarget(self, action: #selector(pressFloatingButton), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(moveFloatingButton(_:)))
        floatingButton.addGestureRecognizer(longPress)
        view.addSubview(floatingButton)
    }
    
    fileprivate func showBookmarkAdded() {
        // showed after creating Bookmark object
        bookmarkAdded.backgroundColor = AppSettings.shared.currentThemeColor
        bookmarkAdded.textColor = AppSettings.shared.currentTintColor
        bookmarkAdded.dropShadow()
        bookmarkAdded.layer.cornerRadius = 3
        bookmarkAdded.layer.masksToBounds = true
        bookmarkAdded.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        bookmarkAdded.alpha = 0.0
        bookmarkAdded.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.bookmarkAdded.isHidden = false
            self.bookmarkAdded.alpha = 1.0
        }) { finished in
            DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
                UIView.animate(withDuration: 0.2, animations: {
                    self.bookmarkAdded.alpha = 0.0
                }) {finished in
                    self.bookmarkAdded.isHidden = true
                }
            })
        }
    }
    
    fileprivate func changeNavigationBarUI() {
        /*
        if urlInputTextField.isEditing {
            
            //when urlTextField is editing
            buttonsView.animateFade(.out, withDuration: 0.05, withDelay: 0, minAlpha: 0.0, completion:  {finished in
                self.urlInputTextField.layoutIfNeeded()
            })
            cancelOutlet.animateFade(.into, withDuration: 0.05, withDelay: 0.05,minAlpha: 0.0, completion: nil)
            
            
            // when urlTextField is not editing
        } else {
            cancelOutlet.animateFade(.out, withDuration: 0.05, withDelay: 0.0,minAlpha: 0.0, completion: {finished in
                self.textFieldRightConstraint.constant = 110
                self.urlInputTextField.layoutIfNeeded()
            })
            buttonsView.animateFade(.into, withDuration: 0.05, withDelay: 0.05,minAlpha: 0.0, completion: nil)
        }
         */
    }
    
    fileprivate func countOpenPages() {
        var count = 1
        let pages = Database.shared.objects(OpenPage.self).count
        if pages > 0 {
            count = pages
            if pageFromPagesController != nil {
                openPagesCount.text = "\(count)"
            } else {
                openPagesCount.text = "\(count+1)"
            }
        } else {
            openPagesCount.text = "1"
        }
    }
    
    fileprivate func updateScreenshot() {
        var screenShot: UIImage?  {
            if (UIApplication.shared.keyWindow?.rootViewController) != nil {
                let bounds = webView?.bounds
                UIGraphicsBeginImageContextWithOptions((bounds?.size)!, false, UIScreen.main.scale);
                if let _ = UIGraphicsGetCurrentContext() {
                    webView?.drawHierarchy(in: bounds!, afterScreenUpdates: true)
                    let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    return screenshot
                }
            }
            return nil
        }
        if let shot = screenShot {
            screen = NSData(data: UIImagePNGRepresentation(shot)!)
        }
    }

    // MARK: - urlRequest methods
    
    fileprivate func openURL(_ stringURL: String) {
        var string = stringURL
        if string.hasPrefix("http://") {
            string = string.replacingOccurrences(of: "http://", with: "")
        }
        if string.hasPrefix("https://") {
            string = string.replacingOccurrences(of: "https://", with: "")
        }
        if let url = URL(string: "http://\(string)") {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            if UIApplication.shared.canOpenURL(url) {
                webView?.load(request)
                return
        } else {
            webView?.stopLoading()
            return
        }
        }
    }
    
    // method designed to delegate opening URLs from another controller (history/bookmark/openPages)
    func remoteOpenURL(stringURL: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            if stringURL != nil {
                self.pageHost = self.pageFromPagesController?.host
                self.pageURL = self.pageFromPagesController?.url
                self.screen = self.pageFromPagesController?.screen
                self.webView?.stopLoading()
                let url = URL(string: stringURL!)!
                
                //self.openHomePage()
                
                if UIApplication.shared.canOpenURL(url) {
                    var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
                    request.timeoutInterval = 120
                    self.webView?.load(request)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                        self.webView?.isHidden = false
                    })
                } else {
                    }
            } else {
                // if provided URL is invalid open homepage
                self.openHomePage()
            }
        })
    }
    
    func openFromPushNotification() {
        guard
            let url = pageFromNotification?.url,
            UIApplication.shared.canOpenURL(url),
            let _ = self.webView
        else {
            self.openHomePage()
            return
        }
        self.webView?.isHidden = false
        self.webView?.stopLoading()
        
            
        if UIApplication.shared.canOpenURL(url) {
            var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
            self.webView?.load(request)
            self.webView?.isHidden = false
            self.pageFromNotification = nil
            AppSettings.shared.notificationPage = nil
        } else {
            openHomePage()
        }
    }
    
    fileprivate func openHomePage() {
        let urlToOpen = URL(string: AppSettings.shared.faceIraqAdress)!
        let request = URLRequest(url: urlToOpen, cachePolicy: .returnCacheDataElseLoad)
        webView?.load(request)
        webView?.isHidden = false
    }
    
    
    @IBAction func refresh(_ sender: UIButton) {
        self.webView?.reload()
    }
    
    
    
    fileprivate func checkInternetConnection() -> Bool {
        if isConnectedToNetwork() {
            return true
        } else {
            return false
        }
    }
    
    private func manageTimeAndDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.locale = Locale(identifier: "ar_IQ")
        let date = formatter.string(from: Date())
        timeAndDateLabel.text = date
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now()+10, execute: {
            self.manageTimeAndDate()
        })
    }
    
    //MARK: - Database override methods
    
    fileprivate func addToOpenPagesCollection() {
        updateScreenshot()
        guard webView?.url != nil else {
            return
        }
        let url = { () -> NSString? in
            if let url = String((self.webView?.url?.absoluteString)!) {
                return url as NSString
            } else {
                return self.pageHost
            }
        }
        let host = { () -> NSString? in
            if let host = String((self.webView?.url?.host)!) {
                return host as NSString
            } else {
                return self.pageHost
            }
        }
        
        if Database.shared.isInWriteTransaction == false {
            Database.shared.beginWrite()
        }
        //create or update OpenPage object
        if pageFromPagesController != nil {
            self.pageFromPagesController?.url = url()
            self.pageFromPagesController?.screen = screen
            self.pageFromPagesController?.host = host()
        }
            else {
            let openPage = OpenPage(url: url(), host: host(), screen: screen)
            Database.shared.add(openPage)
        }
        
        if Database.shared.isInWriteTransaction {
            try! Database.shared.commitWrite()}
    }
    
    fileprivate func manageHistory() {
        guard webView?.url != nil else {
            return
        }
        let url = NSString(string: (webView?.url?.absoluteString)!)
        let host = NSString(string: (webView?.url!.host)!)
        let title = NSString(string: (webView?.title)!)
        if Database.shared.isInWriteTransaction == false {Database.shared.beginWrite()}
        
        // create history object
        var isInHistory = false
        for object in Database.shared.objects(History.self) {
            if url == object.url {
                isInHistory = true
                object.dateOfLastVisit = Date()
                try! Database.shared.commitWrite()
                break
            }
        }
        if isInHistory == false {
            let obj = History(url: url, host: host, title: title)
            Database.shared.add(obj)
        }
        
        if Database.shared.isInWriteTransaction {
            try! Database.shared.commitWrite()}
    }
    
    
    private func createNote() {
        let stringURL = webView?.url?.host
        let addNoteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteVC.urlString = stringURL
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    
    }
    
    @objc private func moveFloatingButton(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.floatingButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.floatingButton.layer.masksToBounds = true
            })
        case .changed:
            let point = gesture.location(in: view)
            floatingButton.center = point
        case .ended:
            UIView.animate(withDuration: 0.1, animations: {
                self.floatingButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.floatingButton.layer.masksToBounds = false
            })
        default: break
        }
    }
    
    
    // MARK: - Actions
    @objc private func pressFloatingButton() {
        print("floating button triggered")
        UIView.animate(withDuration: 0.1, animations: {
            self.floatingButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.floatingButton.layer.masksToBounds = true
        }) { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.floatingButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.floatingButton.layer.masksToBounds = false
            }) { finished in
                self.createNote()
            }
        }
    }
    
    @IBAction fileprivate func openUrl(_ sender: UITextField) {
    }
    
    @IBAction fileprivate func openHomePage(_ sender: Any) {
        openHomePage()
    }
    
    @IBAction fileprivate func goBack(_ sender: Any) {
        if webView?.canGoBack == true {
            webView?.goBack()
        } else {
            openHomePage()
        }
        changeNavigationBarUI()
    }
    
    @IBAction fileprivate func goToOpenedSites(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OpenPagesViewController") as! OpenPagesViewController
        vc.remoteOperURLDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction fileprivate func goToMore(_ sender: Any) {
        let moreVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.delegate = self
        self.present(moreVC, animated: true, completion: {})
    }

    
    @IBAction fileprivate func cancelTypingNewURL(_ sender: Any) {
        changeNavigationBarUI()
    }
}

extension BrowserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textInputMode {
            textField.resignFirstResponder()
            changeNavigationBarUI()
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeNavigationBarUI()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeNavigationBarUI()
    }
}

extension BrowserViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.updateScreenshot()
        self.manageHistory()
        self.pageURL = NSString(string: (webView.url?.absoluteString)!)
        self.pageHost = NSString(string: (webView.url?.host)!)
        self.manageBackArrow()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if (webView.url) != nil {
            pageURL = webView.url?.absoluteString as NSString?
            pageHost = webView.url?.host as NSString?
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // tapped links from FI are opening in new controller
        if navigationAction.targetFrame == nil && webView.url!.absoluteString == "http://www.faceiraq.net/" {
            let newBrowserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
            
            decisionHandler(.cancel)
            newBrowserVC.remoteOpenURL(stringURL: navigationAction.request.url!.absoluteString)
            self.navigationController?.pushViewController(newBrowserVC, animated: true)
            return
        }
        
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
        default:
            break
        }
        
        decisionHandler(.allow)
    }
 
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("webView:\(webView) decidePolicyForNavigationResponse:\(navigationResponse) decisionHandler:\(decisionHandler)")
    
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("webView:\(webView) didReceiveAuthenticationChallenge:\(challenge) completionHandler:\(completionHandler)")
    
        switch (challenge.protectionSpace.authenticationMethod) {
        case NSURLAuthenticationMethodHTTPBasic:
            let alertController = UIAlertController(title: "Authentication Required", message: webView.url?.host, preferredStyle: .alert)
            weak var usernameTextField: UITextField!
            alertController.addTextField { textField in
                textField.placeholder = "Username"
                usernameTextField = textField
            }
            weak var passwordTextField: UITextField!
            alertController.addTextField { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
                passwordTextField = textField
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                completionHandler(.cancelAuthenticationChallenge, nil)
            }))
            alertController.addAction(UIAlertAction(title: "Log In", style: .default, handler: { action in
                guard let username = usernameTextField.text, let password = passwordTextField.text else {
                    completionHandler(.rejectProtectionSpace, nil)
                    return
                }
                let credential = URLCredential(user: username, password: password, persistence: URLCredential.Persistence.forSession)
                completionHandler(.useCredential, credential)
            }))
            present(alertController, animated: true, completion: nil)
        default:
            completionHandler(.rejectProtectionSpace, nil);
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("webView:\(webView) didFailProvisionalNavigation:\(navigation) withError:\(error)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView:\(webView) didFailNavigation:\(navigation) withError:\(error)")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("WEBVIEW: runJavaScriptAlertPanelWithMessage")
        let alertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            completionHandler()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("WEBVIEW: runJavaScriptTextInputPanelWithPrompt")
        let alertController = UIAlertController(title: frame.request.url?.host, message: prompt, preferredStyle: .alert)
        weak var alertTextField: UITextField!
        alertController.addTextField { textField in
            textField.text = defaultText
            alertTextField = textField
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) {action->Void in
            // cancel handler
            completionHandler(nil)
        })
        alertController.addAction(UIAlertAction(title: "OK", style: .default) {action->Void in
             // ok handler
            completionHandler(alertTextField.text)
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("webView:\(webView) didReceiveServerRedirectForProvisionalNavigation:\(navigation)")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("WEBVIEW: createWebViewWith")
        
        // tapped links are opening in the same controller
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            return nil
        }
        
        return nil
    }
}

extension BrowserViewController: MoreDelegate {
    func newPage() {
        let newBrowser = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(newBrowser, animated: true)
    }
    
    func goToThemeColor() {
        let themeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeColorTableViewController") as! ThemeColorTableViewController
        self.navigationController?.pushViewController(themeVC, animated: true)
    }
    
    func goToMyBookmarks() {
        let bookmarkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyBookmarksTableViewController") as! MyBookmarksTableViewController
        bookmarkVC.remoteOpenURLDelegate = self
        self.navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    
    func addBookmark() {
        let url = NSString(string: (webView?.url?.absoluteString)!)
        let host = NSString(string: (webView?.url!.host)!)
        let title = NSString(string: (webView?.title)!)
        let bookmark = Bookmark(url: url, host: host, title: title)
        Database.shared.save(bookmark)
        showBookmarkAdded()
    }
    
    func goToHistory() {
        let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
        historyVC.remoteOpenURLDelegate = self
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func goToContactUs() {
        let contactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    func goToNotes() {
        let notesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesViewController")
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
}

extension BrowserViewController: UIScrollViewDelegate, OpenURLDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (scrollView.contentOffset.y < 0) {
            webView?.reload()
        }
     }
}
