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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func refreshButton(_ sender: AnyObject) {
        tableView.reloadData()
        print("Refresh Button List Clicked")
    }
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        OTMClient.sharedInstance().deleteSession()
        completeLogout()
    }
    
    func completeLogout() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    let students = StudentData.getSharedInstance().getStudentArray()
    
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
        //This text label needs to be moved to the right:
        cell.textLabel?.text = fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: "\(students[indexPath.row].mediaURL)") {
            UIApplication.shared.open(url, options: [:])
        }
        
        
    }
}
