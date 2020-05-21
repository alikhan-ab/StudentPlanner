//
//  Course.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation
struct Course: Codable {
    var abbreviation: String
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case abbreviation = "abbr"
        case name
    }
    
    
    init(abbreviation: String, name: String?) {
        self.abbreviation = abbreviation
        self.name = name
    }

    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.abbreviation = try valueContainer.decode(String.self, forKey: CodingKeys.abbreviation)
        self.name = try valueContainer.decode(String?.self, forKey: CodingKeys.name)
    }
}
