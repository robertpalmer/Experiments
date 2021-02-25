import Combine
import SwiftUI

struct ContentView: View {
        
    @SimpleJSONURLRequest(url: URL(string: "https://api.github.com/users/apple/repos")!)
    var posts: [Repo]?
        
    var body: some View {
        NavigationView {
            List(posts ?? [], id: \.id) {
                Text($0.name)
            }.navigationBarTitle("Repos", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Repo: Codable {
    let id: Int
    let name: String
    let description: String?
}
