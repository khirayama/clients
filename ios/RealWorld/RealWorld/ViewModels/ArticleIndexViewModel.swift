//
//  ArticleIndexViewModel.swift
//  RealWorld
//

import Foundation
import SwiftUI
import Combine

final class ArticleIndexViewModel: ObservableObject {
    typealias InputType = Input
    
    enum Input {
        case onAppear
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear: onAppearSubject.send(())
        }
    }
    
    @Published private(set) var articles: [Article] = []
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    
    private var cancellables: [AnyCancellable] = []
    
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    private let apiService: APIServiceType
    
    private let responseSubject = PassthroughSubject<IndexArticleResponse, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
        
        bindInputs()
        bindOutputs()
    }
    
    func bindInputs() {
        let request = IndexArticleRequest()
        let responsePublisher = onAppearSubject
            .flatMap({ [apiService] _ in
                return apiService.response(from: request)
                    .catch({ [weak self] error -> Empty<IndexArticleResponse, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    })
            })
        
        let responseStream = responsePublisher
            .share()
            .subscribe(responseSubject)
        
        cancellables += [responseStream]
    }
    
    func bindOutputs() {
        let articlesStream = responseSubject
            .map({
                return $0.articles
            })
            .assign(to: \.articles, on: self)
        
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
            articlesStream,
            errorStream,
            errorMessageStream
        ]
    }
}
