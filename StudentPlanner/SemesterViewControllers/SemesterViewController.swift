//
//  SemesterViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit
class SemesterViewController: UITableViewController {
    var semester: Semester?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    let startDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let endDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isStartDatePickerShown: Bool = false {
        didSet{
            startDatePicker.isHidden = !isStartDatePickerShown
        }
    }
    
    var isEndDatePickerShown: Bool = false {
        didSet{
            endDatePicker.isHidden = !isEndDatePickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let semester = semester {
            nameTextField.text = semester.name
            startDatePicker.date = semester.startDate
            endDatePicker.date = semester.endDate
            navigationItem.title = "Semester"
        } else {
            let midnigthTonight = Calendar.current.startOfDay(for: Date())
            startDatePicker.date = midnigthTonight
        }
        
        updateSaveButton()
        updateDateViews()
    }
    
    func updateSaveButton(){
        let name = nameTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty
    }
  
    func updateDateViews() {
        endDatePicker.minimumDate = startDatePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        startDateLabel.text = dateFormatter.string(from: startDatePicker.date)
        endDateLabel.text = dateFormatter.string(from: endDatePicker.date)
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (startDatePickerCellIndexPath.section, startDatePickerCellIndexPath.row):
            if isStartDatePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (endDatePickerCellIndexPath.section, endDatePickerCellIndexPath.row):
            if isEndDatePickerShown {
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
        case (startDatePickerCellIndexPath.section, startDatePickerCellIndexPath.row - 1):
            
            if isStartDatePickerShown {
                isStartDatePickerShown = false
            } else if isEndDatePickerShown {
                isEndDatePickerShown = false
                isStartDatePickerShown = true
            } else {
                isStartDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (endDatePickerCellIndexPath.section, endDatePickerCellIndexPath.row - 1):
            
            if isEndDatePickerShown {
                isEndDatePickerShown = false
            } else if isStartDatePickerShown {
                isStartDatePickerShown = false
                isEndDatePickerShown = true
            } else {
                isEndDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveSemesterUnwind" else {return}

            let name = nameTextField.text!
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            
            semester = Semester(name: name, startDate: startDate, endDate: endDate)
        
        
    }
    
    
    
    
    // MARK: - Action
    
    @IBAction func TextEditChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func returnTapped(_ sender: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    
}
