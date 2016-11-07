//
//  ListViewController.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/6/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var students = StudentData.getSharedInstance().getStudentArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.students = StudentData.getSharedInstance().getStudentArray()
        tableView.reloadData()
    }
    
    @IBAction func refreshButton(_ sender: AnyObject) {
        self.students = StudentData.getSharedInstance().getStudentArray()
        self.tableView.reloadData()
    }
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        OTMClient.sharedInstance().deleteSession()

        let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.students.count <= 100) {
            return self.students.count
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")! as UITableViewCell
        let fullName = "\(students[indexPath.row].firstName!) " + "\(students[indexPath.row].lastName!)"
        cell.textLabel?.text = fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let url = URL(string: "\(students[indexPath.row].mediaURL!)") {
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "The website cannot be reached.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("\n\n=====\n URL is Invalid \n=====\n\n")
            }
        } else {
            print("\n\n==============\nThere is no URL provided.\n===================\n\n")
        }
    }

}
