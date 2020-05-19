import SwiftUI

struct Favorites: View {
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.title)
                .navigationBarTitle("tabs.favorites")
        }
        .tabItem {
            Image(systemName: "star.fill").font(.system(size: 22))
            Text("tabs.favorites")
        }
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
    }
}
