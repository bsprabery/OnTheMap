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
        activityIndicator.startAnimating()
        let userLocation = self.locationTextField.text!
        StudentData.getSharedInstance().setMapString(mapString: userLocation)
        
        self.geocoder?.geocodeAddressString(userLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
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

}
