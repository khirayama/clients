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
    }
    
    private func bindOutputs() {}
}
