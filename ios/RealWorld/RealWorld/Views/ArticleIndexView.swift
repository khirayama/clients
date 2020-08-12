//
//  ArticleIndexView.swift
//  RealWorld
//

import SwiftUI

struct ArticleIndexView: View {
    @ObservedObject var viewModel: ArticleIndexViewModel
    
    var body: some View {
        return NavigationView {
            return List(viewModel.articles) { article in
                return ArticleListRow(article: article)
            }
        }
    }
}
