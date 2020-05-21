//
//  ClassCourse.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/28/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
struct ClassCourse: Codable {
    var aClass: Class
    var course: Course
    var instructorName: String?
    
    enum CodingKeys: String, CodingKey {
        case aClass = "class"
        case course
        case instructorName
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.aClass = try valueContainer.decode(Class.self, forKey: CodingKeys.aClass)
        self.course = try valueContainer.decode(Course.self, forKey: CodingKeys.course)
        self.instructorName = try valueContainer.decode(String?.self, forKey: CodingKeys.instructorName)
    }
    
    
    static func fetchClasses(for day: Int, completion: @escaping ([ClassCourse]?) -> Void) {
        struct ClassCoursesForDay: Codable {
            var classCoursesForDay: [ClassCourse]
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDay = dateFormatter.string(from: Date())
        
        let baseUrl = URL(string: "http://student-planner2344.tk/api/select.php")!
        let query: [String: String] = ["kind": "classesForDay", "day": "\(day)", "currentDate": currentDay]
        
        let url = baseUrl.withQueries(query)!
        let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let classesCoursesForDay = try? jsonDecoder.decode(ClassCoursesForDay.self, from: data)
            {
                completion(classesCoursesForDay.classCoursesForDay)
            } else {
                print("something went wrong with fetch classes for day")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
}
