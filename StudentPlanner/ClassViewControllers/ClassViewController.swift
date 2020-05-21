//
//  ClassViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/27/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit
class ClassViewController: UITableViewController {
    
    let instructorInfoController = PeopleInfoController()
    
    var aClass: Class?
    var instructor: Instructor?
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var daySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var instructorTextField: UILabel!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let startTimePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let endTimePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isStartTimePickerShown: Bool = false {
        didSet{
            startTimePicker.isHidden = !isStartTimePickerShown
        }
    }
    
    var isEndTimePickerShown: Bool = false {
        didSet{
            endTimePicker.isHidden = !isEndTimePickerShown
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let aClass = aClass{
            navigationItem.title = "Class"
            startTimePicker.date = aClass.startTime
            endTimePicker.date = aClass.endTime
            typeTextField.text = aClass.type
            locationTextField.text = aClass.location
            daySegmentedControl.selectedSegmentIndex = aClass.day
            if aClass.instructorEmail != nil {
                saveButton.isEnabled = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                instructorInfoController.fetchInstructor(for: aClass, completion: { (result) in
                    if let result = result, !result.isEmpty  {
                        DispatchQueue.main.async {
                            self.instructor = result[0]
                            self.updateInstructorLabel()
                            self.saveButton.isEnabled = true
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                })
            }
        }
        updateTimeViews()
    }
    
    func updateTimeViews() {
        endTimePicker.minimumDate = startTimePicker.date
        
        startTimeLabel.text = Class.dateFormatter.string(from: startTimePicker.date)
        endTimeLabel.text = Class.dateFormatter.string(from: endTimePicker.date)
    }
    
    func updateInstructorLabel() {
        instructorTextField.text = instructor?.name ?? nil
    }
    
    
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (startTimePickerCellIndexPath.section, startTimePickerCellIndexPath.row):
            if isStartTimePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (endTimePickerCellIndexPath.section, endTimePickerCellIndexPath.row):
            if isEndTimePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (startTimePickerCellIndexPath.section, startTimePickerCellIndexPath.row - 1):
            
            if isStartTimePickerShown {
                isStartTimePickerShown = false
            } else if isEndTimePickerShown {
                isEndTimePickerShown = false
                isStartTimePickerShown = true
            } else {
                isStartTimePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (endTimePickerCellIndexPath.section, endTimePickerCellIndexPath.row - 1):
            
            if isEndTimePickerShown {
                isEndTimePickerShown = false
            } else if isStartTimePickerShown {
                isStartTimePickerShown = false
                isEndTimePickerShown = true
            } else {
                isEndTimePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveClassUnwind" else {return}
        
        let day = daySegmentedControl.selectedSegmentIndex
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        let type = typeTextField.text
        let location = locationTextField.text
        let instructorEmail = instructor?.email ?? nil
        
        
        aClass = Class(day: day, startTime: startTime, endTime: endTime, type: type, location: location, instructorEmail: instructorEmail)
    }
    
    @IBAction func unwindToClassView(segue: UIStoryboardSegue){
        if segue.identifier == "noOneUnwind" {
            instructor = nil
            updateInstructorLabel()
        } else {
            let sourceVC = segue.source as! ClassSelectInstructorTableViewController
            instructor = sourceVC.selectedInstructor
            updateInstructorLabel()
        }
        
    }
    
    
    
    
    
    // MARK: - Action
    
    @IBAction func timePickerValueChanged(_ sender: UIDatePicker) {
        updateTimeViews()
    }
    
    @IBAction func returnTapped(_ sender: UITextField) {
        typeTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
    }
    
    
    
}
