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

class BrowserViewController: UIViewController {

    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var urlInputTextField: UITextField!
    @IBOutlet weak var webNavigationBar: UIView!
    @IBOutlet weak var webViewLayoutTemplate: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var webView: WKWebView!
    @IBOutlet weak var textFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var goToOpenedSites: UIButton!
    @IBOutlet weak var goToMore: UIButton!
    @IBOutlet weak var goToHomeSite: UIButton!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var textFieldRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var openPagesCount: UILabel!
    var pageFromPagesController: OpenPage? = nil
    var realm: Realm!
    override func loadView() {
        super.loadView()
        print("loadView")
        
        realm = try! Realm()
        urlInputTextField.delegate = self
        let configurator = WKWebViewConfiguration()
        webView = WKWebView(frame: webViewLayoutTemplate.frame, configuration: configurator)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsLinkPreview = true
        webViewLayoutTemplate.insertSubview(webView, at: 0)
        webNavigationBar.backgroundColor = Style.currentThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        self.navigationController?.isNavigationBarHidden = true 
        manageBackArrow()
        openHomePage()
        countOpenPages()
        guard isConnectedToNetwork() else {
            webView.stopLoading()
            return
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        addToOpenPagesCollection()
    }
    
    func openURL(_ stringURL: String) {
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
    
    func remoteOpenURL(_ stringURL: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
        print("remoteOpenURL")
        self.webView?.stopLoading()
        let url = URL(string: stringURL)!
        self.urlInputTextField.placeholder = url.host
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        if UIApplication.shared.canOpenURL(url) {
            self.webView.load(request)
        } else {
            print("cannot open URL")
            self.activityIndicator.stopAnimating()
        }
        })
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

    func changeNavigationBarUI() {
        if urlInputTextField.isEditing {
            goToMore.isHidden = true
            goToHomeSite.isHidden = true
            goToOpenedSites.isHidden = true
            cancelOutlet.isHidden = false
            textFieldRightConstraint.constant = 65
        } else {
            textFieldRightConstraint.constant = 110
            goToMore.isHidden = false
            goToHomeSite.isHidden = false
            goToOpenedSites.isHidden = false
            cancelOutlet.isHidden = true
        }
    }
    func testFunc() {
        print("testFunc")
    }
    
    func openHomePage() {
        if urlInputTextField.isEditing {
            urlInputTextField.resignFirstResponder()
        }
        let urlToOpen = URL(string: "http://faceiraq.net")!
        let request = URLRequest(url: urlToOpen, cachePolicy: .returnCacheDataElseLoad)
        urlInputTextField.text = nil
        webView.load(request)
        urlInputTextField.placeholder = "www.faceiraq.net"
        
        
    }
    
    func addToOpenPagesCollection() {
        guard webView.url != nil else {return}
        let screen = NSData(data: UIImagePNGRepresentation((webView.snapshot?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch))!)!)
        let url = NSString(string: (webView.url?.absoluteString)!)
        if pageFromPagesController != nil {
            realm.beginWrite()
            //self.pageFromPagesController?.dateOfLastVisit = Date()
            self.pageFromPagesController?.url = url
            self.pageFromPagesController?.screen = screen
            try! realm.commitWrite()
            return
        } else {
            let openPage = OpenPage(url: url, screen: screen)
            try! realm.write {
            realm.add(openPage)
            }
        }
    }
    
    func countOpenPages() {
        var count = 1
        if let pages = realm?.objects(OpenPage).count {
            if pages > 0 {
                count = pages
                if pageFromPagesController != nil {
                    openPagesCount.text = "\(count)"
                } else {
                openPagesCount.text = "\(count + 1)"
                }
        } else { openPagesCount.text = "1"
            }
        }
        
    }
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
        manageBackArrow()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        urlInputTextField.text = nil
        urlInputTextField.placeholder = "loading"
        print("provisional error occured")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        urlInputTextField.text = nil
        urlInputTextField.placeholder = "loading"
        print("error occured")
        
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("runJavaScriptAlertPanelWithMessage")
        let okAction = UIAlertAction(title: "ok", style: .default) { _ in
            print("")
        }
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
        print("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("createWebViewWith")
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension BrowserViewController: MoreDelegate {
    func newPage() {
        print("open new page")
        let newBrowser = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
        self.navigationController?.pushViewController(newBrowser, animated: true)
        self.dismiss(animated: false, completion: {})
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

