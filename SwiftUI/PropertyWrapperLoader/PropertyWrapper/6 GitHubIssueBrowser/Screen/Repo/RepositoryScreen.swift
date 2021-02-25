//
//  RepositoryScreen.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import SwiftUI

struct RepositoryScreen: View {
    @JSONURLRequest3 var respository: Result<Repository, Error>?
    
    init(url: URL) {
        _respository = JSONURLRequest3(url: url)
    }
    
    var body: some View {
        ResultView(respository, failure: Failure(), progress: Progress()) { repo in
            VStack(alignment: .leading, spacing: 8) {
                
                if let description = repo.description {
                    Text(description)
                        .font(.body)
                }
                
                Link(destination: repo.homepage, label: {
                    Label(repo.homepage.absoluteString, systemImage: "safari")
                })
                
                HStack {
                    Label("\(repo.stargazers_count)", systemImage: "star")
                    Label("\(repo.forks_count)", systemImage: "tuningfork")
                }
                
                if repo.has_issues {
                    Divider()
                    NavigationLink(
                        destination: IssuesScreen(),
                        label: {
                            HStack {
                                Text("Issues")
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
    }
}

//struct RepositoryScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RepositoryScreen()
//    }
//}
