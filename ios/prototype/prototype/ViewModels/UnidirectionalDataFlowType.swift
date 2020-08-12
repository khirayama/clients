//
//  UnidirectionalDataFlowType.swift
//  prototype
//

import Foundation

protocol UnidirectionalDataFlowTypea {
    associatedtype InputType
    
    func apply(_ input: InputType)
}
