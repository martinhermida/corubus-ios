import SwiftUI

struct Connection: View {
    static public let width = CGFloat(36)
    var line: Line

    var body: some View {
        ZStack {
            Color(hex: line.color)
            Text(line.code)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(width: 30, height: 18)
        .cornerRadius(3)
        .padding(3)
    }
}

struct Connections: View {
    var stop: Stop
    var expanded: Bool
    var linesETAs: [Int: [String]]?
    @EnvironmentObject var appState: AppState

    func getConnectedLines() -> [Line] {
        return stop.connectionIds.map { appState.lines[$0]! }
    }

    func renderConnection(_ connectionId: Int) -> some View {
        let line = appState.lines[connectionId]!

        return HStack(spacing: 3) {
            Connection(line: line)

            if self.linesETAs != nil && self.linesETAs![line.id] != nil {
                Text(self.linesETAs![line.id]![0] + "'")
                    .font(.footnote)
            }
        }
    }

    func renderCollapsed() -> some View {
        Group {
            if stop.connectionIds.count > 0 {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: self.linesETAs != nil ? 50 : 27))], alignment: .leading, spacing: 0) {
                    ForEach(stop.connectionIds, id: \.self) { connectionId in
                        self.renderConnection(connectionId)
                    }
                }
            } else {
                Text("stops.noLines")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 3)
            }
        }
    }

    func renderExpandedWithETAs() -> some View {
        Group {
            if stop.connectionIds.count > 0 {
                ForEach(getConnectedLines()) { line in
                    HStack(alignment: .top) {
                        Connection(line: line)

                        if self.linesETAs![line.id] != nil {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 23))], alignment: .trailing) {
                                ForEach(self.linesETAs![line.id]!, id: \.self) { time in
                                    Text(time + "'").font(.footnote)
                                }
                            }
                            .padding(.vertical, 5)
                        } else {
                            Text("stops.noBuses")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading, 3)
                        }
                    }
                }
            } else {
                Text("stops.noLines")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 3)
            }
        }
    }

    func renderExpandedLoadingETAs() -> some View {
        HStack {
            VStack(spacing: 0) {
                ForEach(getConnectedLines()) { line in
                    Connection(line: line)
                }
            }

            HStack(alignment: .center) {
                Spacer()
                ActivityIndicator(style: .medium)
                Spacer()
            }
        }
    }

    func renderExpanded() -> some View {
        Group {
            if self.linesETAs == nil {
                renderExpandedLoadingETAs()
            } else {
                renderExpandedWithETAs()
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if expanded {
                renderExpanded()
            } else {
                renderCollapsed()
                    .animation(.default)
                    .transition(.scale)
            }
        }
        .padding(-3)
    }
}
