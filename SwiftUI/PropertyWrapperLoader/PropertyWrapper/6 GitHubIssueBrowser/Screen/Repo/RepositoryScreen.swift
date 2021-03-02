//
//  RepositoryScreen.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import SwiftUI

struct RepositoryScreen: View {
    @SimpleLazyJSONURLRequest var repository: Result<Repository, Error>?
    
    init(url: URL) {
        _repository = SimpleLazyJSONURLRequest(url: url)
    }
    
    var body: some View {
        ResultView(repository, failure: Failure(), progress: Progress()) { repo in
            VStack(alignment: .leading, spacing: 8) {
                
                if let description = repo.description {
                    Text(description)
                        .font(.body)
                }
                
                if let homepage = repo.homepage {
                    Link(destination: homepage, label: {
                        Label(homepage.absoluteString, systemImage: "safari")
                    })
                }
                
                HStack {
                    Label("\(repo.stargazers_count)", systemImage: "star")
                    Label("\(repo.forks_count)", systemImage: "tuningfork")
                }
                
                if repo.has_issues, let url = repo.issues_url?.cleanURL {
                    Divider()
                    NavigationLink(
                        destination: IssuesScreen(issueURL: url),
                        label: {
                            HStack {
                                Text("Issues")
                                    .padding()
                                Spacer()
                                Text("\(repo.open_issues_count)")
                            }
                        })
                    Divider()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
            .navigationBarTitle(repo.name)
        }
        .onAppear {
            self._repository.load()
        }

    }
}

//struct RepositoryScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RepositoryScreen()
//    }
//}
