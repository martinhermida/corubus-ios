import SwiftUI

struct Lines: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Group {
                if self.appState.orderedLines.count == 0 && appState.linesLoading {
                    ActivityIndicator(style: .large)
                } else {
                    List(self.appState.orderedLines, id: \.id) { line in
                        LineItem(line: line)
                    }.onAppear {
                        UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
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
