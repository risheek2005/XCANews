
import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_), .empty:
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.15))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.accentColor.opacity(0.4))
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {

                HStack {
                    if let category = article.category {
                        Text(category)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.accentColor)
                    }

                    Spacer()

                    Text(article.source.name)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Text(article.title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(3)

                Text(article.formattedDate())
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}
