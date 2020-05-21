//
//  ClassSelectInstructorTableViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/28/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class ClassSelectInstructorTableViewController: UITableViewController {
    
    var instructors: [Instructor] = []
    var selectedInstructor: Instructor?
    
    let instructorInfoController = PeopleInfoController()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTables()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateTables() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        instructorInfoController.fetchInstructors { (instructors) in
            if let instructors = instructors {
                DispatchQueue.main.async {
                    self.instructors = instructors
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectInstructorCell", for: indexPath)
        
        let instructor = instructors[indexPath.row]
        cell.textLabel?.text = instructor.name
        cell.detailTextLabel?.text = instructor.email

        return cell
    }
 







    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noOneUnwind" {
            selectedInstructor = nil
        } else if segue.identifier == "selectedInstructorUnwind" {
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            selectedInstructor = instructors[selectedIndexPath.row]
        }
    }
}
