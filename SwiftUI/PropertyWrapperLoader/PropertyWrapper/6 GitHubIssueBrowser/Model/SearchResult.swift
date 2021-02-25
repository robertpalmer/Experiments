//
//  SearchResult.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import Foundation

struct SearchResult: Codable {
    let id: Int
    let name: String
    let full_name: String
    let description: String?
    let url: URL
    
    let owner: Owner
}
