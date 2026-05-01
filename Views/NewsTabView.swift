//
//  NewsTabView.swift
//  XCANews
//
//  Created 
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
  
    var body: some View {
        NavigationView {
            
            VStack {
                
                CategoryTabsView(
                    categories: articleNewsVM.categories,
                    selected: $articleNewsVM.selectedCategoryString
                )
                SearchBarView(text: $articleNewsVM.searchText)
                ScrollView {
                    VStack(spacing: 16) {

                        // ⭐ Featured card
                        if let first = articleNewsVM.filteredArticles.first {
                            NavigationLink(destination: ArticleDetailView(article: first)) {
                                FeaturedCardView(article: first)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        // 📃 Remaining articles
                        ForEach(articleNewsVM.filteredArticles.dropFirst()) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleCardView(article: article)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 10)
                }
                .overlay(overlayView)
                
            }
            .task(id: articleNewsVM.fetchTaskToken, loadTask)
            .refreshable(action: refreshTask)
            .navigationTitle(articleNewsVM.selectedCategoryString)
            .navigationBarItems(trailing: menu)
            .animation(.easeInOut, value: articleNewsVM.filteredArticles)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty:
            ProgressView("Fetching latest news...")
        case .success(let articles) where articles.isEmpty:
            VStack(spacing: 12) {
                Image(systemName: "newspaper")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)

                Text("No articles found")
                    .font(.headline)

                Text("Try another category or search")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    @Sendable
    private func refreshTask() {
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared

    
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
