//
//  Article.swift
//  XCANews
//
//  Created
//

import Foundation
struct Article {
    
    // This id will be unique and auto generated from client side to avoid clashing of Identifiable in a List as NewsAPI response doesn't provide unique identifier
    let id = UUID()

    let source: Source
    let title: String
    let url: String
    let publishedAt: String
    
    let author: String?
    let description: String?
    let urlToImage: String?
    let category: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
        case content
        case category
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name)"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
    
    func formattedDate() -> String {

        let formatter = ISO8601DateFormatter()

        guard let date = formatter.date(from: publishedAt) else { return "" }

        let display = DateFormatter()

        display.dateStyle = .medium

        display.timeStyle = .none

        return display.string(from: date)

    }
    
    
}

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {}

extension Article {
    
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
       
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
}


struct Source {
    let id: String?
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}
