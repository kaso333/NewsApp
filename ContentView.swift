
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var wybranaZakladka = 0
    @State private var favoriteArticles = [Article]()
    
    var body: some View {
        if isLoggedIn {
            TabView(selection: $wybranaZakladka){
                Zakladka1(wybranaZakladka: $wybranaZakladka, favoriteArticles: $favoriteArticles)
                    .tabItem{
                        Image(systemName: "newspaper")
                        Text("News")
                    }.tag(1)
                Zakladka4(wybranaZakladka: $wybranaZakladka, favoriteArticles: $favoriteArticles)
                    .tabItem{
                        Image(systemName: "star.fill")
                        Text("Ulubione")
                    }.tag(2)
                Zakladka3(wybranaZakladka: $wybranaZakladka)
                    .tabItem{
                        Image(systemName:"gear")
                        Text("Informacje")
                    }.tag(3)
            }
        }
        else {
            VStack {
                TextField("Nazwa użytkownika", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Hasło", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Zaloguj") {
                    login()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Zarejestruj się") {
                    register()
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
    }
        
    func login() {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Błąd logowania: \(error.localizedDescription)")
                return
            }
            // Zalogowano pomyślnie
            print("Zalogowano jako: \(authResult?.user.email ?? "Brak e-maila")")
            isLoggedIn = true
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Błąd rejestracji: \(error.localizedDescription)")
                return
            }
            // Rejestracja zakończona sukcesem
            print("Zarejestrowano jako: \(authResult?.user.email ?? "Brak e-maila")")
            isLoggedIn = true
        }
    }
}
           
        


#Preview {
    ContentView()
}
