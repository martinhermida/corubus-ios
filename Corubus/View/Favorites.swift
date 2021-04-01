import SwiftUI

struct Favorites: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            Group {
                if appState.favoriteStops.count > 0 || appState.favoriteLines.count > 0 {
                    List {
                        if appState.favoriteStops.count > 0 {
                            Section(header: ListSectionHeader(text: "tabs.stops")) {
                                ForEach(appState.favoriteStops, id: \.self) {
                                    StopView(stop: self.appState.stops[$0]!, autoFetch: true)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
                            .textCase(.none)
                        }
                        if appState.favoriteLines.count > 0 {
                            Section(header: ListSectionHeader(text: "tabs.lines")) {
                                ForEach(appState.favoriteLines, id: \.self) {
                                    LineView(line: self.appState.lines[$0]!)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
                            .textCase(.none)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    VStack {
                        Image(systemName: "star")
                            .font(.system(size: 60))
                            .foregroundColor(Color(UIColor.systemGray3))

                        Spacer().frame(height: 60)

                        Text("favorites.placeholder.title")

                        Spacer().frame(height: 30)

                        Text("favorites.placeholder.body")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 45)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -60)
                }
            }
            .navigationBarTitle("tabs.favorites")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "star.fill").imageScale(.large)
            Text("tabs.favorites")
        }
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
    }
}
