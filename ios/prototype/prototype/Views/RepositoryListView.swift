//
//  RepositoryListView.swift
//  prototype
//

import SwiftUI

struct RepositoryListView: View {
    @ObservedObject var viewModel: RepositoryListViewModel
    
    var body: some View {
        return NavigationView {
            List(viewModel.repositories) { repository in
                RepositoryListRow(repository: repository)
            }
            .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
            })
            .navigationBarTitle(Text("Repositories"))
        }
        .onAppear(perform: {self.viewModel.apply(.onAppear)})
    }
}
