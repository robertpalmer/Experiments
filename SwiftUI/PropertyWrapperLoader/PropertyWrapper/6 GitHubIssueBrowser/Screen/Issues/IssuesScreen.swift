//
//  Issues.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import SwiftUI

struct IssuesScreen: View {

    @State var selection: String = "open"
    let issueURL: URL
    
    private var issueStateURL: URL {
        issueURL.parameterdized(queryItem: URLQueryItem(name: "state", value: selection))
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                Text("Open").tag("open")
                Text("Closed").tag("closed")
            }
            .pickerStyle(SegmentedPickerStyle())
        
            IssuesList(url: issueStateURL)
        }
    }
}

extension URL {
    func parameterdized(queryItem: URLQueryItem) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = [queryItem]
        return components.url!
    }
}

//struct Issues_Previews: PreviewProvider {
//    static var previews: some View {
//        Issues()
//    }
//}
