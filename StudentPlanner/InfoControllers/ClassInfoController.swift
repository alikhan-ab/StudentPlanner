//
//  ClassInfoController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/27/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
class ClassInfroController {
    
    func fetchClasses(for semester: Semester, and course: Course, completion: @escaping ([Class]?) -> Void) {
        
        struct ClassesForCourse: Codable {
            let classes: [Class]
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/select.php")!
        let query: [String: String] = ["kind": "classesForCourse", "semesterName": "\(semester.name)", "courseAbbr": "\(course.abbreviation)"]
        
        let url = baseUrl.withQueries(query)!
        let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let classesForCourse = try? jsonDecoder.decode(ClassesForCourse.self, from: data)
            {
                completion(classesForCourse.classes)
            } else {
                print("something went wrong with fetch classes for course and semester")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
    
//    func fetchClasses(for day: Int, completion: @escaping ([Class]?) -> Void) {
//        struct ClassesForDay: Codable {
//            let classes: [Class]
//        }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let currentDay = dateFormatter.string(from: Date())
//        
//        let baseUrl = URL(string: "http://student-planner2344.tk/api/select.php")!
//        let query: [String: String] = ["kind": "classesForDay", "day": "\(day)", "currentDate": currentDay]
//        
//        let url = baseUrl.withQueries(query)!
//        let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
//            let jsonDecoder = JSONDecoder()
//            if let data = data, let classesForDay = try? jsonDecoder.decode(ClassesForDay.self, from: data)
//            {
//                completion(classesForDay.classes)
//            } else {
//                print("something went wrong with fetch classes for day")
//                completion(nil)
//                return
//            }
//        }
//        
//        task.resume()
//        
//    }
    
    func add(aClass: Class, of course: Course, in semester: Semester, completion: @escaping (Bool) -> Void) {
        let day = aClass.day
        let startTime = aClass.startTimeString
        let endTime = aClass.endTimeString
        let type = aClass.type ?? ""
        let location = aClass.location ?? ""
        let instructor = aClass.instructorEmail ?? ""
        let courseAbbr = course.abbreviation
        let semesterName = semester.name
        
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/add.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=class"+"&day=\(day)"+"&startTime="+startTime+"&endTime="+endTime+"&type="+type+"&location="+location+"&instructor="+instructor+"&courseAbbr="+courseAbbr+"&semesterName="+semesterName
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
    
    func update(aClass: Class, with newClass: Class, of course: Course, in semester: Semester, completion: @escaping (Bool) -> Void){
        let day = aClass.day
        let startTime = aClass.startTimeString
        let courseAbbr = course.abbreviation
        let semesterName = semester.name
        
        let dayTo = newClass.day
        let startTimeTo = newClass.startTimeString
        let endTimeTo = newClass.endTimeString
        let typeTo = newClass.type ?? ""
        let locationTo = newClass.location ?? ""
        let instructorTo = newClass.instructorEmail ?? ""
        
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/update.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=class"+"&day=\(day)"+"&startTime="+startTime+"&courseAbbr="+courseAbbr+"&semesterName="+semesterName+"&dayTo=\(dayTo)"+"&startTimeTo="+startTimeTo+"&endTimeTo="+endTimeTo+"&typeTo="+typeTo+"&locationTo="+locationTo+"&instructorTo="+instructorTo
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
    
    func delete(aClass: Class, of course: Course, in semester: Semester, completion: @escaping (Bool) -> Void) {
        let courseAbbr = course.abbreviation
        let semesterName = semester.name
        
        let day = aClass.day
        let startTime = aClass.startTimeString
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/delete.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=class"+"&courseAbbr="+courseAbbr+"&semesterName="+semesterName+"&day=\(day)"+"&startTime="+startTime;
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
