import SwiftUI

struct ContentView: View {
    @State private var selection = "favorites"
 
    var body: some View {
        TabView(selection: $selection){
            Favorites().tag("favorites")
            Stops().tag("stops")
            Lines().tag("lines")
        }
        .onAppear {
            UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        }
    }
}
