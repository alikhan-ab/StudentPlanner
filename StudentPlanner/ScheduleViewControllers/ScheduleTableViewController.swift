//
//  ScheduleTableViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/28/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let classInfoControler = ClassInfroController()
    
    let a = ClassCourse(aC)
    var classes: [[ClassCourse]] = [[],[],[],[],[],[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
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
        let selectedDay = segmentedControl.selectedSegmentIndex
        return classes[selectedDay].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "classForDayCell", for: indexPath) as? ClassScheduleCell else {fatalError("Couldn't dequeue class schedule cell")}
    
        let day = segmentedControl.selectedSegmentIndex
        
        let aClass = classes[day][indexPath.row].aClass
        let course = classes[day][indexPath.row].course
        let instructName = classes[day][indexPath.row].instructorName
        
        cell.startTimeLabel.text = Class.dateFormatter.string(from: aClass.startTime)
        cell.endTimeLabel.text = Class.dateFormatter.string(from: aClass.endTime)
        cell.courseAbbrLabel.text = course.abbreviation
        cell.locationLabel.text = aClass.location ?? " "
        
        var typeInstructorString: String = ""
        if let type = aClass.type {
            typeInstructorString = type
        }
        if let instructorName = instructName {
            typeInstructorString = typeInstructorString + ", " + instructorName
        }
        cell.typeLabel.text = typeInstructorString
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTables()
    }
 

    func updateTables() {
        for i in 0...6 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            ClassCourse.fetchClasses(for: i, completion: { (classCourses) in
                if let classCourses = classCourses {
                    DispatchQueue.main.async {
                        self.classes[i] = classCourses
                        if i == 6 {
                            self.tableView.reloadData()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                    
                }
            })
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
    
    
    // MARK: - Action
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        updateTables()
    }
    

}
