//
//  ContactUsViewController.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageSentLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var imageFirst: UIImageView!
    @IBOutlet weak var imageSecond: UIImageView!
    @IBOutlet weak var imageThird: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        configureUI()
        refreshNavBar()
        addPhotoButton.isHidden = true
        
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
    
    
    
    func configureNavBarButtons() {
        let sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendMessage))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSendingMessage))
        navigationItem.rightBarButtonItem = sendButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem?.tintColor = AppSettings.shared.currentTintColor.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem?.tintColor = AppSettings.shared.currentTintColor.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], for: UIControlState.normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13)], for: UIControlState.normal)
    }
    
    func configureUI() {
        messageTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        messageTextView.layer.borderWidth = 0.5
        messageTextView.layer.cornerRadius = 4
        messageSentLabel.backgroundColor = AppSettings.shared.currentThemeColor
        messageSentLabel.textColor = AppSettings.shared.currentTintColor
        messageSentLabel.dropShadow()
        messageSentLabel.layer.cornerRadius = 3
        messageSentLabel.layer.masksToBounds = true
        messageSentLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        messageSentLabel.alpha = 0.0
        messageSentLabel.isHidden = true
    }
    
    func showMessageSent(success: Bool) {
        if success {
            messageSentLabel.text = "Message sent"
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
            messageSentLabel.text = "Messege not sent"
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
        self.messageSentLabel.sizeToFit()
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
    
    func sendMessage() {
        containerView.subviews.map({($0 as UIView).resignFirstResponder()})
        
        guard isValidEmail(emailTextField.text) else {
            print("invalid email")
            return }
        guard let text = messageTextView.text,
            let title = subjectTextField.text else {
            print("not all texfields are filled")
            return }
        let email = emailTextField.text
        let image1 = imageFirst.image
        let image2 = imageSecond.image
        let image3 = imageThird.image
        
        let message = Message.init(title, text, email, [image1, image2, image3])
        
        Networking.sendMessage(message) { success in
            switch success {
            case true:
                self.showSimpleAlert(message: "Message sent")
                self.emailTextField.text = nil
                self.subjectTextField.text = nil
                self.messageTextView.text = "Message"
                self.messageTextView.textAlignment = .center
                self.messageTextView.textColor = UIColor.init(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
            case false:
                self.showSimpleAlert(message: "Message was not sent")
            }
        }
    }
    
    func cancelSendingMessage() {
        self.dismiss(animated: false, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func isValidEmail(_ testStr:String?) -> Bool {
        if let text = testStr {
            guard text != "" else { return true }
            let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: text)
            return result
        }
        return false
    }
    
    func refreshNavBar() {
        let bar = (self.navigationController?.navigationBar)!
        bar.backgroundColor = AppSettings.shared.currentThemeColor
        bar.barTintColor = AppSettings.shared.currentThemeColor
        bar.tintColor = AppSettings.shared.currentTintColor
        bar.titleTextAttributes = [ NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),  NSForegroundColorAttributeName: AppSettings.shared.currentTintColor]
        bar.backItem?.backBarButtonItem?.tintColor = AppSettings.shared.currentTintColor
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
                textField.placeholder = "Email"
            case subjectTextField:
                textField.placeholder = "Subject"
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


extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    
    // triggered when user close MFMailComposeVC
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        switch result {
        case .cancelled:
            showMessage("Sending message aborted")
            break
        case .failed:
            showMessage("Message not send")
            break
        case .sent:
            showMessage("Message sent")
            break
        case .saved:
            showMessage("Draft saved")
            break
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {finished in
            self.cancelSendingMessage()
        }
        
    }
}
