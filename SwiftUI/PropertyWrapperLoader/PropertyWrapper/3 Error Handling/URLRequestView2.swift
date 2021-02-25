//
//  URLRequestView2.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 14.02.21.
//

import Combine
import SwiftUI

@propertyWrapper struct JSONURLRequestWithErrorHandling<Value>: DynamicProperty where Value: Decodable {

    @ObservedObject var box = Box<Result<Value, Error>?>(value: nil)
    private var cancellable: AnyCancellable? = nil

    init(url: URL) {
        
        let box = box
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, response in data}
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    box.value = .failure(error)
                }
            } receiveValue: { value in
                box.value = .success(value)
            }
    }
    
    var wrappedValue: Result<Value, Error>? { box.value }
}

struct JSONURLRequestView2: View {
        
    @JSONURLRequestWithErrorHandling<[Repo]>(url: URL(string: "https://api.github.com/users/apple/repos")!)
    var posts: Result<[Repo], Error>?
        
    var body: some View {
        NavigationView {
            Group {
                switch posts {
                case .failure:
                    Text("something failed")
                case .success(let posts):
                    List(posts, id: \.id) {
                        Text($0.name)
                    }
                default:
                    ProgressView()
                }
            }.navigationBarTitle("Repos")
        }
    }
}

struct JSONURLRequestView2_Previews: PreviewProvider {
    static var previews: some View {
        JSONURLRequestView2()
    }
}

