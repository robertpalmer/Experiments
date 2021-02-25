//
//  URLRequestView.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 14.02.21.
//

import Combine
import SwiftUI

@propertyWrapper struct SimpleJSONURLRequest<Value>: DynamicProperty where Value: Decodable {

    @ObservedObject var box = Box<Value?>(value: nil)
    private var cancellable: AnyCancellable? = nil

    init(url: URL) {
        
        let box = box
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, response in data}
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { value in
                box.value = value
            }
    }
    
    var wrappedValue: Value? { box.value }
}

struct JSONURLRequestView: View {
        
    @SimpleJSONURLRequest(url: URL(string: "https://api.github.com/users/apple/repos")!)
    var posts: [Repo]?
        
    var body: some View {
        NavigationView {
            List(posts ?? [], id: \.id) {
                Text($0.name)
            }.navigationBarTitle("Repos")
        }
    }
}

struct JSONURLRequestView_Previews: PreviewProvider {
    static var previews: some View {
        JSONURLRequestView()
    }
}
