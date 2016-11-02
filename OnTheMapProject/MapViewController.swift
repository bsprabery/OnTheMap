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
    
    private var myAnnotations: [MKAnnotation]? = nil
    
    private static let shared = MapViewController()
    
    static func getMapVCShared() -> MapViewController {
        return shared
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var mapView: MKMapView!
    
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
    
    @IBAction func refreshButton(_ sender: AnyObject) {
        self.mapView.removeAnnotations(myAnnotations!)
        myAnnotations = nil
        OTMClient.sharedInstance().getStudentsLocations(completeLogin: self.setMapData)
        
        print("\n\n========\nRefreshing the map!\n=======\n\n\n")
       // OTMClient.sharedInstance().findUserByCoord(latitude: 40.069035, longitude: -88.253433)
    }
    

    @IBAction func signOutButton(_ sender: AnyObject) {
        OTMClient.sharedInstance().deleteSession()
        completeLogout()
    }
    
    func completeLogout() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func setMapData(){
       
        
        let studentStructArray = StudentData.getSharedInstance().getStudentArray()
        var annotations = [MKPointAnnotation]()
        
        for studentStruct in studentStructArray  {

//            guard let lat = studentStruct.latitude else {
//                let lat = 0.0
//                return
//            }
//            
//            guard let long = studentStruct.longitude else {
//                let long = 0.0
//                return
//            }
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
        
        myAnnotations = annotations
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
                        print("\n\n=====\n URL is Invalid \n=====\n\n")
                    }
                } else {
                    print("\n\n==============\nURL isn't valid\n===================\n\n")
                }
            } else {
                print("\n\n==============\nInvalid annotation\n===================\n\n")
            }
        }
    }
}
