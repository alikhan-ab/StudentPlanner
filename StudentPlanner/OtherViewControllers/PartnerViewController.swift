//
//  PartnerViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/25/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class PartnerViewController: UITableViewController {
    
    var partner: Partner?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let partner = partner {
            navigationItem.title = "Partner"
            nameTextField.text = partner.name
            emailTextField.text = partner.email
            phoneNumberTextField.text = partner.phoneNumber
        }
        updateSaveButton()
    }
    
    func updateSaveButton() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !email.isEmpty
    }
    
    // MARK: - Action
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "savePartnerUnwind" else {return}
        
        let name = nameTextField.text!
        let email = emailTextField.text!
        let phoneNumber = phoneNumberTextField.text
        
        partner = Partner(email: email, name: name, phoneNumber: phoneNumber)
    }
    
}
