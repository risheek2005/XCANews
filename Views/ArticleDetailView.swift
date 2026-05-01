import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Hero image
                AsyncImage(url: article.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_), .empty:
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 260)
                .clipped()

                VStack(alignment: .leading, spacing: 16) {

                    if let category = article.category {
                        Text(category.uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.accentColor)
                    }

                    Text(article.title)
                        .font(.system(size: 22, weight: .bold))
                        .lineSpacing(4)

                    HStack(spacing: 14) {
                        Label(article.source.name, systemImage: "newspaper.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)

                        if let author = article.author {
                            Label(author, systemImage: "person.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }

                    Text(article.formattedDate())
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)

                    Divider()

                    if let description = article.description {
                        Text(description)
                            .font(.system(size: 16, weight: .medium))
                            .lineSpacing(6)
                    }

                    if let content = article.content {
                        Text(content)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .lineSpacing(7)
                    }

                    if let url = URL(string: article.url) { 
                        Link(destination: url) {
                            Text("Read Full Article")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
