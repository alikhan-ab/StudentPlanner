//
//  Partner.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/25/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//

import Foundation

struct Partner: Codable {
    var email: String
    var name: String
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phoneNumber 
    }
    
    init(email: String, name: String, phoneNumber: String?) {
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try valueContainer.decode(String.self, forKey: CodingKeys.email)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.phoneNumber = try valueContainer.decode(String?.self, forKey: CodingKeys.phoneNumber)
    }
    
    
    static func generateData() -> [Partner] {
        var result: [Partner] = []
    
        
        for i in 1...11 {
            let tempPartner = Partner(email: "\(i).gmail.com", name: "\(i) Student", phoneNumber: "244433")
            result.append(tempPartner)
        }
        return result
    }
}
