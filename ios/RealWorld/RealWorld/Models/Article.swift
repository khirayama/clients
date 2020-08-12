//
//  Article.swift
//  RealWorld
//

import Foundation

/*
 author: {username: "enixan25", bio: null, image: "https://static.productionready.io/images/smiley-cyrus.jpg",…}
 body: "explicabo veritatis libero"
 createdAt: "2020-08-12T11:18:54.701Z"
 description: "xSMMog6QHrPEdLS"
 favorited: false
 favoritesCount: 0
 slug: "use-the-1080p-agp-bus-then-you-can-hack-the-neural-application-tx8u6c"
 tagList: []
 title: "edited"
 updatedAt: "2020-08-12T11:19:04.422Z"
 */

struct Article: Decodable, Identifiable {
    var id: String
    var body: String
    var createdAt: String
    var description: String
    var favorited: Bool
    var favoritesCount: Int
    var slug: String
    var tagList: [String]
    var title: String
    var updatedAt: String
    var author: User
}
