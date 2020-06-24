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
    var connectionsColumns: Int
    var connectionsRows: Int
    var etasColumns = 0
    var linesETAs: [Int: [String]]?
    @EnvironmentObject var appState: AppState

    init(stop: Stop, leftMargin: CGFloat, expanded: Bool, linesETAs: [Int: [String]]?) {
        self.stop = stop
        self.leftMargin = leftMargin
        self.expanded = expanded
        self.linesETAs = linesETAs

        if (linesETAs == nil || linesETAs!.count == 0) {
            self.connectionsColumns = Int(floor((UIScreen.main.bounds.width - 15 - leftMargin) / Connection.width))
        } else {
            self.connectionsColumns = Int(floor((UIScreen.main.bounds.width - 15 - leftMargin) / (Connection.width + 27)))
            self.etasColumns = Int(floor((UIScreen.main.bounds.width - 15 - leftMargin) / 27))
        }

        self.connectionsRows = Int(ceil(Float(stop.connectionIds.count) / Float(self.connectionsColumns)))
    }

    func getConnectedLines() -> [Line] {
        return stop.connectionIds.map { appState.lines[$0]! }
    }

    func renderConnection(stop: Stop, row: Int, column: Int) -> some View {
        let connectionIndex = (row * self.connectionsColumns) + column
        let line = connectionIndex < stop.connectionIds.count ? self.appState.lines[stop.connectionIds[connectionIndex]]! : nil

        return Group {
            if line != nil {
                Connection(line: line!)

                if self.linesETAs != nil && self.linesETAs![line!.id] != nil {
                    Text(self.linesETAs![line!.id]![0] + "'")
                        .font(.footnote)
                        .frame(width: 20, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 5))
                } else if self.linesETAs != nil {
                    Spacer().frame(width: 27)
                }
            }
        }
    }

    func renderETA(_ line: Line, _ row: Int, _ column: Int) -> some View {
        let lineETAs = self.linesETAs![line.id]!

        let etaIndex = (row * self.etasColumns) + column
        let eta = etaIndex < lineETAs.count ? lineETAs[etaIndex] : nil

        return Group {
            if eta != nil {
                Text(lineETAs[etaIndex] + "'")
                    .font(.footnote)
                    .frame(width: 20, alignment: .trailing)
                    .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 3))
            }
        }
    }

    func renderCollapsed() -> some View {
        Group {
            if stop.connectionIds.count > 0 {
                ForEach(0 ..< self.connectionsRows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0 ..< self.connectionsColumns, id: \.self) { column in
                            self.renderConnection(stop: self.stop, row: row, column: column)
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

    func renderExpandedWithETAs() -> some View {
        Group {
            if stop.connectionIds.count > 0 {
                ForEach(getConnectedLines()) { line in
                    HStack {
                        Connection(line: line)

                        if self.linesETAs![line.id] != nil {
                            ForEach(0 ..< Int(ceil(Float(self.linesETAs![line.id]!.count) / Float(self.etasColumns))), id: \.self) { row in
                                ForEach(0 ..< self.etasColumns, id: \.self) { column in
                                    self.renderETA(line, row, column)
                                }
                            }
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
            }
        }
        .padding(-3)
    }
}
