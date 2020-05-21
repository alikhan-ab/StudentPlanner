//
//  CourseInfoController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/27/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
class CourseInfroController {
    
    func fetchCourses(for semester: Semester, completion: @escaping ([Course]?) -> Void) {
        
        struct CoursesForSemester: Codable {
            let coursesForSemester: [Course]
        }
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/select.php")!
        let query: [String: String] = ["kind": "coursesForSemester", "semesterName": "\(semester.name)"]
        
        let url = baseUrl.withQueries(query)!
        let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let courses = try? jsonDecoder.decode(CoursesForSemester.self, from: data)
            {
                completion(courses.coursesForSemester)
            } else {
                print("something went wrong with fetch courses")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
    
    func add(course: Course, in semester: Semester, completion: @escaping (Bool) -> Void) {
        let semesterName = semester.name
        let abbr = course.abbreviation
        let name = course.name ?? ""
       
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/add.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=course"+"&abbr="+abbr+"&name="+name+"&semesterName="+semesterName;
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
    
    func update(course: Course, in semester: Semester, with newCourse: Course, completion: @escaping (Bool) -> Void) {
        let abbr = course.abbreviation
        let semesterName = semester.name
        
        let abbrTo = newCourse.abbreviation
        let nameTo = newCourse.name ?? ""
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/update.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=course"+"&abbr="+abbr+"&semesterName="+semesterName+"&abbrTo="+abbrTo+"&nameTo="+nameTo;
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
    
    func delete(course: Course, in semester: Semester, completion: @escaping (Bool) -> Void) {
        let abbr = course.abbreviation
        let semesterName = semester.name
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/delete.php")!
        var requestURL = URLRequest(url: baseUrl)
        requestURL.httpMethod = "POST"
        let postParameters = "table=course"+"&abbr="+abbr+"&semesterName="+semesterName;
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
