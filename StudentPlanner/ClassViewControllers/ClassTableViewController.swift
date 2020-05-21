//
//  ClassTableViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/27/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class ClassTableViewController: UITableViewController {
    
    var semester: Semester?
    var course: Course?
    var classes: [Class] = []
    let classInfoController = ClassInfroController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CourseTableViewController.didTapAddButton))
        navigationItem.rightBarButtonItems = [addButton, editButton]
        
        updataTables()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func didTapAddButton(){
        performSegue(withIdentifier: "addClass", sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as? ClassCell else { fatalError("Couldn;t dequeue a class cell")}
    
        let selectedClass = classes[indexPath.row]
        cell.timeLabel?.text = Class.dateFormatter.string(from: selectedClass.startTime) + " - " + Class.dateFormatter.string(from: selectedClass.endTime)
        cell.dayLabel?.text = " " + Class.dayOfTheWeek(day: selectedClass.day) + "        "
        let type = selectedClass.type ?? " "
        cell.typeLabel?.text = " " + type
        return cell
    }
 

 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            classInfoController.delete(aClass: classes[indexPath.row], of: course!, in: semester!, completion: { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.classes.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })
            // Delete the row from the data source
        }
    }
 
    
    func updataTables() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        classInfoController.fetchClasses(for: self.semester!, and: self.course!) { (classes) in
            if let classes = classes {
                DispatchQueue.main.async {
                    self.classes = classes
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
        }
    }


    
    // MARK: - Navigation
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClassDetails" {
            let aClassVC = segue.destination as! ClassViewController
            let indexPath = tableView.indexPathForSelectedRow!
            aClassVC.aClass = classes[indexPath.row]
        }
    }
 
    
    @IBAction func unwindToClassList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveClassUnwind" else {return}
        let sourceVC = segue.source as! ClassViewController
        if let newClass = sourceVC.aClass {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                classInfoController.update(aClass: classes[selectedIndexPath.row], with: newClass, of: course!, in: semester!, completion: { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.updataTables()
                        }
                    }
                })
            } else {
                classInfoController.add(aClass: newClass, of: course!, in: semester!, completion: { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.updataTables()
                        }
                    }
                })
            }
        }
    }
    
    

}
