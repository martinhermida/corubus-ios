import SwiftUI

struct ContentView: View {
    @State private var selection = "lines"
 
    var body: some View {
        TabView(selection: $selection){
            Favorites().tag("favorites")
            Text("View")
                .font(.title)
                .tabItem {
                    Image(systemName: "mappin").font(.system(size: 22))
                    Text("tabs.stops")
                }
                .tag("stops")
            Lines().tag("lines")
        }
    }
}
