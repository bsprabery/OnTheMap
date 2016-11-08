//
//  POSTViewController.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/18/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class POSTViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OTMClient.sharedInstance().layoutButton(button: postButton)
        
        self.locationTextField.delegate = self
        self.geocoder = CLGeocoder()
        activityIndicator.hidesWhenStopped = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(POSTViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(POSTViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(POSTViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    var geocoder: CLGeocoder?
    
    //postButton
    @IBAction func geocodeLocation(_ sender: AnyObject) {
        submitUserLocation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitUserLocation()
        
        textField.resignFirstResponder()
        return true
    }
    
    func submitUserLocation() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        let userLocation = self.locationTextField.text!
        StudentData.getSharedInstance().setMapString(mapString: userLocation)
        
        self.geocoder?.geocodeAddressString(userLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
                
                let alert = UIAlertController(title: "Alert", message: "No results found.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("There was an error geocoding the location.")
            }
            
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                StudentData.getSharedInstance().setCoordinates(coordinates: coordinates)
            }
            
            self.performSegue(withIdentifier: "SegueToPOST", sender: self)
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if locationTextField.isFirstResponder == true {
            self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
        } else {}
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if locationTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        } else {}
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}
