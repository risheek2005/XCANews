//
//  NewsAPI.swift
//  XCANews

import Foundation

struct NewsAPI {

    static let shared = NewsAPI()
    private init() {}

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func fetch(from category: Category) async throws -> [Article] {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""

        let urlString = "https://newsapi.org/v2/everything?q=technology&sortBy=publishedAt&apiKey=\(apiKey)"

           guard let url = URL(string: urlString) else {

               throw error(description: "Invalid URL")

           }

           let (data, _) = try await URLSession.shared.data(from: url)

           let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)

           guard apiResponse.status == "ok" else {

               throw error(description: apiResponse.message ?? "Error")

           }

           return apiResponse.articles ?? []
    }

    
    private func error(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
