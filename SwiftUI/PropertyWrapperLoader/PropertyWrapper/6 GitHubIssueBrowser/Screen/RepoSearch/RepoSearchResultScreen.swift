//
//  RepoSearchResult.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import SwiftUI

struct RepoSearchResult: View {
    
    @InjectedJSONURLRequest var search: Result<SearchResponse, Error>?
    
    init(query: String) {
        _search = InjectedJSONURLRequest(url: .repoSearch(query: query))
    }
    
    var body: some View {
        
        ResultView(search, failure: Failure(), progress: Progress()) { result in
            ScrollView {
                 LazyVStack {
                    ForEach(result.items, id: \.full_name) { item in
                        NavigationLink(destination: RepositoryScreen(url: item.url), label: { RepoItem(item: item) })
                    }
                }
            }
        }
    }
}

struct Failure: View {
    var body: some View {
        Text("failure")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct Progress: View {
    var body: some View {
        SwiftUI.ProgressView("Loading…")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct ResultView<Value, ErrorView: View, ProgressView: View, ContentView: View>: View {
    
    let result: Result<Value, Error>?
    
    let failureView: () -> ErrorView
    let progressView: () -> ProgressView
    let contentView: (Value) -> ContentView

    init(
        _ result: Result<Value, Error>?,
        failure: @autoclosure @escaping () -> ErrorView,
        progress: @autoclosure @escaping () -> ProgressView,
        @ViewBuilder content: @escaping (Value) -> ContentView)
    {
        self.result = result
        self.failureView = failure
        self.progressView = progress
        self.contentView = content
    }

    var body: some View {
        switch result {
        case .failure:
            failureView()
        case .success(let response):
            contentView(response)
        default:
            progressView()
        }
    }
}

struct RepoItem: View {
    
    let item: SearchResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.owner.login)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                Text(item.name)
                    .font(.title2)
                    .padding(.top, 0)
                    .foregroundColor(Color.black)
                
                if let description = item.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color.black)
                        .lineLimit(4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
    }
}

struct RepoItem_Previews: PreviewProvider {
    static var previews: some View {
        RepoItem(item: SearchResult(id: 100, name: "swift", full_name: "apple/swift", description: "The Swift programming language", url: URL(string: "https://test.de")!, owner: Owner(login: "apple")))
    }
}


//struct RepoSearchResult_Previews: PreviewProvider {
//    static var previews: some View {
//        RepoSearchResult()
//    }
//}
