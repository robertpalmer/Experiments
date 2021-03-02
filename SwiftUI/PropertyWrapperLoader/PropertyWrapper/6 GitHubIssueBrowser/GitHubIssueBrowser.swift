import Combine
import SwiftUI

struct GitHubIssueBrowser: View {
    
    var body: some View {
        NavigationView {
            SearchScreen()
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
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = "/search/repositories"
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        
        return components.url!
    }
}
