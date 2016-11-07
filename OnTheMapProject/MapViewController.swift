//
//  MapViewController.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/6/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        OTMClient.sharedInstance().deleteSession()
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: AnyObject) {
        OTMClient.sharedInstance().getStudents(completion: self.setMapData)
        
        print("\n\n========\nRefreshing the map!\n=======\n\n\n")
    }
    
    @IBAction func unwindToMap(_ segue: UIStoryboardSegue) {
        setMapData()
        print("Segue is being performed.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapData()
    }
    
    func setMapData(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let studentStructArray = StudentData.getSharedInstance().getStudentArray()
        var annotations = [MKPointAnnotation]()
        
        for studentStruct in studentStructArray  {

            let lat = studentStruct.latitude!
            let long = studentStruct.longitude!
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = studentStruct.firstName!
            let last = studentStruct.lastName!
            let mediaURL = studentStruct.mediaURL!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) ->MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let subtitle = view.annotation?.subtitle!  {
                if let url = URL(string: "\(subtitle)") {
                    if app.canOpenURL(url) {
                        app.open(url, options: [:], completionHandler: nil)
                    } else {
                        let alert = UIAlertController(title: "Alert", message: "The website cannot be reached.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        print("\n\n=====\n URL is Invalid \n=====\n\n")
                    }
                } else {
                    print("\n\n==============\nNo URL Provided\n===================\n\n")
                }
            } else {
                print("\n\n==============\nInvalid annotation\n===================\n\n")
            }
        }
    }
}
