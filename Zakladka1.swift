
import SwiftUI
import URLImage

struct Result: Codable {
    var articles: [Article]
}

struct Article: Codable, Hashable {
    var url: String
    var title: String
    var description: String?
    var urlToImage: String?
}

struct Zakladka1: View {
    @Binding var wybranaZakladka: Int
    @Binding var favoriteArticles: [Article]
    @State private var readArticles = Set<String>() // Przechowuje przeczytane artykuły
    @State private var articles = [Article]()
    @State private var selectedLanguageIndex = 0
    @State private var selectedCategoryIndex = 0
    
    private let baseUrl = "https://newsapi.org/v2/top-headlines?"
    private let apiKey = "875bb4be701140afb42ac3f9bb7a594b"
    let languages = ["us"]
    let categories = ["sports", "business", "technology", "health"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Język", selection: $selectedLanguageIndex) {
                    ForEach(0..<languages.count, id: \.self) { index in
                        Text(self.languages[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedLanguageIndex) { _ in
                    fetchData()
                }

                Picker("Kategoria", selection: $selectedCategoryIndex) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        Text(self.categories[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedCategoryIndex) { _ in
                    fetchData()
                }

                List(articles, id: \.url) { article in
                    HStack {
                        NavigationLink(destination: Widokens(url: article.url)) {
                            HStack(alignment: .top) {
                                URLImage(URL(string: article.urlToImage ?? "https://picsum.photos/100/100")!) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                VStack(alignment: .leading) {
                                    Text(article.title)
                                        .font(.headline)
                                        .strikethrough(readArticles.contains(article.url), color: .red) // Przekreślenie
                                        .onTapGesture {
                                            markAsRead(article) // Wywołanie funkcji
                                        }
                                    Text(article.description ?? "")
                                        .font(.footnote)
                                }
                            }
                        }
                        Spacer()
                        Button(action: {
                            toggleFavorite(article)
                        }) {
                            Image(systemName: favoriteArticles.contains(where: { $0.url == article.url }) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .onAppear(perform: fetchData)
            .navigationTitle("Wiadomości")
        }
    }
    
    // Pobieranie danych
    private func fetchData() {
        let language = languages[selectedLanguageIndex]
        let category = categories[selectedCategoryIndex]
        let urlString = "\(baseUrl)country=\(language)&category=\(category)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Nie można utworzyć URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResult = try? JSONDecoder().decode(Result.self, from: data) {
                    DispatchQueue.main.async {
                        self.articles = decodedResult.articles
                    }
                    return
                }
            }
            print("Błąd: \(error?.localizedDescription ?? "Nieznany błąd")")
        }.resume()
    }
    
    // Dodawanie/Usuwanie artykułu z ulubionych
    private func toggleFavorite(_ article: Article) {
        if favoriteArticles.contains(where: { $0.url == article.url }) {
            favoriteArticles.removeAll { $0.url == article.url }
        } else {
            favoriteArticles.append(article)
        }
    }
    
    // Oznaczanie artykułu jako przeczytanego
    private func markAsRead(_ article: Article) {
        readArticles.insert(article.url)
    }
}
