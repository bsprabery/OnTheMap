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
    
    private static let sharedInstance = POSTLinkVC()
    
    static func getSharedInstance() -> POSTLinkVC {
        return sharedInstance
    }
    
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
        
        let defaultURLText: String = "https://www.udacity.com"
        let inputURLText: String? = urlTextField.text!
        let urlText = inputURLText ?? defaultURLText
        
        StudentData.getSharedInstance().setMediaURL(mediaURL: urlText)
        OTMClient.sharedInstance().getUserData()
        
    }
    
    func segueToMapView() {
        self.tabBarController?.selectedIndex = 1
    }
    

}
