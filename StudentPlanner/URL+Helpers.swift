//
//  URL+Helpers.swift
//  StudentPlanner
//
//  Created by Alikhan Abutalip on 11/26/17.
//  Copyright © 2017 ProjectSwift. All rights reserved.
//
import Foundation
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
