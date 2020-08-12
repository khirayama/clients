//
//  IndexArticleResponse.swift
//  RealWorld
//

import Foundation

struct IndexArticleResponse: Decodable {
    var articles: [Article]
    var articlesCount: Int
}
