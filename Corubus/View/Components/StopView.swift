import SwiftUI

struct StopView: View {
    enum Collapse { case collapsed, expanded, semiexpanded }

    @EnvironmentObject var appState: AppState
    var stop: Stop
    var collapsed: Collapse = .semiexpanded
    var addableToHistory = false
    var autoFetch = false
    @State var currentCollapsed: Collapse?
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

        if (currentCollapsed == Collapse.expanded) {
            self.currentCollapsed = collapsed
            if collapsed == Collapse.collapsed {
                self.timer?.invalidate()
                self.timer = nil
                self.linesETAs = nil
            }
        } else {
            self.currentCollapsed = Collapse.expanded
            if self.timer == nil {
                self.pollLinesETAs()
            }
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 15) {
                Text(String(stop.id))
                    .fontWeight(.semibold)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(stop.name)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(Font.footnote.weight(.semibold))
                            .foregroundColor(Color(UIColor.systemGray3))
                            .rotationEffect(.degrees((currentCollapsed ?? collapsed) == Collapse.expanded ? -180 : 0))
                    }

                    if (currentCollapsed ?? collapsed) != .collapsed {
                        Connections(stop: stop, leftMargin: 70, expanded: (currentCollapsed ?? collapsed) == .expanded, linesETAs: linesETAs)
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
            }
        }
        .padding(.vertical, 6)
        .onAppear {
            if self.autoFetch && (self.currentCollapsed ?? self.collapsed) != .collapsed {
                self.pollLinesETAs()
            }
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }
}
