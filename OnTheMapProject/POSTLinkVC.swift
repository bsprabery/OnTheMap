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

class POSTLinkVC: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        OTMClient.sharedInstance().layoutButton(button: submitButton)
        
        DispatchQueue.main.async {
            self.setUserMapData()
        }
        
        activityIndicator.hidesWhenStopped = true
        self.urlTextField.delegate = self
        self.mapView.delegate = self
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
       unwindToMapVC()
    }
    
    //submitButton
    @IBAction func postUserData(_ sender: AnyObject) {
        submitUserData()
    }
    
    func setUserMapData() -> Void {
        activityIndicator.startAnimating()
        let coordinates = StudentData.getSharedInstance().getCoordinates()
        
        //Place user's pin on map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        self.mapView.addAnnotation(annotation)
        
        //Zoom in on region.
        let latDelta: CLLocationDegrees = 0.75
        let longDelta: CLLocationDegrees = 0.75
        let span = MKCoordinateSpanMake(latDelta, longDelta)
        let region = MKCoordinateRegionMake(coordinates, span)
        self.mapView.setRegion(region, animated: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitUserData()

        textField.resignFirstResponder()
        return true
    }
    
    func submitUserData() {
        let defaultURLText: String = "https://www.udacity.com"
        let inputURLText: String? = urlTextField.text!
        
        //Checks that the URL provided can be opened; if it cannot, a default URL is provided.
        if let url = URL(string: inputURLText!) {
            if UIApplication.shared.canOpenURL(url) {
                StudentData.getSharedInstance().setMediaURL(mediaURL: inputURLText!)
            } else {
                StudentData.getSharedInstance().setMediaURL(mediaURL: defaultURLText)
            }
        } else {
            StudentData.getSharedInstance().setMediaURL(mediaURL: defaultURLText)
        }
    
        activityIndicator.startAnimating()
        OTMClient.sharedInstance().postLocationData(completion: self.unwindToMapVC)
    }

    func unwindToMapVC() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "unwindToMapSegue", sender: self)
        }
    }

}
