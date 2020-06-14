import SwiftUI

struct Connection: View {
    static public let width = CGFloat(36)
    var line: Line

    var body: some View {
        Group {
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
}

struct Connections: View {
    var stop: Stop
    var leftMargin: CGFloat
    var expanded: Bool
    var columns: Int
    var rows: Int
    @EnvironmentObject var appState: AppState

    init(stop: Stop, leftMargin: CGFloat, expanded: Bool) {
        self.columns = Int(floor((UIScreen.main.bounds.width - 15 - leftMargin) / Connection.width))
        self.rows = Int(ceil(Float(stop.connectionIds.count) / Float(self.columns)))
        self.stop = stop
        self.leftMargin = leftMargin
        self.expanded = expanded
    }

    func renderConnection(stop: Stop, columns: Int, row: Int, column: Int) -> some View {
        let connectionIndex = (row * columns) + column

        return Group {
            if connectionIndex < stop.connectionIds.count {
                Connection(line: self.appState.lines[stop.connectionIds[connectionIndex]]!)
            }
        }
    }

    func renderCollapsed() -> some View {
        ForEach(0 ..< self.rows, id: \.self) { row in
            HStack(spacing: 0) {
                ForEach(0 ..< self.columns, id: \.self) { column in
                    self.renderConnection(stop: self.stop, columns: self.columns, row: row, column: column)
                }
            }
        }
    }

    func renderExpanded() -> some View {
        ForEach(stop.connectionIds, id: \.self) { connectionId in
            HStack {
                Connection(line: self.appState.lines[connectionId]!)
                Text("")
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if expanded {
                renderExpanded()
            } else {
                renderCollapsed()
            }
        }
        .padding(-3)
    }
}
