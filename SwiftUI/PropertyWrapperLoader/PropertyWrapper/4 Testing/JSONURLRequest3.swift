//
//  JSONURLRequest3.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 14.02.21.
//

import Combine
import SwiftUI

typealias ResponseType = (data: Data, response: URLResponse)

struct URLClient {
    let request: (URL) -> AnyPublisher<ResponseType, URLError>
}

struct URLClientKey: EnvironmentKey {
    static var defaultValue: URLClient? = nil
}

extension EnvironmentValues {
    var urlClient: URLClient? {
        get { self[URLClientKey.self] }
        set { self[URLClientKey.self] = newValue }
    }
}

class DisposeBag {
    var cancellables = Set<AnyCancellable>()
}

@propertyWrapper struct JSONURLRequest3<Value>: DynamicProperty where Value: Decodable {

    @ObservedObject var box = Box<Result<Value, Error>?>(value: nil)
    @Environment(\.urlClient) private var client: URLClient?
    
    private var disposeBag = DisposeBag()
    private var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func update() {
        guard box.value == nil else { return }
        performRequest()
    }
    
    var wrappedValue: Result<Value, Error>? { box.value }
    
    private func performRequest() {
        client?.request(url)
            .map { data, _ in data }
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [box] in
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    box.value = .failure(error)
                }
            } receiveValue: { [box] value in
                box.value = .success(value)
            }
            .store(in: &disposeBag.cancellables)
    }
}

struct JSONURLRequestView3: View {
    @JSONURLRequest3(url: URL(string: "https://api.github.com/users/apple/repos")!)
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
                    EmptyView()
                }
            }.navigationBarTitle("Repos")
        }
    }
}

struct JSONURLRequestView3_Previews: PreviewProvider {
    static var previews: some View {
        JSONURLRequestView3()
            .environment(
                \.urlClient,
                URLClient { _ in Fail(outputType: ResponseType.self, failure: URLError(.badURL)).eraseToAnyPublisher() }
            )
    }
}
