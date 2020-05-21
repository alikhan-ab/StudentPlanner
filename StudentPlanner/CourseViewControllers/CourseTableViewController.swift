//
//  CourseTableViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/27/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {
    
    var semester: Semester?
    var courses: [Course] = []
    let courseInfoController = CourseInfroController()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let editButton = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CourseTableViewController.didTapAddButton))
        navigationItem.rightBarButtonItems = [addButton, editButton]
        tableView.allowsSelectionDuringEditing = true
        updateTables()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didTapAddButton(){
        performSegue(withIdentifier: "addCourse", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.name
        cell.detailTextLabel?.text = course.abbreviation
        return cell
    }
 


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            courseInfoController.delete(course: courses[indexPath.row], in: semester!, completion: { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.courses.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            performSegue(withIdentifier: "showCourseDetails", sender: self)
        } else {
            performSegue(withIdentifier: "showClasses", sender: self)
        }
    }

    
    func updateTables() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        courseInfoController.fetchCourses(for: semester!) { (courses) in
            if let courses = courses {
                DispatchQueue.main.async {
                    self.courses = courses
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
        }
    }


    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClasses" {
            let classesVC = segue.destination as! ClassTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            classesVC.course = courses[indexPath.row]
            classesVC.semester = semester
        } else if segue.identifier == "showCourseDetails" {
            let courseVC = segue.destination as! CourseViewController
            let indexPath = tableView.indexPathForSelectedRow!
            courseVC.course = courses[indexPath.row]
        }
    }
    
    @IBAction func unwindToCourseList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveCourseUnwind" else {return}
        let sourceVC = segue.source as! CourseViewController
        if let course = sourceVC.course {
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                courseInfoController.update(course: courses[selectedIndexPath.row], in: semester!, with: course, completion: { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.updateTables()
                        }
                    }
                })
                
            } else {
                courseInfoController.add(course: course, in: semester!, completion: { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.updateTables()
                        }
                    }
                })
            }
                
        }
    }
}
