import SwiftUI

struct StopView: View {
    @EnvironmentObject var appState: AppState
    var stop: Stop
    var collapsed = false
    var addableToHistory = false
    var removableFromHistory = false
    var autoFetch = false
    @State var currentCollapsed: Bool?
    @State var linesETAs: [Int: [String]]?
    @State private var timer: Timer?

    func pollLinesETAs() {
        self.timer = self.stop.pollLinesETAs { linesETAs in
            self.linesETAs = linesETAs
        }
    }

    func onTap() {
        if (addableToHistory) {
            var searchHistory = appState.searchHistory.filter { $0 != stop.id }
            searchHistory.insert(stop.id, at: 0)
            appState.searchHistory = searchHistory
            appState.save()
        }
    }

    var body: some View {
        NavigationLink(destination: StopDetails(stop: stop)) {
            HStack(alignment: .top, spacing: 10) {
                Text(String(stop.id))
                    .fontWeight(.semibold)
                    .frame(width: 35)

                VStack(alignment: .leading, spacing: 8) {
                    Text(stop.name)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)

                    if (currentCollapsed ?? collapsed) == false {
                        Connections(stop: stop, linesETAs: linesETAs)
                            .padding(.bottom, 4)
                    }
                }
            }
            .contextMenu {
                if appState.favoriteStops.contains(stop.id) {
                    Button(action: {
                        self.appState.favoriteStops.removeAll(where: { $0 == self.stop.id })
                        self.appState.save()
                    }) {
                        Text("favorites.remove")
                        Image(systemName: "star")
                    }
                } else {
                    Button(action: {
                        self.appState.favoriteStops.insert(self.stop.id, at: 0)
                        self.appState.save()
                    }) {
                        Text("favorites.add")
                        Image(systemName: "star.fill")
                    }
                }
                if removableFromHistory {
                    Button(action: {
                        self.appState.searchHistory.removeAll(where: { $0 == self.stop.id })
                        self.appState.save()
                    }) {
                        Text("stops.removeFromHistory")
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
        .foregroundColor(.primary)
        .onAppear {
            if self.autoFetch {
                self.pollLinesETAs()
            }
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }
}
