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

let notificationKey = "alertViewPosted"

class OTMClient: NSObject {
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getSessionID(username: String, password: String, callingViewController: LoginViewController) -> Void {
   
        func hideActivityIndicator() {
            callingViewController.activityIndicator.isHidden = true
            callingViewController.activityIndicator.stopAnimating()
        }
        
        if let url = URL(string: "https://www.udacity.com/api/session") {
            callingViewController.activityIndicator.isHidden = false
            callingViewController.activityIndicator.startAnimating()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) {data, response, error in
                
                guard let data = data else {
                    
                    DispatchQueue.main.async {
                        self.appDelegate.alertView(errorMessage: "OnTheMap is experiencing technical difficulties. Please try again later.", viewController: callingViewController)
                        hideActivityIndicator()
                        callingViewController.loginButton.isEnabled = true
                    }
                    
                    print("No data was returned by the request!")
                    return
                }
                
                guard (error == nil) else {
                    
                    DispatchQueue.main.async {
                        self.appDelegate.alertView(errorMessage: "OnTheMap is experiencing technical difficulties. Please try again later.", viewController: callingViewController)
                        hideActivityIndicator()
                        callingViewController.loginButton.isEnabled = true
                    }
                    
                    print("There was an error with your request: \(error).")
                    return
                }
                
                let newData = data.subdata(in: 5..<(data.count))
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue))
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {

                    DispatchQueue.main.async {
                        self.appDelegate.alertView(errorMessage: "Username and/or password are incorrect.", viewController: callingViewController)
                        hideActivityIndicator()
                        callingViewController.loginButton.isEnabled = true
                    }
                    return
                }
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
                } catch {

                    DispatchQueue.main.async {
                        self.appDelegate.alertView(errorMessage: "OnTheMap is experiencing technical difficulties. Please try again later.", viewController: callingViewController)
                        hideActivityIndicator()
                    }
                    
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let sessionDictionary = parsedResult[Constants.JSONResponseKeys.SessionDictionary] as? [String: String] else {
                    
                    DispatchQueue.main.async {
                        self.appDelegate.alertView(errorMessage: "OnTheMap is experiencing technical difficulties. Please try again later.", viewController: callingViewController)
                        hideActivityIndicator()
                    }
              
                    print("Cannot find SessionID in \(parsedResult)")
                    return
                }
                
                guard let accountDictionary = parsedResult[Constants.JSONResponseKeys.AccountDictionary] as? [String: AnyObject] else {
                    
                    DispatchQueue.main.async {
                        self.appDelegate.alertView(errorMessage: "OnTheMap is experiencing technical difficulties. Please try again later.", viewController: callingViewController)
                        hideActivityIndicator()
                    }
                    
                    print("Cannot find the account dictionary in \(parsedResult)")
                    return
                }

                
                let sessionID = sessionDictionary[Constants.JSONResponseKeys.SessionID]!
                let uniqueKey = accountDictionary[Constants.JSONResponseKeys.AccountKey]!
                
                StudentData.getSharedInstance().setUniqueKey(key: uniqueKey as! String)
                
                self.getStudents(completion: callingViewController.completion)

            }
            task.resume()
        }
   }

    func getStudents(completion: @escaping (Void) -> Void) {
        print("\n\n========= Getting student locations! ===========\n\n")
        if let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt") {
            var request = URLRequest(url: url)
            request.addValue("\(Constants.ParseApplicationID)", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("\(Constants.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) {data, response, error in
               
                guard let data = data else {
                    self.appDelegate.alertViewTwo(errorMessage: "Unable to retrieve the map data at this time. Please try again later.")
                    
                    print("No data was returned by the request.")
                    return
                }
                
                guard error == nil else {
                    self.appDelegate.alertViewTwo(errorMessage: "There was an error with your request. Please try again later.")
                    
                    print("There was an error with your request: \(error)")
                    return
                }
                
                let parsedResult: [String:AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    self.appDelegate.alertViewTwo(errorMessage: "Unable to retrieve the map data at this time. Please try again later.")
                    
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let locationResults = parsedResult[Constants.JSONResponseKeys.StudentDictionaries] as! [[String: AnyObject]]? else {
                    self.appDelegate.alertViewTwo(errorMessage: "There was an error with your request. Please try again later.")
                    
                    print("Could not find key in \(parsedResult)")
                    return
                }
                
               // print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
               
                var tempStudentArray =  Array<StudentData.StudentStruct>()
                
                for studentLocation in locationResults {
                    let tempData = StudentData.StudentStruct.init(studentLocation: studentLocation)
                    tempStudentArray.append(tempData)
                }
                
                StudentData.getSharedInstance().setStudentArray(studentArray: tempStudentArray)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
            task.resume()
        }
    }
    
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

    func postLocationData(completion: @escaping () -> Void) {
        if let url = URL(string: "https://www.udacity.com/api/users/\(StudentData.getSharedInstance().getUniqueKey())") {
            var request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                
                guard (error == nil) else {
                    self.appDelegate.alertViewTwo(errorMessage: "An error has occurred. Please try again later.")
                    
                    print("There was an error with your request.")
                    return
                }
                
                guard let data = data else {
                    self.appDelegate.alertViewTwo(errorMessage: "An error has occurred. Please try again later.")
                    print("No data was returned by the request.")
                    return
                }
                
                let newData = data.subdata(in: 5..<(data.count))
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    self.appDelegate.alertViewTwo(errorMessage: "An error has occurred. Please try again later.")
                    
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let userData = parsedResult["user"] as? [String: AnyObject] else {
                    self.appDelegate.alertViewTwo(errorMessage: "Your account cannot be found. Please try again.")
                    
                    print("Cannot find key 'user' in \(parsedResult)")
                    return
                }
                
                let firstName = userData[Constants.UserResponseKeys.UserFirstName]!
                let lastName = userData[Constants.UserResponseKeys.UserLastName]!
                
                StudentData.getSharedInstance().setFirstName(firstName: firstName as! String)
                StudentData.getSharedInstance().setLastName(lastName: lastName as! String)
                
                self.postCompleteLocationData(uniqueKey: StudentData.getSharedInstance().getUniqueKey(),
                                         locationData: StudentData.getSharedInstance().getMapString(),
                                         firstName: firstName as! String,
                                         lastName: lastName as! String,
                                         latitude: StudentData.getSharedInstance().getCoordinates().latitude,
                                         longitude: StudentData.getSharedInstance().getCoordinates().longitude,
                                         urlData: StudentData.getSharedInstance().getMediaURL(),
                                         completion: completion
                                         )
            }
            task.resume()
        }
    }

    private func postCompleteLocationData(uniqueKey: String, locationData: String, firstName: String, lastName: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, urlData: String, completion: @escaping () -> Void) {
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
                    self.appDelegate.alertViewTwo(errorMessage: "An error has occurred. Please try again later.")
                    print("There was an error with your post request.")
                    return
                }
                
                guard let data = data else {
                    self.appDelegate.alertViewTwo(errorMessage: "An error has occurred. Please try again later.")
                    print("No data was returned by the request.")
                    return
                }
                
                let parsedResult: [String: AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                } catch {
                    self.appDelegate.alertViewTwo(errorMessage: "Unable to complete your request at this time.")
                    
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                
                self.getStudents(completion: completion)
            }
            task.resume()
        }
        
    }
    
    func layoutButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.blue.cgColor
    }

}
 
