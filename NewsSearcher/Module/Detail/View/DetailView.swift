import SwiftUI

struct DetailView: View {
    @State private var viewModel: DetailViewModel
    
    init(news: NewsModel) {
        let vm = DetailViewModel(news: news)
        _viewModel = State(initialValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let imageUrl = viewModel.news.urlToImage {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        PlaceholderImageView().Loading()
                    }
                } else {
                    PlaceholderImageView().Empty()
                }
                
                Text(viewModel.news.title)
                    .font(.title2)
                
                if let author = viewModel.news.author {
                    Text("Автор: \(author)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                if let source = viewModel.news.source?.name {
                    Text("@\(source)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                
                if let publishedDate = viewModel.news.publishedAt?.toHumanReadableDate() {
                    Text("Опубликовано: \(publishedDate)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                if let description = viewModel.news.description {
                    Text(description)
                        .font(.body)
                }
                
                if let url = viewModel.news.url, let validURL = URL(string: url) {
                    Link("Читать полностью", destination: validURL)
                        .font(.callout)
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .navigationTitle("Детали") // TODO: Локализировать
    }
}

#Preview {
    DetailView(news: NewsModel(
        author: "Andrew J. Hawkins",
        title: "Tesla continues to circle the drain",
        description: "We don’t typically report on monthly sales data for one car company in one market, but this one seems particularly notable given all that’s going on in the world...",
        url: "https://www.theverge.com/news/675058/tesla-europe-april-sales-musk-doge-brand-crisis",
        urlToImage: "https://platform.theverge.com/wp-content/uploads/sites/2/2025/02/STK086_TeslaB.jpg?quality=90&strip=all&crop=0%2C10.732984293194%2C100%2C78.534031413613&w=1200",
        publishedAt: "2025-05-28T02:50:41Z",
        content: "The companys sales in Europe plunged by nearly 50 percent, a sign that Teslas brand crisis is worsening.\r\nThe companys sales in Europe plunged by nearly 50 percent, a sign that Teslas brand crisis is… [+2962 chars]",
        source: SourceModel(id: "the-verge", name: "The Verge")
    ))
}
