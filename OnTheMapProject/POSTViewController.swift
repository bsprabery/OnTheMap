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
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMClient.sharedInstance().layoutButton(button: postButton)
        self.locationTextField.delegate = self
        self.geocoder = CLGeocoder()
    }
    
//MARK: Geocoding
    var geocoder: CLGeocoder?
    
    @IBAction func geocodeLocation(_ sender: AnyObject) {
    let userLocation = self.locationTextField.text!
        StudentData.getSharedInstance().setMapString(mapString: userLocation)
        
        self.geocoder?.geocodeAddressString(userLocation, completionHandler: { (placemarks, error) -> Void in
        
            if error != nil {
                print("There was an error geocoding the location.")
            }
        
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                StudentData.getSharedInstance().setCoordinates(coordinates: coordinates)
            }
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "POSTLinkVC") 
            self.present(controller, animated: true, completion: nil)
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
