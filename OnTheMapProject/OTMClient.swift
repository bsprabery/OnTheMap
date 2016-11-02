//
//  OTMClient.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/3/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class OTMClient: NSObject {
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
   
    func getSessionID(username: String, password: String, callingViewController: LoginViewController) -> Void {
   
        if let url = URL(string: "https://www.udacity.com/api/session") {
            callingViewController.activityIndicator.isHidden = false
            callingViewController.activityIndicator.startAnimating()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
            print(username)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) {data, response, error in
                
                guard let data = data else {
                    print("No data was returned by the request!")
                    callingViewController.activityIndicator.isHidden = true
                    callingViewController.activityIndicator.stopAnimating()
                    return
                }
                
                guard (error == nil) else {
                    print("There was an error with your request: \(error).")
                    callingViewController.activityIndicator.isHidden = true
                    callingViewController.activityIndicator.stopAnimating()
                    return
                }
                
                let newData = data.subdata(in: 5..<(data.count))
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue))
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    performUIUpdatesOnMain {
                        let alert = UIAlertController(title: "Alert", message: "Username and/or password are incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        callingViewController.present(alert, animated: true, completion: nil)
                        
                        callingViewController.activityIndicator.isHidden = true
                        callingViewController.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                print("Parsed Results: \(parsedResult)")
                
                guard let sessionDictionary = parsedResult[Constants.JSONResponseKeys.SessionDictionary] as? [String: String] else {
                    print("Cannot find SessionID in \(parsedResult)")
                    return
                }
                
                guard let accountDictionary = parsedResult[Constants.JSONResponseKeys.AccountDictionary] as? [String: AnyObject] else {
                    print("Cannot find the account dictionary in \(parsedResult)")
                    return
                }
                
                print("Session Dictionary: \(sessionDictionary)")
                print("Account Dictionary: \(accountDictionary)")
                
                let sessionID = sessionDictionary[Constants.JSONResponseKeys.SessionID]!
                let uniqueKey = accountDictionary[Constants.JSONResponseKeys.AccountKey]!
                
                StudentData.getSharedInstance().setUniqueKey(key: uniqueKey as! String)
                
                
                print("This is the sessionID: \(sessionID)")
                print("The unique key is: \(uniqueKey)")
                
                
                self.getStudentsLocations(completeLogin: callingViewController.completeLogin)

            }
            task.resume()
        }
   } 

    func getStudentsLocations(completeLogin: @escaping (Void) -> Void) {
        print("\n\n=========\nGetting student locations!===========\n\n")
        if let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt") {
            var request = URLRequest(url: url)
            request.addValue("\(Constants.ParseApplicationID)", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("\(Constants.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) {data, response, error in
               
                guard let data = data else {
                    print("No data was returned by the request.")
                    return
                }
                
                guard error == nil else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                let parsedResult: [String:AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    
                    var topController = UIApplication.shared.keyWindow!.rootViewController
                    while ((topController?.presentedViewController) != nil) {
                        topController = topController?.presentedViewController
                    }
                    
                    let alert = UIAlertController(title: "Alert", message: "Unable to retrieve the map data at this time.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    topController?.present(alert, animated: true, completion: nil)
                    
                    topController?.present(alert, animated: true, completion: nil)
                    
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let locationResults = parsedResult[Constants.JSONResponseKeys.StudentDictionaries] as! [[String: AnyObject]]? else {
                    print("Could not find key in \(parsedResult)")
                    return
                }
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
               
                var tempStudentArray =  Array<StudentData.StudentStruct>()
                for studentLocation in locationResults {
                    let tempData = StudentData.StudentStruct.init(studentLocation: studentLocation)
                        
                        tempStudentArray.append(tempData)
                }
                
                for student in tempStudentArray {
                    print(student)
                }
                
                StudentData.getSharedInstance().setStudentArray(studentArray: tempStudentArray)
                

                completeLogin()
                
            }
            task.resume()
        }
    }
    
    /*
    func getOneStudentsLocation() {
        
        if let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D") {
            var request = URLRequest(url: url)
            request.addValue("\(Constants.ParseApplicationID)", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("\(Constants.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) {data, response, error in
                
                guard let data = data else {
                    print("No data was returned by the request")
                    return
                }
                
                guard error == nil else {
                    print("There was an error with the request")
                    return
                }
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            }
            task.resume()
        }
    } */

    func deleteSession() {
        if let url = URL(string: "https://www.udacity.com/api/session") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let session = URLSession.shared
            let task = session.dataTask (with: request) {data, response, error in
                
                guard error == nil else {
                    print("There was an error with your request.")
                    return
                }
                
                guard let data = data else {
                    print("No data was returned by the request.")
                    return
                }
                
                let newData = data.subdata(in: 5..<(data.count))
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }                
            }
            task.resume()
        }
    }

    func getUserData() {
        if let url = URL(string: "https://www.udacity.com/api/users/\(StudentData.getSharedInstance().getUniqueKey())") {
            var request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                
                guard (error == nil) else {
                    print("There was an error with your request.")
                    return
                }
                
                guard let data = data else {
                    print("No data was returned by the request.")
                    return
                }
                
                let newData = data.subdata(in: 5..<(data.count))
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let userData = parsedResult["user"] as? [String: AnyObject] else {
                    print("Cannot find key 'user' in \(parsedResult)")
                    return
                }
                
                let firstName = userData[Constants.UserResponseKeys.UserFirstName]!
                let lastName = userData[Constants.UserResponseKeys.UserLastName]!
                
                StudentData.getSharedInstance().setFirstName(firstName: firstName as! String)
                StudentData.getSharedInstance().setLastName(lastName: lastName as! String)
                
                self.postStudentLocation(uniqueKey: StudentData.getSharedInstance().getUniqueKey(), locationData: StudentData.getSharedInstance().getMapString(), firstName: firstName as! String, lastName: lastName as! String, latitude: StudentData.getSharedInstance().getCoordinates().latitude, longitude: StudentData.getSharedInstance().getCoordinates().longitude, urlData: StudentData.getSharedInstance().getMediaURL())
            }
            task.resume()
        }
    }

    func postStudentLocation(uniqueKey: String, locationData: String, firstName: String, lastName: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, urlData: String) {
        if let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("\(Constants.ParseApplicationID)", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("\(Constants.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationData)\", \"mediaURL\": \"\(urlData)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
       
            let session = URLSession.shared
            let task = session.dataTask(with: request) {(data, response, error) in
                
                guard (error == nil) else {

                    print("There was an error with your post request.")
                    return
                }
                
                guard let data = data else {
                    print("No data was returned by the request.")
                    return
                }
                
                //let newData = data.subdata(in: 5..<(data.count))
                
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    DispatchQueue.main.async {

                        var topController = UIApplication.shared.keyWindow!.rootViewController! as UIViewController
                        while ((topController.presentedViewController) != nil) {
                            topController = topController.presentedViewController!
                        }
                        
                        let alert = UIAlertController(title: "Alert", message: "Unable to complete your request at this time.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        topController.present(alert, animated: true, completion: nil)
                    }
                    
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                POSTLinkVC.getSharedInstance().segueToMapView()
                
                //let controller = POSTLinkVC.getSharedInstance().presentViewController(withIdentifier: "TabBarController") as UITabBarController
                //POSTLinkVC.getSharedInstance().present(controller, animated: true, completion: nil)
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            }
            task.resume()
        }
        
    }
    
    func layoutButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.blue.cgColor
    }


    //DELETE POSTS BY COORDINATES/OBJECTID
    /*
    func findUserByCoord(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Void {
        let students = StudentData.getSharedInstance().getStudentArray()
        var usersObjectIDs = Set<String>()
        
        for student in students {
            if student.latitude == latitude && student.longitude == longitude {
                usersObjectIDs.insert(student.objectID!)
            } else {}
        }
        
        for userObjectID in usersObjectIDs {
            deleteUserByObjectID(objectID: userObjectID)
        }
    }
    
    func deleteUserByObjectID(objectID: String) {
        if let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("\(Constants.ParseApplicationID)", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("\(Constants.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) {(data, response, error) in
                
                guard (error == nil) else {
                    print("There was an error with your post request.")
                    return
                }
                
                guard let data = data else {
                    print("No data was returned by the request.")
                    return
                }
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            }
            task.resume()
        }
    }
    */
}
