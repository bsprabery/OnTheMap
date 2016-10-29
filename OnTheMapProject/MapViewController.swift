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
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMapData()
    }
    
    @IBAction func refreshButton(_ sender: AnyObject) {
        print("\n\n============\nRefreshing the map!\n============\n\n\n")
        self.mapView.removeAnnotations(myAnnotations!)
        myAnnotations = nil
        OTMClient.sharedInstance().getStudentsLocations(completeLogin: self.setMapData)
 
        //OTMClient.sharedInstance().getUserObjectID(latitude: 40.069035, longitude: -88.253433)
        
        print("Refresh Button Clicked")
    }

    @IBAction func signOutButton(_ sender: AnyObject) {
        OTMClient.sharedInstance().deleteSession()
        completeLogout()
    }
    
    func completeLogout() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func setDataAndRefresh() {
        setMapData()
        
    }
    
    
    func setMapData(){
        print("\n\n============\nSetting the map data!\n============\n\n\n")
        let studentStructArray = StudentData.getSharedInstance().getStudentArray()
        var annotations = [MKPointAnnotation]()
        
        for studentStruct in studentStructArray  {
            let lat = CLLocationDegrees(studentStruct.latitude!)
            let long = CLLocationDegrees(studentStruct.longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentStruct.firstName!
            let last = studentStruct.lastName!
            let mediaURL = studentStruct.mediaURL
            
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
            let url = URL(string: "\(view.annotation?.subtitle)")
            app.open(url!, options: [:], completionHandler: nil)
            
            
            /*            if let validURL: URL = url as! URL {
                app.open(validURL, options: [:], completionHandler: nil)
            } else {
                print("No URL found.")
            }
            
            
             if let toOpen = url {
                let url = URL(string: toOpen)
                app.open(url!, options: [:], completionHandler: nil)
            } else {
                print("No Url found")
            }
            */
        }
    }
    

}
