import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.news, id: \.self) { newsItem in
                    VStack(alignment: .leading) {
                        Text(newsItem.author ?? "")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                        
                        Text(newsItem.title)
                            .font(.system(size: 14))
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
    ContentView()
}
