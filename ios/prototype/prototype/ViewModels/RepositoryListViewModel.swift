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
    @Published private(set) var shouldShowIcon = false
    
    private let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private let trackingSubject = PassthroughSubject<TrackEventType, Never>()
    
    private let apiService: APIServiceType
    private let trackerService: TrackerType
    private let experimentService: ExperimentServiceType
    
    init(apiService: APIServiceType = APIService(),
         trackerService: TrackerType = TrackerService(),
         experimentService: ExperimentServiceType = ExperimentService()) {
        self.apiService = apiService
        self.trackerService = trackerService
        self.experimentService = experimentService
        
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
        
        let trackingSubjectStream = trackingSubject
            .sink(receiveValue: trackerService.log)
        
        let trackingStream = onAppearSubject
            .map({.listView})
            .subscribe(trackingSubject)
        
        cancellables += [
            responseStream,
            trackingSubjectStream,
            trackingStream,
        ]
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
        
        let showIconStream = onAppearSubject
            .map({ [experimentService] _ in
                experimentService.experiment(for: .showIcon)
            })
            .assign(to: \.shouldShowIcon, on: self)
        
        cancellables += [
            repositoriesStream,
            errorStream,
            errorMessageStream,
            showIconStream,
        ]
    }
}
