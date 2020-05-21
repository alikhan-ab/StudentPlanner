//
//  AssignmentTableViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/28/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class AssignmentTableViewController: UITableViewController {
    
    var assignments: [Assignmnet] = []
    let assignmentInfoController = AssignmnetInfoController()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTables()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func updateTables() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        assignmentInfoController.fetchAllAssignments { (assignments) in
            if let assignments = assignments {
                DispatchQueue.main.async {
                    self.assignments = assignments
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as? AssignmnetCell else {fatalError("Couldn't dequeue class schedule cell")}

        let assignment = assignments[indexPath.row]
        cell.titleLabel.text = assignment.title
        cell.courseAbbrLabel.text = assignment.courseAbbr
        cell.dueDateLabel.text = Assignmnet.dateFormater.string(from: assignment.dueDateTime)
        
        if assignment.isComplete {
            cell.isCompleteLabel.text = "✅"
        } else {
            cell.isCompleteLabel.text = "◻️"
        }
        
        return cell
    }
 



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
