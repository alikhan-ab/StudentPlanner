//
//  SemesterInfoController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
class SemesterInfoController {
    
    func fetchAllSemesters(completion: @escaping ([Semester]?) -> Void) {
        
        struct AllSemesters: Codable {
            let semesters: [Semester]
        }
        
        let baseUrl = URL(string:"http://student-planner2344.tk/api/selectAll.php")!
        let query: [String: String] = ["table":"semester"]
        
        let url = baseUrl.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let allSemesters = try? jsonDecoder.decode(AllSemesters.self, from: data) {
                completion(allSemesters.semesters)
            } else {
                print("something went wrong")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
    
    func add(semester: Semester, completion: @escaping (Bool) -> Void) {
        let name = semester.name
        let startDate = semester.startDateString
        let endDate = semester.endDateString
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/add.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=semester"+"&name="+name+"&startDate="+startDate+"&endDate="+endDate;
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
    
    func update(semester: Semester, by newSemester: Semester, completion: @escaping (Bool) -> Void) {
        let name = semester.name
        
        let nameTo = newSemester.name
        let startDateTo = newSemester.startDateString
        let endDateTo = newSemester.endDateString
        
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/update.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=semester"+"&name="+name+"&nameTo="+nameTo+"&startDateTo="+startDateTo+"&endDateTo="+endDateTo;
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
    
    func deleteSemester(semester: Semester, completion: @escaping (Bool) -> Void) {
        let name = semester.name
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/delete.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=semester"+"&name="+name;
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
