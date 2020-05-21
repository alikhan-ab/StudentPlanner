//
//  Assignment.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/28/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
struct Assignmnet: Codable {
    var id: Int
    var title: String
    var dueDateTime: Date
    var dueDateTimeString: String
    var isComplete: Bool
    var partners: [Partner]?
    var courseAbbr: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case dueDateTimeString = "due"
        case isComplete = "complete"
        case partners
        case courseAbbr
    }
    
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.dueDateTimeString = try valueContainer.decode(String.self, forKey: CodingKeys.dueDateTimeString)
        let b = try valueContainer.decode(Int.self, forKey: CodingKeys.isComplete)
        if b == 0 {
            self.isComplete = false
        } else {
            self.isComplete = true
        }
        
        self.partners = try valueContainer.decode([Partner]?.self, forKey: CodingKeys.partners)
        self.courseAbbr = try valueContainer.decode(String.self, forKey: CodingKeys.courseAbbr)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dueDateTime = dateFormatter.date(from: self.dueDateTimeString)!
    }
    
    static let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
