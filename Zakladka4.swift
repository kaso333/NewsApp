//
//  Zakladka4.swift
//  Lab5
//
//  Created by Maciej Kazior on 09/06/2024.
//

import SwiftUI
import URLImage

struct Zakladka4: View {
        @Binding var wybranaZakladka: Int
        @Binding var favoriteArticles: [Article] // Otrzymujemy ulubione z głównej zakładki
        
        var body: some View {
            NavigationView {
                List(favoriteArticles, id: \.url) { article in
                    NavigationLink(destination: Widokens(url: article.url)) {
                        HStack {
                            URLImage(URL(string: article.urlToImage ?? "https://picsum.photos/100/100")!) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(width: 100, height: 100)
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.description ?? "")
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .navigationTitle("Ulubione")
            }
        }
    }
