//
//  APIServiceError.swift
//  RealWorld
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}
