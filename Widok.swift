//
//  Widok.swift
//  Lab5
//
//  Created by Maciej Kazior on 09/06/2024.
//

import SwiftUI
import WebKit

struct Widok: UIViewRepresentable {
    let request: URLRequest
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
struct Widokens: View {
    let url: String
    
    var body: some View {
        Widok(request: URLRequest(url: URL(string: url)!))
    }
}


#Preview {
    Widokens(url: "https://www.google.com")
}
