//
//  SearchResponse.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import Foundation

struct SearchResponse: Codable {
    let total_count: Int?
    let incomplete_resutls: Bool?
    let items: [SearchResult]
}
