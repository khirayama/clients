//
//  RepositoryListViewModel.swift
//  prototype
//

import Foundation
import SwiftUI
import Combine

final class RepositoryListViewModel: ObservableObject, UnidirectionalDataFlowType {
    typealias InputType = Input
    
    private var cancellables: [AnyCancellable] = []
    
    enum Input {
        case onAppear
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear: onAppearSubject.send(())
        }
    }
    
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    @Published private(set) var repositories: [Repository] = []
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    
    private let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private let apiService: APIServiceType
    
    init(apiService: APIServiceType = APIService()) {
        self.apiService = apiService

        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        let request = SearchRepositoryRequest()
        let responsePublisher = onAppearSubject
            .flatMap({ [apiService] _ in
                apiService.response(from: request)
                    .catch({ [weak self] error -> Empty<SearchRepositoryResponse, Never> in self?.errorSubject.send(error)
                        return .init()
                    })
            })
        
        let responseStream = responsePublisher
            .share()
            .subscribe(responseSubject)
        
        cancellables += [responseStream]
    }
    
    private func bindOutputs() {
        let repositoriesStream = responseSubject
            .map({$0.items})
            .assign(to: \.repositories, on: self)
        
        let errorMessageStream = errorSubject
            .map({error -> String in
                switch error {
                case .responseError: return "network error"
                case .parseError: return "parse error"
                }
            })
            .assign(to: \.errorMessage, on: self)
        
        let errorStream = errorSubject
            .map({_ in true})
            .assign(to: \.isErrorShown, on: self)
        
        cancellables += [
            repositoriesStream,
            errorStream,
            errorMessageStream,
        ]
    }
}
