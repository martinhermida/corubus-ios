import SwiftUI

struct Lines: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Group {
                if self.appState.orderedLines.count == 0 && appState.linesLoading {
                    ProgressView()
                } else {
                    List(self.appState.orderedLines) { line in
                        LineView(line: line)
                    }
                }
            }
            .navigationBarTitle("tabs.lines")
        }
        .tabItem {
            Image(systemName: "tram.fill").imageScale(.large)
            Text("tabs.lines")
        }
    }
}

struct Lines_Previews: PreviewProvider {
    static var previews: some View {
        Lines()
    }
}
