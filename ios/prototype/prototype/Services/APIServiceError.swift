//
//  APIServiceError.swift
//  prototype
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}
