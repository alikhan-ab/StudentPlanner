//
//  CourseViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/27/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class CourseViewController: UITableViewController {
    var course: Course?
    
    
    @IBOutlet weak var abbrTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        if let course = course {
            navigationItem.title = "Course"
            abbrTextField.text = course.abbreviation
            nameTextField.text = course.name
        }
        
        updateSaveButtom()
    }
    
    func updateSaveButtom(){
        let abbr = abbrTextField.text ?? ""
        saveButton.isEnabled = !abbr.isEmpty
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveCourseUnwind" else {return}
        
        let abbr = abbrTextField.text!
        let name = nameTextField.text
        
        course = Course(abbreviation: abbr, name: name)
    }
    
    
    // MARK: - Action
    @IBAction func editingChanged(_ sender: Any) {
        updateSaveButtom()
    }
    
    @IBAction func returenTapped(_ sender: Any) {
        abbrTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
}
