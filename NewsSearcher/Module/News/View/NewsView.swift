import SwiftUI

// TODO: Добавить Алерты ошибок
// TODO: Добавить чипсы категорий
// TODO: Использовать Source

struct NewsView: View {
    @State private var alertViewModel = AlertViewModel()
    @State private var viewModel: NewsViewModel

    init() {
        let alertViewModel = AlertViewModel()
        _alertViewModel = State(wrappedValue: alertViewModel)
        _viewModel = State(wrappedValue: NewsViewModel(alertViewModel: alertViewModel))
    }

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
                                Text(NSLocalizedString("Author: \(author)", comment: "Author label")) // TODO: Локализовать
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(NSLocalizedString("English", comment: "Language option")) { // TODO: Локализовать
                            viewModel.switchLanguage(.en)
                        }
                        Button(NSLocalizedString("Russian", comment: "Language option")) { // TODO: Локализовать
                            viewModel.switchLanguage(.ru)
                        }
                    } label: {
                        Image(systemName: "globe")
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle(NSLocalizedString("News", comment: "Navigation title")) // TODO: Локализовать
            .refreshable {
                viewModel.fetchNews()
            }
            .onSubmit(of: .search) {
                viewModel.fetchNews()
            }
            .alert(NSLocalizedString("Ошибка", comment: "Alert title"), isPresented: $alertViewModel.isPresented) { // TODO: Локализовать
                Button(NSLocalizedString("OK", comment: "Alert dismiss button")) {
                    alertViewModel.dismissAlert()
                }
            } message: {
                Text(alertViewModel.message)
            }
        }
    }
    
    
}

#Preview {
    NewsView()
}
