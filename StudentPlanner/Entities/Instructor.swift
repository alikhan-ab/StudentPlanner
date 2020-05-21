//
//  Instructor.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/23/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation

struct Instructor: Codable {
    var email: String
    var name: String
    var officeLocation: String?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case officeLocation = "office"
        case email = "email"
    }
    
    init(email: String, name: String, officeLocation: String?) {
        self.email = email
        self.name = name
        self.officeLocation = officeLocation
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try valueContainer.decode(String.self, forKey: CodingKeys.email)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.officeLocation = try valueContainer.decode(String?.self, forKey: CodingKeys.officeLocation)
    }
    
    
    static func generateData() -> [Instructor] {
        var result: [Instructor] = []
        
        for i in 1...10 {
            let tempInstructor = Instructor(email: "\(i)@gmail.com", name: "\(i) John", officeLocation: "Block \(i) ")
            result.append(tempInstructor)
        }
        
        return result
    }
}

