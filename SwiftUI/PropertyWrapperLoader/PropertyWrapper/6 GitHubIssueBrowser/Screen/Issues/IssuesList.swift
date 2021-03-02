//
//  IssuesList.swift
//  PropertyWrapper
//
//  Created by Robert Palmer on 27.02.21.
//

import SwiftUI

struct IssuesList: View {
    
    @SimpleLazyJSONURLRequest2 var issues: Result<NetworkResult<[Issue]>, Error>?
    
    init(url: URL) {
        _issues = SimpleLazyJSONURLRequest2(url: url)
    }
        
    var body: some View {
        ResultView(
            issues,
            failure: Failure(),
            progress: Progress().onAppear {
                _issues.load()
            }
        ) { result in
            
            ScrollView {
                LazyVStack {
                    ForEach(result.value, id: \.id) { issue in
                        Text(issue.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }

                    if let url = result.response.nextPage {
                        AdditionalIssues(url: url)
                    }
                }
            }
        }
    }
}

struct LoadingCell: View {
    
    var body: some View {
        ProgressView("Loading")
            .padding()
            .frame(maxWidth: .infinity)
    }
}

struct FailureCell: View {
    
    var body: some View {
        ProgressView("Failure")
            .padding()
            .frame(maxWidth: .infinity)
    }
}

struct AdditionalIssues: View {
    @SimpleLazyJSONURLRequest2 var issues: Result<NetworkResult<[Issue]>, Error>?
    
    init(url: URL) {
        _issues = SimpleLazyJSONURLRequest2(url: url)
    }
        
    var body: some View {
        ResultView(
            issues,
            failure: FailureCell(),
            progress: LoadingCell().onAppear { _issues.load() }
        ) { result in
        
            ForEach(result.value, id: \.id) { issue in
                Text(issue.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            if let url = result.response.nextPage {
                AdditionalIssues(url: url)
            }
        }
    }
}

extension HTTPURLResponse {
    
    var nextPage: URL? {
        guard let links = allHeaderFields["Link"] as? String else { return nil }
        
        let regexp = try?  NSRegularExpression(pattern: "<([^,]+)>; rel=\"next\"", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSRange(links.startIndex..<links.endIndex, in: links)
        
        guard let matches = regexp?.matches(in: links, options: [], range: range).first else { return nil }
        
        if matches.numberOfRanges > 0 {
            let range = matches.range(at: matches.numberOfRanges - 1)
            if let substring = Range(range, in: links) {
                let urlString = String(links[substring])
                return URL(string: urlString)
            }
        }
        
        return nil
    }
}

//struct IssuesList_Previews: PreviewProvider {
//    static var previews: some View {
//        IssuesList()
//    }
//}
