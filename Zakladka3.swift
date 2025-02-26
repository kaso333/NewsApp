
import SwiftUI

struct Zakladka3: View {
    @Binding var wybranaZakladka: Int
    @State private var shareFavoritedSessions = false
    @State private var notifMode = 0
    var modes = ["Włączone", "Wyłączone"];
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Preferencje")) {
                        Toggle(isOn: $shareFavoritedSessions){
                            Text("Wyłącz dźwięk")}
                        
                        Picker(selection: $notifMode, label: Text( "Powiadomienia")) {
                            ForEach(0..<modes.count) {
                                Text(self.modes[$0])
                            }
                        }
                    }
                    Section(header: Text("O aplikacji")) { HStack {
                        Text("Nazwa")
                        Spacer()
                        Text("Informator")
                    }
                        HStack {
                            Text("Wersja")
                            Spacer()
                            Text("1.0.47")
                        }
                        HStack {
                            Text("Stworzona przez")
                            Spacer()
                            Text("Kacper Sosnowski")
                        }
                    }
                }
                .navigationBarTitle("Ustawienia")
            }
        }
    }


