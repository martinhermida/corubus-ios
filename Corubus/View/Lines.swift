import SwiftUI

struct Lines: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Group {
                if self.appState.orderedLines.count == 0 && appState.linesLoading {
                    ActivityIndicator(style: .large)
                } else {
                    List(self.appState.orderedLines) { line in
                        LineItem(line: line)
                    }
                }
            }
            .navigationBarTitle("tabs.lines")
        }
        .tabItem {
            Image(systemName: "tram.fill").font(.system(size: 19))
            Text("tabs.lines")
        }
    }
}

struct Lines_Previews: PreviewProvider {
    static var previews: some View {
        Lines()
    }
}
