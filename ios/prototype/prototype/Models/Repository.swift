//
//  Repository.swift
//  prototype
//

import Foundation
import SwiftUI

struct Repository: Decodable, Hashable, Identifiable {
    var id: Int64
    var fullName: String
    var description: String?
    var stargazersCount: Int = 0
    var language: String?
    var owner: User
}
