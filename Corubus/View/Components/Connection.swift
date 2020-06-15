import SwiftUI

struct Connection: View {
    static public let width = CGFloat(36)
    var line: Line

    var body: some View {
        Text(line.code)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 30, height: 18)
            .background(Color(hex: line.color))
            .cornerRadius(3)
            .padding(3)
    }
}

struct Connections: View {
    var stop: Stop
    var leftMargin: CGFloat
    var expanded: Bool
    var columns: Int
    var rows: Int
    var linesETAs: [Int: [String]]?
    @EnvironmentObject var appState: AppState

    init(stop: Stop, leftMargin: CGFloat, expanded: Bool, linesETAs: [Int: [String]]?) {
        self.columns = Int(floor((UIScreen.main.bounds.width - 15 - leftMargin) / Connection.width))
        self.rows = Int(ceil(Float(stop.connectionIds.count) / Float(self.columns)))
        self.stop = stop
        self.leftMargin = leftMargin
        self.expanded = expanded
        self.linesETAs = linesETAs
    }

    func getConnectedLines() -> [Line] {
        return stop.connectionIds.map { appState.lines[$0]! }
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
        Wrap(getConnectedLines(), id: \.id) { line in
            HStack {
                Connection(line: line)

                if self.linesETAs != nil && self.linesETAs![line.id] != nil {
                    Text(self.linesETAs![line.id]![0] + "'")
                        .font(.footnote)
                        .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 6))
                }
            }
        }
    }

    func renderExpanded() -> some View {
        ForEach(getConnectedLines()) { line in
            HStack {
                Connection(line: line)

                if self.linesETAs != nil {
                    if self.linesETAs![line.id] != nil {
                        Wrap(self.linesETAs![line.id]!, id: \.self) { eta in
                            Text(eta + "'")
                                .font(.footnote)
                                .frame(width: 21, alignment: .trailing)
                                .padding(.trailing, 9)
                        }
                        .padding(.leading, -1)
                    } else if (self.linesETAs!.count != 0) {
                        Text("stops.noBuses")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                }
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
