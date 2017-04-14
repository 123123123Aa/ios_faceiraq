//
//  ViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 14/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import WebKit

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
    
    override func loadView() {
        super.loadView()
        
        urlInputTextField.delegate = self
        let configurator = WKWebViewConfiguration()
        webView = WKWebView(frame: webViewLayoutTemplate.frame, configuration: configurator)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        //print(webViewLayoutTemplate.subviews.count)
        webViewLayoutTemplate.insertSubview(webView, at: 0)
        print(view.subviews.count)
        //view.insertSubview(webView, at: 3)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openHomePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manageBackArrow()
    }
    
    func openURL(_ stringURL: String) {
        let url = URL(string: "http://\(stringURL)")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlInputTextField.text = nil
        urlInputTextField.placeholder = url.absoluteString
        if UIApplication.shared.canOpenURL(url) {
            webView.load(request)
        } else {
            print("cannot open URL")
            activityIndicator.stopAnimating()
        }
    }
    
    func manageBackArrow() {
        if !webView.canGoBack {
            self.textFieldLeftConstraint.constant = 8
            self.goBack.isHidden = true
        } else {
            self.textFieldLeftConstraint.constant = 25
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
            textFieldRightConstraint.constant = 107
            goToMore.isHidden = false
            goToHomeSite.isHidden = false
            goToOpenedSites.isHidden = false
            cancelOutlet.isHidden = true
        }
    }
    
    func openHomePage() {
        if urlInputTextField.isEditing {
            urlInputTextField.resignFirstResponder()
        }
        let stringURL = "http://faceiraq.net"
        let url = URL(string: stringURL)!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlInputTextField.text = nil
        urlInputTextField.placeholder = stringURL
        webView.load(request)
        
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
        print("go to open sited")
    }
    @IBAction func goToMore(_ sender: Any) {
        print("go to more")
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
        urlInputTextField.placeholder = webView.url?.absoluteString
        } else {
            urlInputTextField.placeholder = "enter your website adress"
        }
        manageBackArrow()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        urlInputTextField.text = nil
        urlInputTextField.placeholder = "provisional error occured"
        print("provisional error occured")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        urlInputTextField.text = nil
        urlInputTextField.placeholder = "error occured"
        print("error occured")
        activityIndicator.stopAnimating()
    }
}

