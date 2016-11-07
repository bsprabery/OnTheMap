//
//  AppDelegate.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/3/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var internetReach: Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func alertView(errorMessage: String, viewController: UIViewController) {
        
        let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func alertViewTwo(errorMessage: String) {
        DispatchQueue.main.async {
            var topController = UIApplication.shared.keyWindow!.rootViewController
            while ((topController?.presentedViewController) != nil) {
                topController = topController?.presentedViewController
            }
            
            let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            topController?.present(alert, animated: true, completion: nil)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        }
    }
}

