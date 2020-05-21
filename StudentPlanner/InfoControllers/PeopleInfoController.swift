//
//  PeopleInfoController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
class PeopleInfoController {
    
    func fetchInstructors(completion: @escaping ([Instructor]?) -> Void) {
        
        struct AllInstructors: Codable {
            let instructors: [Instructor]
        }
        
        let baseUrl = URL(string:"http://student-planner2344.tk/api/selectAll.php")!
        let query: [String: String] = ["table":"instructor"]
        
        let url = baseUrl.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let allInstructors = try? jsonDecoder.decode(AllInstructors.self, from: data) {
                completion(allInstructors.instructors)
            } else {
                print("something went wrong1")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
    
    func fetchPartners(completion: @escaping ([Partner]?) -> Void) {
        
        struct AllPartners: Codable {
            let partners: [Partner]
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/selectAll.php")!
        let query: [String: String] = ["table": "partner"]
        let url = baseUrl.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let allPartners = try? jsonDecoder.decode(AllPartners.self, from: data) {
                completion(allPartners.partners)
            } else {
                print("something went wrong2")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
    
    func fetchInstructor(for aClass: Class, completion: @escaping ([Instructor]?) -> Void) {
        struct SelectedInstructor: Codable {
            let instructor: [Instructor]
        }
    
        let baseUrl = URL(string:"http://student-planner2344.tk/api/select.php")!
        let query: [String: String] = ["kind":"instructorForClass", "email":"\(aClass.instructorEmail!)"]
        
        let url = baseUrl.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let selectedInstructor = try? jsonDecoder.decode(SelectedInstructor.self, from: data) {
                completion(selectedInstructor.instructor)
            } else {
                print("something went wrong with fetch instructor for a class")
                completion(nil)
                return
            }
        }
        
        task.resume()
        
    }
    
    func updateInstructor(primaryEmail: String, instructor: Instructor, completion: @escaping (Bool) -> Void) {
        
        let emailTo = instructor.email
        let nameTo = instructor.name
        var officeTo: String
        if instructor.officeLocation == nil {
            officeTo = ""
        } else {
            officeTo = instructor.officeLocation!
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/update.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=instructor"+"&email="+primaryEmail+"&emailTo="+emailTo+"&nameTo="+nameTo+"&officeTo="+officeTo;
        requestURL.httpBody = postParameters.data(using: .utf8)!
    
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, responce, error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func updatePartner(primaryEmail: String, partner: Partner, completion: @escaping (Bool) -> Void) {
        
        let emailTo = partner.email
        let nameTo = partner.name
        var phoneTo: String
        if partner.phoneNumber == nil {
            phoneTo = ""
        } else {
            phoneTo = partner.phoneNumber!
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/update.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=partner"+"&email="+primaryEmail+"&emailTo="+emailTo+"&nameTo="+nameTo+"&phoneTo="+phoneTo;
        requestURL.httpBody = postParameters.data(using: .utf8)!
        
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, responce, error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func addInstructor(instructor: Instructor, completion: @escaping (Bool) -> Void) {
        
        let email = instructor.email
        let name = instructor.name
        var office: String
        if instructor.officeLocation == nil {
            office = ""
        } else {
            office = instructor.officeLocation!
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/add.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=instructor"+"&email="+email+"&name="+name+"&office="+office;
        requestURL.httpBody = postParameters.data(using: .utf8)!
        
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, responce, error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func addPartner(partner: Partner, completion: @escaping (Bool) -> Void) {
        
        let email = partner.email
        let name = partner.name
        var phoneNumber: String
        if partner.phoneNumber == nil {
            phoneNumber = ""
        } else {
            phoneNumber = partner.phoneNumber!
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/add.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=partner"+"&email="+email+"&name="+name+"&phone="+phoneNumber
        requestURL.httpBody = postParameters.data(using: .utf8)!
        
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, responce, error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    
    func deleteInstructor(instructor: Instructor, completion: @escaping (Bool) -> Void) {
        let email = instructor.email
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/delete.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=instructor"+"&email="+email;
        requestURL.httpBody = postParameters.data(using: .utf8)!
        
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, responce, error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
        
    }
    
    func deletePartner(partner: Partner, completion: @escaping (Bool) -> Void) {
        let email = partner.email
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/delete.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=partner"+"&email="+email;
        requestURL.httpBody = postParameters.data(using: .utf8)!
        
    
        let task = URLSession.shared.dataTask(with: requestURL) { (data, responce, error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
        
    }
    
    
}
