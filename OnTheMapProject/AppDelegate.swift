//
//  AppDelegate.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/3/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import UIKit

// I followed a tutorial on using Reachability on YouTube at: https://www.youtube.com/watch?v=BlBhHgoW9wM
/*
let reachableWithWifi = "ReachableWithWifi"
let notReachable = "NotReachable"
let reachableWithWWAN = "ReachableWithWWAN"

var reachability: Reachability?
var reachabilityStatus = reachableWithWifi
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var internetReach: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        internetReach = Reachability.forInternetConnection()
        internetReach?.startNotifier()
        if internetReach != nil {
            self.statusChangedWithReachability(currentReachabilityStatus: internetReach!)
        }
        */
        return true
    }
    /*
    func reachabilityChanged(notification: NSNotification) {
        print("Reachability Status changed")
        reachability = notification.object as? Reachability
        self.statusChangedWithReachability(currentReachabilityStatus: reachability!)
    }

    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        var networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
        var statusString: String = ""
        
        if networkStatus.rawValue == NotReachable.rawValue {
            print("Network Not Reachable")
            reachabilityStatus = notReachable
        } else if networkStatus.rawValue == ReachableViaWiFi.rawValue {
            print("Reachable with Wifi")
            reachabilityStatus = reachableWithWifi
        } else if networkStatus.rawValue == ReachableViaWWAN.rawValue {
            print("Reachable with WWAN")
            reachabilityStatus = reachableWithWWAN
        }
        
        //print("StatusValue: \(networkStatus.rawValue)")
    }
    */
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
    }


}

