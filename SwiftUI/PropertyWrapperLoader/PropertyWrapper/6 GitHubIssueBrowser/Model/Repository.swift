//
//  Rpository.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let full_name: String
    let description: String?
    let url: URL
    let stargazers_count: Int
    let watchers_count: Int
    let forks_count: Int
    let has_issues: Bool
    let open_issues_count: Int
    let homepage: URL
}
