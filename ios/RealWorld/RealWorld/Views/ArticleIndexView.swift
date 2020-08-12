//
//  ArticleIndexView.swift
//  RealWorld
//

import SwiftUI

struct ArticleIndexView: View {
    @ObservedObject var viewModel: ArticleIndexViewModel
    
    var body: some View {
        return NavigationView {
            List(viewModel.articles) { article in
                ArticleListRow(article: article)
            }
        }
    }
}
