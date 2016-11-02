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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 5
        
        activityIndicator.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func loginToUdacity(_ sender: AnyObject) {
        
        if usernameTextField.text!.isEmpty == true && passwordTextField.text!.isEmpty == true {
            let alert = UIAlertController(title: "Alert", message: "Username and password are required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if hasConnectivity() == false {
            let alert = UIAlertController(title: "Alert", message: "No internet connection available.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if usernameTextField.text!.isEmpty == false && passwordTextField.text!.isEmpty == false {
          //  OTMClient.sharedInstance().getSessionID(username: (usernameTextField.text)!, password: (passwordTextField.text)!, callingViewController: self)
            OTMClient.sharedInstance().getSessionID(username: "brittany.sprabery@gmail.com", password: "pc5DPLrFheIYD%", callingViewController: self)
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
    
    func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
            
        }
    }

    @IBAction func signUp(_ sender: AnyObject) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}

