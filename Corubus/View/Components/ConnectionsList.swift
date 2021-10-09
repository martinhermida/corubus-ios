import SwiftUI

struct ConnectionsList: View {
    let stop: Stop
    @State var linesETAs: [Int: [String]]?
    @State private var timer: Timer?
    @EnvironmentObject var appState: AppState
    
    func pollLinesETAs() {
        timer = stop.pollLinesETAs { linesETAs in
            self.linesETAs = linesETAs
        }
    }
    
    func renderLoading() -> some View {
        HStack(alignment: .center) {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    func renderETAs(_ line: Line) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 25))], alignment: .leading) {
            ForEach(self.linesETAs![line.id]!, id: \.self) { time in
                Text(time + "'").font(.footnote)
            }
        }
    }
    
    func renderNextArrivals() -> some View {
        let connectedLines = stop.connectionIds.map { appState.lines[$0]! }
        
        return (
            ForEach(connectedLines) { line in
                HStack {
                    Connection(line: line)
                    
                    Spacer()
                        .frame(width: 20)
                    
                    if linesETAs == nil {
                        renderLoading()
                    } else if linesETAs?[line.id] != nil {
                        renderETAs(line)
                    } else {
                        Text("stops.noBuses")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                }
            }
        )
    }
    
    var body: some View {
        Group {
            if stop.connectionIds.count > 0 {
                renderNextArrivals()
                    .onAppear(perform: pollLinesETAs)
                    .onDisappear {
                        timer?.invalidate()
                    }
            } else {
                Text("stops.noLines")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 3)
            }
        }
    }
}
