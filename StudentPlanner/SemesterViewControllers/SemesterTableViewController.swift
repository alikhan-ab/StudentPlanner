//
//  SemesterTableViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit


class SemesterTableViewController: UITableViewController {
    
    var semesters: [Semester] = []
    let semesterInfoController = SemesterInfoController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsSelectionDuringEditing = true
        updateTables()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "semesterCell", for: indexPath)
        let semester = semesters[indexPath.row]
        cell.textLabel?.text = semester.name
        cell.detailTextLabel?.text = Semester.dateFormater.string(from: semester.startDate) + " - " + Semester.dateFormater.string(from: semester.endDate)
        return cell
    }
 

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
            semesterInfoController.deleteSemester(semester: semesters[indexPath.row], completion: { (result) in
                if result == true {
                    DispatchQueue.main.async {
                        self.semesters.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                         UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            performSegue(withIdentifier: "showSemesterDetails", sender: self)
        } else {
            performSegue(withIdentifier: "showCourses", sender: self)
        }
    }
    
    func updateTables() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        semesterInfoController.fetchAllSemesters { (semesters) in
            if let semesters = semesters{
                DispatchQueue.main.async {
                    self.semesters = semesters
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
        }
    }
 



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourses" {
            let courseTableVC = segue.destination as! CourseTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            courseTableVC.semester = semesters[indexPath.row]
        } else if segue.identifier == "showSemesterDetails" {
            let semesterVC = segue.destination as! SemesterViewController
            let indexPath = tableView.indexPathForSelectedRow!
            semesterVC.semester = semesters[indexPath.row]
        }
    }
    
    
    @IBAction func unwindToSemesterList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSemesterUnwind" else {return}
        let sourceVC = segue.source as! SemesterViewController
            
        if let semester = sourceVC.semester {
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                semesterInfoController.update(semester: semesters[selectedIndexPath.row], by: semester, completion: { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.updateTables()
                            // notification that updated
                        }
                    }
                })
            } else {
                semesterInfoController.add(semester: semester, completion: { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.updateTables()
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Action
    
    
    
    
    
    

}
