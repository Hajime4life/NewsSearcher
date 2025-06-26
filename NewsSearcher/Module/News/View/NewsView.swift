import SwiftUI

struct NewsView: View {
    @State private var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.news, id: \.self) { newsItem in
                    NavigationLink(destination: DetailView(news: newsItem)) {
                        VStack(alignment: .leading) {
                            
                            if let imageUrl = newsItem.urlToImage {
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
                            
                            Text(newsItem.title)
                                .font(.system(size: 14))
                                .padding(.top, 5)
                            
                            if let author = newsItem.author {
                                Text("Автор: \(author)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                    .padding(.top, 5)
                            }
                            
                            if let date = newsItem.publishedAt?.toHumanReadableDate() {
                                Text(date)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.gray)
                                    .opacity(0.8)
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("News") // TODO: Локализировать
            .onSubmit(of: .search) {
                viewModel.fetchNews()
            }
        }
    }
    

}

#Preview {
    NewsView()
}
