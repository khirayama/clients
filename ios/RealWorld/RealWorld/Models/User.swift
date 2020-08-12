//
//  User.swift
//  RealWorld
//

import Foundation
/*
bio: null
following: false
image: "https://static.productionready.io/images/smiley-cyrus.jpg"
username: "enixan25"
*/
struct User: Decodable {
    var bio: String
    var following: Bool
    var image: String
    var username: String
}
