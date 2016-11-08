//
//  LoginViewController.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/3/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        loginButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.actOnNotification), name: NSNotification.Name(rawValue: notificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func loginToUdacity(_ sender: AnyObject) {
        if usernameTextField.text!.isEmpty == true && passwordTextField.text!.isEmpty == true {
            appDelegate.alertView(errorMessage: "Username and password are required.", viewController: self)
        } else if hasConnectivity() == false {
            appDelegate.alertView(errorMessage: "No internet connection is available.", viewController: self)
        } else if usernameTextField.text!.isEmpty == false && passwordTextField.text!.isEmpty == false {
            OTMClient.sharedInstance().getSessionID(username: (usernameTextField.text)!, password: (passwordTextField.text)!, callingViewController: self)
            loginButton.isEnabled = false
        }
    }

    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        
        if networkStatus != 0 {
            return true
        } else {
            return false
        }
    }
    
    func completion() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func signUp(_ sender: AnyObject) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func actOnNotification() {
        self.activityIndicator.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if usernameTextField.isFirstResponder == true {
            self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
        } else {}
        
        if passwordTextField.isFirstResponder == true {
            self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
        } else {}
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if usernameTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        } else {}
        
        if passwordTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        } else {}
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

