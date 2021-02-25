//
//  Issues.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import Foundation

struct Issues: Codable {
    let id: Int
    let url: URL
    let number: Int
    let state: String
    let title: String
    let body: String
    let comments: Int
}
