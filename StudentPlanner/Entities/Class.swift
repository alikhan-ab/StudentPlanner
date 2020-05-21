//
//  Class.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
struct Class: Codable {
    var day: Int
    var startTime: Date
    var endTime: Date
    var startTimeString: String
    var endTimeString: String
    var type: String?
    var location: String?
    var instructorEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case day
        case startTimeString = "startTime"
        case endTimeString = "endTime"
        case type
        case location
        case instructorEmail = "instructor"
    }
    
    init(day: Int, startTime: Date, endTime: Date, type: String?, location: String?, instructorEmail: String?) {
        self.day = day
        self.startTime = startTime
        self.endTime =  endTime
        self.type = type
        self.location = location
        self.instructorEmail = instructorEmail
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        self.startTimeString = timeFormatter.string(from: self.startTime)
        self.endTimeString = timeFormatter.string(from: self.endTime)
    }
    
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try valueContainer.decode(Int.self, forKey: CodingKeys.day)
        self.startTimeString = try valueContainer.decode(String.self, forKey: CodingKeys.startTimeString)
        self.endTimeString = try valueContainer.decode(String.self, forKey: CodingKeys.endTimeString)
        self.type = try valueContainer.decode(String?.self, forKey: CodingKeys.type)
        self.location = try valueContainer.decode(String?.self, forKey: CodingKeys.location)
        self.instructorEmail = try valueContainer.decode(String?.self, forKey: CodingKeys.instructorEmail)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        self.startTime = timeFormatter.date(from: self.startTimeString)!
        self.endTime = timeFormatter.date(from: self.endTimeString)!
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func dayOfTheWeek(day: Int) -> String {
        switch(day) {
        case 0: return "Monday"
        case 1: return "Tuesday"
        case 2: return "Wednesday"
        case 3: return "Thursday"
        case 4: return "Friday"
        case 5: return "Saturday"
        case 6: return "Sunday"
        default: return "NoN"
        }
    }
}
