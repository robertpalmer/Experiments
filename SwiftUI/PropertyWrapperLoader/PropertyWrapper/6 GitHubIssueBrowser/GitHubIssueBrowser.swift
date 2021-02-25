import Combine
import SwiftUI

class ToggleInput: ObservableObject {
    @Published var input: String = ""
    @Published var output: String = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        $input
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .assign(to: &$output)
    }
}

struct GitHubIssueBrowser: View {
    
    @ObservedObject var input = ToggleInput()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search a repo", text: $input.input.animation())
                    .padding()
            
                if !input.output.isEmpty {
                    RepoSearchResult(query: input.output)
                }
            }
            .animation(.easeIn)
            .navigationBarTitle("Repository")
        }
    }
}

struct GitHubIssueBrowser_Previews: PreviewProvider {
    static var previews: some View {
        GitHubIssueBrowser()
    }
}

extension URL {
    private static let baseURL = URL(string: "https://api.github.com")!

    static func repoSearch(query: String) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components!.path = "/search/repositories"
        components!.queryItems = [URLQueryItem(name: "q", value: query)]
        
        return components!.url!
    }

//    static func repo(name: String) -> URL {
//        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
//        components!.path = "/search/repositories"
//        components!.queryItems = [URLQueryItem(name: "q", value: query)]
//
//        return components!.url!
//    }
}
