//
//  TimerWrapperApp.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 13.02.21.
//

import SwiftUI

@main
struct TimerWrapperApp: App {
    var body: some Scene {
        WindowGroup {
            //JSONURLRequestView3()
            // JSONURLRequestView4()
            GitHubIssueBrowser()
                .environment(\.urlClient, URLClient { URLSession.shared.dataTaskPublisher(for: $0).eraseToAnyPublisher() })
        }
    }
}
