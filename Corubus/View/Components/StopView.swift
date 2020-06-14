import SwiftUI

struct StopView: View {
    enum Collapse { case collapsed, expanded, semiexpanded }

    @EnvironmentObject var appState: AppState
    var stop: Stop
    var collapsed: Collapse = .semiexpanded
    var addableToHistory: Bool = false
    @State var currentCollapsed: Collapse?

    func onTap() {
        if (addableToHistory) {
            var searchHistory = appState.searchHistory.filter { $0 != stop.id }
            searchHistory.insert(stop.id, at: 0)
            appState.searchHistory = searchHistory
            appState.save()
        }

        if (currentCollapsed == Collapse.expanded) {
            self.currentCollapsed = collapsed
        } else {
            self.currentCollapsed = Collapse.expanded
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
                        Connections(stop: stop, leftMargin: 0, expanded: (currentCollapsed ?? collapsed) == .expanded)
                            .padding(.bottom, 4)
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
}
