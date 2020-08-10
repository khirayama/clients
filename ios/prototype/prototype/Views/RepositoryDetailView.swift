//
//  RepositoryDetailView.swift
//  prototype
//

import Foundation
import SwiftUI

struct RepositoryDetailView: View {
    @ObservedObject var viewModel: RepositoryDetailViewModel
    
    var body: some View {
        Text(viewModel.repository.fullName)
    }
}
