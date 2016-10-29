//
//  POSTLinkVC.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/18/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class POSTLinkVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMClient.sharedInstance().layoutButton(button: submitButton)
        
        DispatchQueue.main.async {
            self.setUserMapData()
        }
        
        self.urlTextField.delegate = self
    }
    
    let coordinates = StudentData.getSharedInstance().getCoordinates()
    
    func setUserMapData() -> Void {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        self.mapView.addAnnotation(annotation)
        
        //Zoom in on region
        let latDelta: CLLocationDegrees = 0.75
        let longDelta: CLLocationDegrees = 0.75
        let span = MKCoordinateSpanMake(latDelta, longDelta)
        let region = MKCoordinateRegionMake(coordinates, span)
        self.mapView.setRegion(region, animated: false)
        

    }
  //Currently, this function is never getting called - unless the user hits the return key on the keyboard. Additionally, it doesn't cover the issue where you might type one letter and hit enter - would it cause the app to crash if it's not a valid url? I think handling the URL with canOpenURL further on down the line is the solution for that.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let defaultURLText: String = "https://www.udacity.com"
        let inputURLText: String? = urlTextField.text!
        let urlText = inputURLText ?? defaultURLText
        
        StudentData.getSharedInstance().setMediaURL(mediaURL: urlText)
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    //submitButton
    @IBAction func postUserData(_ sender: AnyObject) {
        OTMClient.sharedInstance().getUserData()
    }
    
    

}
