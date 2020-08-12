//
//  ArticleIndexViewModel.swift
//  RealWorld
//

import Foundation
import SwiftUI
import Combine

final class ArticleIndexViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    
    private let apiService: APIServiceType

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
}
