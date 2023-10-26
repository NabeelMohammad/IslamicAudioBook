//
//  FeedbackViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 09/10/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

class FeedbackViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var feedbackTV: UITextView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Feedback"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.feedbackTV.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        feedbackTV.layer.borderWidth = 1
        feedbackTV.layer.cornerRadius = 5
        feedbackTV.layer.borderColor = UIColor.appThemeColor.cgColor
        
        emailTF.layer.borderWidth = 1
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderColor = UIColor.appThemeColor.cgColor
        
        nameTF.layer.borderWidth = 1
        nameTF.layer.cornerRadius = 5
        nameTF.layer.borderColor = UIColor.appThemeColor.cgColor
    }

    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitFeedback() {
        if(nameTF.text == "") {
            showAlertDailog(_title: "Alert", _msg: "Please enter your name")
        }
        else if (emailTF.text == "" || !isValidEmail(emailTF.text ?? "")) {
            showAlertDailog(_title: "Alert", _msg: "Please enter valid email id")
        }
        else if (!feedbackTV.hasText) {
            showAlertDailog(_title: "Alert", _msg: "Please enter your feedback")
        }
        else {
            //server call
            //name=rrr&email=rakeshrudrapaul@gmail.com&feedback=this is testing feedback
            let serverFbStr = "name=\(String(describing: nameTF.text!))&email=\(String(describing: emailTF.text!))&feedback=\(String(describing: feedbackTV.text!))"
            
            RappleActivityIndicatorView.startAnimating()
                    
            ServerCommunications.submitFeedback(paramString: serverFbStr, completion: {(result) in
                RappleActivityIndicatorView.stopAnimation()
                if(result == nil || result?.message.lowercased() != "success") {
                    // ERROR pop up
                    self.showAlertDailog(_title: "Try Again..!!", _msg: "Your feedback not submitted")
                }
                else {
                    // Success pop up
                    self.showAlertDailog(_title: "Thank You..!!", _msg: "Thank you for submitting your feedback")
                }
            })
        }
        
    }
    
    func showAlertDailog(_title:String, _msg: String ) {
        let alertController = UIAlertController(title: _title , message: _msg, preferredStyle: .alert)

        let ok = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(ok)

        self.present(alertController, animated: true, completion: nil)
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[ء-ي٠-٩A-Z0-9a-z._%+-]+@[ء-ي٠-٩A-Za-z0-9.-]+\\.[ء-ي٠-٩A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
        return emailTest.evaluate(with: testStr)
    }
    
}
