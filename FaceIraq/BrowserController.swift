//
//  ViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 14/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift
import FavIcon
import SystemConfiguration

class BrowserViewController: UIViewController {

    @IBOutlet weak var noInternetConnectionView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var bookmarkAdded: UILabel!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var urlInputTextField: UITextField!
    @IBOutlet weak var webNavigationBar: UIView!
    @IBOutlet weak var webViewLayoutTemplate: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var goToOpenedSites: UIButton!
    @IBOutlet weak var goToMore: UIButton!
    @IBOutlet weak var goToHomeSite: UIButton!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var textFieldRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var openPagesCount: UILabel!
    var pageFromPagesController: OpenPage? = nil
    let realm = try! Realm()
    var webView: WKWebView!
    var screen: NSData? = nil
    
    override func loadView() {
        super.loadView()
        print("browserVC loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("browserVC viewDidLoad")
        
        self.navigationController?.viewControllers = [self]
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        urlInputTextField.delegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.scrollView.showsVerticalScrollIndicator = true
        
        manageBackArrow()
        countOpenPages()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.layoutIfNeeded()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        
        self.openHomePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("browserVC viewWillAppear")
        
        configureColors()
        countOpenPages()
        self.navigationController?.isNavigationBarHidden = true
        webView.frame = webViewLayoutTemplate.frame
        webViewLayoutTemplate.addSubview(webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        addToOpenPagesCollection()
    }
    
    func updateScreenshot() {
        print("updateScreenshot")
        screen = NSData(data: UIImagePNGRepresentation((webView.snapshot?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch))!)!)
    }
    
    // MARK: - UI methods
    
    func configureColors() {
        webNavigationBar.backgroundColor = Style.currentThemeColor
        navigationController?.navigationBar.backgroundColor = Style.currentThemeColor
        openPagesCount.textColor = Style.currentTintColor
        cancelOutlet.setTitleColor(Style.currentTintColor, for: .normal)
        if Style.currentTintColor == .white {
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("screen orientaion changes")
    }
    
    func manageBackArrow() {
        if !webView.canGoBack {
            self.textFieldLeftConstraint.constant = 7
            self.goBack.isHidden = true
        } else {
            self.textFieldLeftConstraint.constant = 35
            self.goBack.isHidden = false
        }
    }
    func showBookmarkAdded() {
        bookmarkAdded.backgroundColor = Style.currentThemeColor
        bookmarkAdded.textColor = Style.currentTintColor
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
    
    func changeNavigationBarUI() {
        if urlInputTextField.isEditing {
            
            //when urlTextField is editing
            buttonsView.animateFade(.out, withDuration: 0.2, withDelay: 0, minAlpha: 0.0, completion:  {finished in
                self.textFieldRightConstraint.constant = 65
                self.urlInputTextField.layoutIfNeeded()
            })
            cancelOutlet.animateFade(.into, withDuration: 0.2, withDelay: 0.2,minAlpha: 0.0, completion: nil)
            
            
            // when urlTextField is not editing
        } else {
            cancelOutlet.animateFade(.out, withDuration: 0.2, withDelay: 0.0,minAlpha: 0.0, completion: {finished in
                self.textFieldRightConstraint.constant = 110
                self.urlInputTextField.layoutIfNeeded()
            })
            buttonsView.animateFade(.into, withDuration: 0.2, withDelay: 0.2,minAlpha: 0.0, completion: nil)
        }
    }
    
    func countOpenPages() {
        var count = 1
        let pages = realm.objects(OpenPage.self).count
        if pages > 0 {
            count = pages
            if pageFromPagesController != nil {
                print("pageFromPagesController found")
                openPagesCount.text = "\(count)"
            } else {
                print("pageFromPagesController not found: count + 1")
                openPagesCount.text = "\(count+1)"
            }
        } else {
            print("no openPages object in database: count = 1")
            openPagesCount.text = "1"
        }
    }

    // MARK: - urlRequest methods
    
    func openURL(_ stringURL: String) {
        print("openURL")
        var string = stringURL
        if string.hasPrefix("http://") {
            string = string.replacingOccurrences(of: "http://", with: "")
        }
        if string.hasPrefix("https://") {
            string = string.replacingOccurrences(of: "https://", with: "")
        }
        let url = URL(string: "http://\(string)")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlInputTextField.text = nil
        urlInputTextField.placeholder = url.host
        if UIApplication.shared.canOpenURL(url) {
            webView.load(request)
        } else {
            print("cannot open URL")
            activityIndicator.stopAnimating()
        }
    }
    
    func remoteOpenURL(stringURL: String?) {
        print("starts remoteURL open")
        checkInternetConnection()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            print("remoteOpenURL core started")
            //print(stringURL ?? nil)
            if stringURL != nil {
                print("1")
                //self.webView.stopLoading()
                self.webView.stopLoading()
                let url = URL(string: stringURL!)!
                self.urlInputTextField?.placeholder = url.host
                print("ulr created")
                let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData)
                if UIApplication.shared.canOpenURL(url) {
                    self.webView.load(request)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.webView.isHidden = false
                    })
                } else {
                    print("cannot open URL")
                    self.urlInputTextField.placeholder = "unable to open URL"
                    self.activityIndicator.stopAnimating()
                    }
            } else {
                self.openHomePage()
            }
        })
    }
    
    func openHomePage() {
        print("openHomePage")
        checkInternetConnection()
        if urlInputTextField.isEditing {
            urlInputTextField.resignFirstResponder()
        }
        let urlToOpen = URL(string: "http://faceiraq.net")!
        let request = URLRequest(url: urlToOpen, cachePolicy: .returnCacheDataElseLoad)
        urlInputTextField.text = nil
        webView.load(request)
        urlInputTextField.placeholder = "www.faceiraq.net"
        webView.isHidden = false
    }
    
    
    
    ///////////////
    // not working properly due to unable to localizate noInternetConnectionView (don't know why)
    func checkInternetConnection() -> Bool {
        if isConnectedToNetwork() {
            print("internet connected")
            //webView.isHidden = false
            //noInternetConnectionView.isHidden = true
            return true
        } else {
            print("no internet connection")
            //webView.isHidden = true
            //noInternetConnectionView.isHidden = false
            return false
        }
    }
    
    func addToOpenPagesCollection() {
        print("addToOpenPagesCollection")
        guard webView.url != nil else {
            print("webView.url is nil. Returning.")
            return
        }
        //screen = NSData(data: UIImagePNGRepresentation((webView.snapshot?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch))!)!)
        let url = NSString(string: (webView.url?.absoluteString)!)
        let host = NSString(string: (webView.url!.host)!)
        
        if realm.isInWriteTransaction == false {
            realm.beginWrite()}
        
        print("reference page url: \(pageFromPagesController?.url)")
        //create or update OpenPage object
        if pageFromPagesController != nil {
            self.pageFromPagesController?.url = url
            self.pageFromPagesController?.screen = screen
            self.pageFromPagesController?.host = host
            print("OpenPage object updated")
        }
            else {
            let openPage = OpenPage(url: url, host: host, screen: screen)
            realm.add(openPage)
            print("OpenPage object created")
        }
        
        // create history object
        var isInHistory = false
        for object in realm.objects(History.self) {
            print("checking for relevant history objects")
            if url == object.url {
                print("history object found")
                isInHistory = true
                if realm.isInWriteTransaction == false {
                    realm.beginWrite()
                }
                object.dateOfLastVisit = Date()
                print("history object updated")
                try! realm.commitWrite()
            }
        }
        if isInHistory == false {
            print("6")
            let obj = History(url: url, host: host)
            realm.add(obj)
            print("history object added")
            print("7")
        } else {
            print("history object is in history")
        }
        
        if realm.isInWriteTransaction {
            print("9")
            try! realm.commitWrite()}
    }
    
    
    // MARK: - Actions
    @IBAction func openUrl(_ sender: UITextField) {
        openURL(urlInputTextField.text!)
    }
    
    @IBAction func openHomePage(_ sender: Any) {
        openHomePage()
    }
    
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
        urlInputTextField.resignFirstResponder()
        changeNavigationBarUI()
    }
    
    @IBAction func goToOpenedSites(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OpenPagesViewController") as! OpenPagesViewController
        vc.remoteOperURLDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToMore(_ sender: Any) {
        print("go to more")
        let moreVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.delegate = self
        self.present(moreVC, animated: true, completion: {})
    }
    
    @IBAction func cancelTypingNewURL(_ sender: Any) {
        print("cancel typing new URL")
        urlInputTextField.resignFirstResponder()
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
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        if webView.url != nil {
        urlInputTextField.placeholder = webView.url?.host
        } else {
            urlInputTextField.placeholder = "enter your website adress"
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
        self.manageBackArrow()
        self.updateScreenshot()
        })
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("webViewDidClose")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webViewWebContentProcessDidTerminate")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webView did commit")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webView:\(webView) decidePolicyForNavigationAction:\(navigationAction) decisionHandler:\(decisionHandler)")
        if checkInternetConnection() == false {
            webView.stopLoading()
            urlInputTextField.placeholder = "no internet connection"
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
        if checkInternetConnection() == false {
            webView.stopLoading()
            urlInputTextField.placeholder = "no internet connection"
        }
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("webView:\(webView) didReceiveAuthenticationChallenge:\(challenge) completionHandler:\(completionHandler)")
        if checkInternetConnection() == false {
            webView.stopLoading()
            urlInputTextField.placeholder = "no internet connection"
        }
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
        urlInputTextField.text = nil
        urlInputTextField.placeholder = "loading"
        print("provisional error occured")
        print(error)
        activityIndicator.stopAnimating()
        if checkInternetConnection() == false {
            webView.stopLoading()
            urlInputTextField.placeholder = "no internet connection"
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView:\(webView) didFailNavigation:\(navigation) withError:\(error)")
        urlInputTextField.text = nil
        urlInputTextField.placeholder = "loading"
        print("error occured")
        print(error)
        activityIndicator.stopAnimating()
        if checkInternetConnection() == false {
            webView.stopLoading()
            urlInputTextField.placeholder = "no internet connection"
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("runJavaScriptAlertPanelWithMessage")
        //let okAction = UIAlertAction(title: "ok", style: .default) { _ in
            print("")
        //}
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage")
        let _ = UIAlertAction(title: "Okay", style: .default) { _ in
            print("true")
        }
        
        let _ = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("false")
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("runJavaScriptTextInputPanelWithPrompt")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("webView:\(webView) didReceiveServerRedirectForProvisionalNavigation:\(navigation)")
        if checkInternetConnection() == false {
            webView.stopLoading()
            urlInputTextField.placeholder = "no internet connection"
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("createWebViewWith")
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            urlInputTextField.placeholder = webView.url?.absoluteString
        }
        return nil
    }
}

extension BrowserViewController: MoreDelegate {
    func newPage() {
        print("open new page")
        let newBrowser = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(newBrowser, animated: true)
        self.dismiss(animated: false, completion: {
            print("browserVC dismissed  by itself")})
    }
    
    func goToThemeColor() {
        print("goToThemeColor")
        let themeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeColorTableViewController") as! ThemeColorTableViewController
        self.navigationController?.pushViewController(themeVC, animated: true)
    }
    
    func goToMyBookmarks() {
        print("goToMyBookmarks")
        let bookmarkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyBookmarksTableViewController") as! MyBookmarksTableViewController
        bookmarkVC.remoteOpenURLDelegate = self
        self.navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    
    func addBookmark() {
        print("addBookmark")
        let url = NSString(string: (webView.url?.absoluteString)!)
        let host = NSString(string: (webView.url!.host)!)
        let bookmark = Bookmark(url: url, host: host)
        //let icon = webView.url
        if realm.isInWriteTransaction == false {
            realm.beginWrite()
        }
        realm.add(bookmark)
        try! realm.commitWrite()
        showBookmarkAdded()
    }
    
    func goToHistory() {
        print("goToHistory")
        let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
        historyVC.remoteOpenURLDelegate = self
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func goToContactUs() {
        print("go to contact us")
        let contactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
}

extension BrowserViewController: UIScrollViewDelegate, OpenURLDelegate {
    
}

