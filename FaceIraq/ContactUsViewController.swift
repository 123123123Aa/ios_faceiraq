//
//  ContactUsViewController.swift
//  FaceIraq
//
//  Created by HEMIkr on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var messageSentLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var imageFirst: UIImageView!
    @IBOutlet weak var imageSecond: UIImageView!
    @IBOutlet weak var imageThird: UIImageView!
    
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        configureUI()
        refreshNavBar()
        
        
        picker.delegate = self
        messageTextView.delegate = self
        subjectTextField.delegate = self
        emailTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavBarButtons()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func sendMessage() {
        showMessageSent(success: false)
        for view in self.view.subviews {
            view.resignFirstResponder()
        }
    }
    
    func configureNavBarButtons() {
        let sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendMessage))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSendingMessage))
        navigationItem.rightBarButtonItem = sendButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem?.tintColor = Style.currentTintColor.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem?.tintColor = Style.currentTintColor.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], for: UIControlState.normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], for: UIControlState.normal)
    }
    
    func configureUI() {
        messageTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        messageTextView.layer.borderWidth = 0.5
        messageTextView.layer.cornerRadius = 4
        messageSentLabel.backgroundColor = Style.currentThemeColor
        messageSentLabel.textColor = Style.currentTintColor
        messageSentLabel.dropShadow()
        messageSentLabel.layer.cornerRadius = 3
        messageSentLabel.layer.masksToBounds = true
        messageSentLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        messageSentLabel.alpha = 0.0
        messageSentLabel.isHidden = true
    }
    
    func showMessageSent(success: Bool) {
        if success {
            messageSentLabel.text = "Message sent successfuly"
            UIView.animate(withDuration: 0.2, animations: {
                self.messageSentLabel.isHidden = false
                self.messageSentLabel.alpha = 1.0
            }) { finished in
                DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.messageSentLabel.alpha = 0.0
                    }) {finished in
                        self.messageSentLabel.isHidden = true
                    }
                })
            }
        }
        else {
            messageSentLabel.text = "Error occured - try later"
            UIView.animate(withDuration: 0.2, animations: {
                self.messageSentLabel.isHidden = false
                self.messageSentLabel.alpha = 1.0
            }) { finished in
                DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.messageSentLabel.alpha = 0.0
                    }) {finished in
                        self.messageSentLabel.isHidden = true
                    }
                })
            }
        }
    }
    
    func showMessage(_ text: String) {
        DispatchQueue.main.async {
        let currentText = self.messageSentLabel.text
        self.messageSentLabel.text = text
        self.messageSentLabel.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.messageSentLabel.isHidden = false
            self.messageSentLabel.alpha = 1.0
        }) { finished in
            DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageSentLabel.alpha = 0.0
                }) {finished in
                    self.messageSentLabel.isHidden = true
                    self.messageSentLabel.text = currentText
                    self.messageSentLabel.layoutIfNeeded()
                }
            })
            }
        }
    }
    
    func cancelSendingMessage() {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func refreshNavBar() {
        let bar = (self.navigationController?.navigationBar)!
        bar.backgroundColor = Style.currentThemeColor
        bar.barTintColor = Style.currentThemeColor
        bar.tintColor = Style.currentTintColor
        bar.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: Style.currentTintColor]
        bar.backItem?.backBarButtonItem?.tintColor = Style.currentTintColor
        bar.setNeedsLayout()
        bar.layoutIfNeeded()
        bar.setNeedsDisplay()
    }

    @IBAction func addPhoto(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        
        present(picker, animated: true)
    }
}

extension ContactUsViewController: UITextFieldDelegate {
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text == "" {
            textField.textColor = .black
            textField.textAlignment = .left
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            switch textField {
            case emailTextField:
                textField.text = "Email"
            case subjectTextField:
                textField.text = "Subject"
            default:
                break
            }
            textField.textColor = UIColor.init(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
            textField.textAlignment = .center
        }
    }
}

extension ContactUsViewController: UITextViewDelegate {
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            textView.text = ""
            textView.textAlignment = .left
            textView.textColor = .black
            
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Message"
            textView.textAlignment = .center
            textView.textColor = UIColor.init(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        }
    }
    
}

extension ContactUsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if imageFirst.image == nil {
                imageFirst.contentMode = .scaleAspectFit
                imageFirst.image = image
            } else {
                if imageSecond.image == nil {
                    imageSecond.contentMode = .scaleAspectFit
                    imageSecond.image = image
                } else {
                    if imageThird.image == nil {
                        imageThird.contentMode = .scaleAspectFit
                        imageThird.image = image
                    } else {
                        DispatchQueue.main.async {
                            self.showMessage("Only three images are allowed")
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.showMessage("Only images are allowed")
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}








