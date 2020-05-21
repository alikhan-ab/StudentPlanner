//
//  InstructorViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/25/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class InstructorViewController: UITableViewController {
    
    var instructor: Instructor?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var officeLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let instructor = instructor {
            navigationItem.title = "Instructor"
            nameTextField.text = instructor.name
            emailTextField.text = instructor.email
            officeLocationTextField.text = instructor.officeLocation
        }
        updateSaveButtonState()
    }
    
    
    
    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !email.isEmpty
        
    }
    
    // MARK: - Action
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveInstructorUnwind" else {return}
        
        let name = nameTextField.text!
        let email = emailTextField.text!
        let officeLocation = officeLocationTextField.text
        
        instructor = Instructor(email: email, name: name, officeLocation: officeLocation)
    }
    
    
}
