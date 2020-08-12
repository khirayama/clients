//
//  IndexArticleRequest.swift
//  RealWorld
//

import Foundation

struct IndexArticleRequest: APIRequestType {
    typealias Response = IndexArticleResponse
    
    var path: String { return "/api/articles" }
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "offset", value: "0"),
            .init(name: "limit", value: "10")
        ]
    }
}
