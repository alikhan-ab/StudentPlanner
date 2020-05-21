//
//  PeopleViewController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/25/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    let peopleInfoController = PeopleInfoController()
    
    var instructors: [Instructor] = []
    var partners: [Partner] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = tabBarItem.title
        updateTables()
//        instructors = Instructor.generateData()
//        partners = Partner.generateData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - HTTP requests
    
    
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            returnValue = instructors.count
        case 1:
            returnValue = partners.count
        default:
            break
        }
        
        return returnValue
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            let instructor = instructors[indexPath.row]
            cell.textLabel?.text = instructor.name
            cell.detailTextLabel?.text = instructor.email
        case 1:
            let partner = partners[indexPath.row]
            cell.textLabel?.text = partner.name
            cell.detailTextLabel?.text = partner.email
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            performSegue(withIdentifier: "showInstructorDetails", sender: self)
        case 1:
            performSegue(withIdentifier: "showPartnerDetails", sender: self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            switch(segmentedControl.selectedSegmentIndex) {
            case 0:
                peopleInfoController.deleteInstructor(instructor: instructors[indexPath.row], completion: { (result) in
                    if result == true {
                        DispatchQueue.main.async {
                            self.instructors.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                })
            case 1:
                peopleInfoController.deletePartner(partner: partners[indexPath.row], completion: { (result) in
                    if result == true {
                        DispatchQueue.main.async {
                            self.partners.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                })
                
            default:break
            }
        }
    }
    
    
    func updateTables() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        peopleInfoController.fetchInstructors { (instructors) in
            if let instructors = instructors {
                DispatchQueue.main.async {
                    self.instructors = instructors
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        peopleInfoController.fetchPartners(completion: ({ (partners) in
            if let partners = partners {
                DispatchQueue.main.async {
                    self.partners = partners
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }))
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func unwindToPeopleList(segue: UIStoryboardSegue) {
        if segue.identifier == "saveInstructorUnwind" {
            let sourceViewController = segue.source as! InstructorViewController
            
            if let instructor = sourceViewController.instructor {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    peopleInfoController.updateInstructor(primaryEmail: instructors[selectedIndexPath.row].email, instructor: instructor, completion: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.updateTables()
                                
                                // notification that updated
                            }
                        }
                    })
//                    instructors[selectedIndexPath.row] = instructor
//                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    // DB: update Instructor
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    peopleInfoController.addInstructor(instructor: instructor, completion: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.updateTables()
                                // notification that updated
                            }
                        }
                    })
                }
            }
        } else if segue.identifier == "savePartnerUnwind" {
            let sourceViewController = segue.source as! PartnerViewController

            if let partner = sourceViewController.partner {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    peopleInfoController.updatePartner(primaryEmail: partners[selectedIndexPath.row].email, partner: partner, completion: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.updateTables()
                                // notification that updated
                            }
                        }
                    })
//                    partners[selectedIndexPath.row] = partner
//                    tableView.insertRows(at: [selectedIndexPath], with: .none)
                } else {
                    peopleInfoController.addPartner(partner: partner, completion: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.updateTables()
                            }
                        }
                    })
//                    let newIndexPath = IndexPath(row: partners.count, section: 0)
//                    partners.append(partner)
//                    tableView.insertRows(at: [newIndexPath], with: .automatic)
//                    // DB: add partner
                }
            }
        } else {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInstructorDetails" {
            let instructorVC = segue.destination as! InstructorViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedInstructor = instructors[indexPath.row]
            instructorVC.instructor =  selectedInstructor
        } else if segue.identifier == "showPartnerDetails" {
            let partnerVC = segue.destination as! PartnerViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedPartner = partners[indexPath.row]
            partnerVC.partner = selectedPartner
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        switch(segmentedControl.selectedSegmentIndex) {
        case 0:
            self.performSegue(withIdentifier: "addInstructor", sender: self)
            
        case 1:
            self.performSegue(withIdentifier: "addPartner", sender: self)
        default:
            break
        }
    }
    
    @IBAction func segmentedControlActionChanged(_ sender: Any) {
        tableView.reloadData()
    }
}
