//
//  Semester.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/24/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
struct Semester: Codable {
    var name: String
    var startDate: Date
    var endDate: Date
    var startDateString: String
    var endDateString: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case startDateString = "startDate"
        case endDateString = "endDate"
    }
    
    init(name: String, startDate: Date, endDate: Date) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.startDateString = dateFormatter.string(from: startDate)
        self.endDateString = dateFormatter.string(from: endDate)
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.startDateString = try valueContainer.decode(String.self, forKey: CodingKeys.startDateString)
        self.endDateString = try valueContainer.decode(String.self, forKey: CodingKeys.endDateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDate = dateFormatter.date(from: self.startDateString)!
        self.endDate = dateFormatter.date(from: self.endDateString)!
    }
    
    static let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    
}
