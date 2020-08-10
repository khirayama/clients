//
//  RepositoryListRow.swift
//  prototype
//

import Foundation
import SwiftUI

struct RepositoryListRow: View {
    @State var repository: Repository
    
    var body: some View {
        NavigationLink(destination: RepositoryDetailView(viewModel: .init(repository: repository))) {
            Text(repository.fullName)
        }
    }
}
