//
//  RepositoryListView.swift
//  prototype
//

import SwiftUI

struct RepositoryListView: View {
    @ObservedObject var viewModel: RepositoryListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.repositories) { repository in
                RepositoryListRow(repository: repository)
            }
        }
    }
}
