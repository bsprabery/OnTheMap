//
//  StudentData.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/10/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import CoreLocation

class StudentData: NSObject {
    
    private static let sharedInstance = StudentData()
    
    static func getSharedInstance() -> StudentData {
        return sharedInstance
    }
    
    //Declares and Initializes Student Structs
    
    public struct StudentStruct {
        let created: String?
        let firstName: String?
        let lastName: String?
        let mediaURL: String?
        let latitude: CLLocationDegrees?
        let longitude: CLLocationDegrees?
        let objectID: String?
        let uniqueKey: String?
        
        init (studentLocation: [String: AnyObject?]) {
            if let created = studentLocation[OTMClient.Constants.JSONResponseKeys.CreatedAt] as? String! {
                self.created = created
            } else {
                created = ""
            }
            if let firstName = studentLocation[OTMClient.Constants.JSONResponseKeys.FirstName] as? String! {
                self.firstName = firstName
            } else {
                firstName = ""
            }
            if let lastName = studentLocation[OTMClient.Constants.JSONResponseKeys.LastName] as? String! {
                self.lastName = lastName
            } else {
                lastName = ""
            }
            if let mediaURL = studentLocation[OTMClient.Constants.JSONResponseKeys.MediaURL] as? String! {
                self.mediaURL = mediaURL
            } else {
                mediaURL = "https://www.udacity.com"
            }
            if let latitude = studentLocation[OTMClient.Constants.JSONResponseKeys.Latitude] as? CLLocationDegrees! {
                self.latitude = latitude
            } else {
                latitude = 0.0
            }
            if let longitude = studentLocation[OTMClient.Constants.JSONResponseKeys.Longitude] as? CLLocationDegrees! {
                self.longitude = longitude
            } else {
                longitude = 0.0
            }
            if let objectID = studentLocation[OTMClient.Constants.JSONResponseKeys.ObjectID] as? String! {
                self.objectID = objectID
            } else {
                objectID = ""
            }
            if let uniqueKey = studentLocation[OTMClient.Constants.JSONResponseKeys.UniqueKey] as? String! {
                self.uniqueKey = uniqueKey
            } else {
                uniqueKey = ""
            }
            
        }
    }
    
    private override init() {
        studentArray = Array<StudentStruct>()
        uniqueKey = String()
        mapCoordinates = CLLocationCoordinate2D()
        mapString = String()
        firstName = String()
        lastName = String()
        mediaURL = String()
    }
    
    //Declares Array of Structs and Stores Student Data
    
    private var studentArray: [StudentStruct]
    
    //This array is created in the getStudents func in OTMClient
    func setStudentArray(studentArray: Array<StudentStruct>) -> Void {
        self.studentArray = studentArray
    }
    
    func getStudentArray() -> Array<StudentStruct> {
        return self.studentArray
    }
    
    
    //User Data
    
    private var mapCoordinates: CLLocationCoordinate2D
    private var mapString: String
    private var uniqueKey: String
    private var firstName: String
    private var lastName: String
    private var mediaURL: String

    func setFirstName(firstName: String) -> Void {
        self.firstName = firstName
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func setLastName(lastName: String) -> Void {
        self.lastName = lastName
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func setUniqueKey(key: String) -> Void {
        self.uniqueKey = key
    }
    
    func getUniqueKey() -> String {
        return self.uniqueKey
    }
    
    func setCoordinates(coordinates: CLLocationCoordinate2D) -> Void {
        self.mapCoordinates = coordinates
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return self.mapCoordinates
    }
    
    func setMapString(mapString: String) {
        self.mapString = mapString
    }
    
    func getMapString() -> String {
        return self.mapString
    }
    
    func setMediaURL(mediaURL: String) {
        self.mediaURL = mediaURL
    }
    
    func getMediaURL() -> String {
        return self.mediaURL
    }
}
























