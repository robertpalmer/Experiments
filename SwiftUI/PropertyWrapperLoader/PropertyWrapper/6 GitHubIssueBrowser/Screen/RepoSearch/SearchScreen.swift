//
//  SearchScreen.swift
//  PropertyWrapper
//
//  Created by Robert Palmer on 27.02.21.
//
import Combine
import Foundation
import SwiftUI

struct SearchScreen: View {

    @ObservedObject private  var input = ThrottledInput()

    var body: some View {
        VStack {
            TextField("Search a repo", text: $input.input.animation())
                .padding()

            if !input.output.isEmpty {
                RepoSearchResult(query: input.output)
            }
        }.animation(.easeIn)
    }
}

private class ThrottledInput: ObservableObject {
    @Published var input: String = ""
    @Published var output: String = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        $input
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .assign(to: &$output)
    }
}
