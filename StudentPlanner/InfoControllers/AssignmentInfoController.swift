//
//  AssignmentInfoController.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/28/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
class AssignmnetInfoController {
    
    func fetchAllAssignments(completion: @escaping ([Assignmnet]?) -> Void) {
        
        struct AllAssignmnets: Codable {
            let assignments: [Assignmnet]
        }
        
        let baseUrl = URL(string:"http://student-planner2344.tk/api/selectAll.php")!
        let query: [String: String] = ["table":"assignment"]
        
        let url = baseUrl.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let allAssignments = try? jsonDecoder.decode(AllAssignmnets.self, from: data) {
                completion(allAssignments.assignments)
            } else {
                print("something went wrong234")
                completion(nil)
                return
            }
        }
        
        task.resume()
    }
    
    
    
    
}
