//
//  ArticleNewsViewModel.swift
//  XCANews
//
//  Created 
//

import SwiftUI

enum DataFetchPhase<T> {
    
    case empty
    case success(T)
    case failure(Error)
}

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    
    private let newsAPI = NewsAPI.shared
    @Published var searchText: String = ""
    @Published var selectedCategoryString: String = "All"

    let categories = ["All", "general", "technology", "sports", "business", "science"]
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    var filteredArticles: [Article] {
        var result: [Article] = {
            if case let .success(articles) = phase {
                return articles
            } else {
                return []
            }
        }()

        // 🔥 FIXED CATEGORY FILTER
        if selectedCategoryString != "All" {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(selectedCategoryString)
                || ($0.description?.localizedCaseInsensitiveContains(selectedCategoryString) ?? false)
            }
        }

        // 🔍 SEARCH FILTER (keep this same)
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                $0.source.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }
    
    var featuredArticle: Article? {
        filteredArticles.first
    }

    var remainingArticles: [Article] {
        Array(filteredArticles.dropFirst())
    }
    
    
    func loadArticles() async {
        if Task.isCancelled { return }
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            
            
            
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
