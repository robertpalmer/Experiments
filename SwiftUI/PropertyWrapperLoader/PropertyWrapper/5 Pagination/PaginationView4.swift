//
//  JSONURLRequestView4.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 14.02.21.
//

import SwiftUI

struct NetworkResult<Value> {
    let response: HTTPURLResponse
    let value: Value
}

@propertyWrapper struct SimpleLazyJSONURLRequest2<Value>: DynamicProperty where Value: Decodable {

    @ObservedObject var box = Box<Result<NetworkResult<Value>, Error>?>(value: nil)
    @Environment(\.urlClient) private var client: URLClient?
        
    private var disposeBag = DisposeBag()
    private var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func update() {
        guard box.value == nil else { return }
    }
    
    var wrappedValue: Result<NetworkResult<Value>, Error>? { box.value }
    
    func load() {
        performRequest()
    }
    
    private func performRequest() {
                        
        client?.request(url)
            .tryMap { data, response in
                (try JSONDecoder().decode(Value.self, from: data), response as! HTTPURLResponse)
            }
            .receive(on: DispatchQueue.main)
            .sink { [box] in
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    box.value = .failure(error)
                }
            } receiveValue: { [box] value, response in
                box.value = .success(NetworkResult(response: response, value: value))
            }
            .store(in: &disposeBag.cancellables)
    }
}


@propertyWrapper struct SimpleLazyJSONURLRequest<Value>: DynamicProperty where Value: Decodable {

    @ObservedObject var box = Box<Result<Value, Error>?>(value: nil)
    @Environment(\.urlClient) private var client: URLClient?
        
    private var disposeBag = DisposeBag()
    private var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func update() {
        guard box.value == nil else { return }
    }
    
    var wrappedValue: Result<Value, Error>? { box.value }
    
    func load() {
        performRequest()
    }
    
    private func performRequest() {
                        
        client?.request(url)
            .map { data, response in data }
            
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [box] in
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    print("error \(error)")
                    box.value = .failure(error)
                }
            } receiveValue: { [box] value in
                box.value = .success(value)
            }
            .store(in: &disposeBag.cancellables)
    }
}

struct Page: View {
    
    @SimpleLazyJSONURLRequest var posts: Result<[Repo], Error>?
    
    private var page: Int
    
    init(page: Int = 1) {
        self.page = page
        _posts = SimpleLazyJSONURLRequest(url: URL(string: "https://api.github.com/users/apple/repos?page=\(page)")!)
    }
    
    var body: some View {
        Group {
            switch posts {
            case .failure:
                Text("something failed")
            case .success(let posts):
                ForEach(posts, id: \.id) {
                    Text($0.name)
                }
                
                if page < 3 {
                    Page(page: page + 1)
                }
                
            default:
                ProgressView()
                    .onAppear { _posts.load() }
            }
        }
    }
}

struct JSONURLRequestView4: View {
    
        @State var nextPage: Int = 1
        
        var body: some View {
        List {
            Page()
        }
    }
}

struct JSONURLRequestView4_Previews: PreviewProvider {
    static var previews: some View {
        JSONURLRequestView4()
    }
}
