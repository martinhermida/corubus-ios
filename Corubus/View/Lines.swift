import SwiftUI

struct Lines: View {
    @EnvironmentObject var appState: AppState
    
    var list: some View {
        let lines = self.appState.orderedLines
        
        return (
            List(lines.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    LineView(line: lines[index])
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    
                    if index != lines.count - 1 {
                        Divider()
                            .padding(.leading, 70)
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            }
        )
    }
    
    var body: some View {
        NavigationView {
            Group {
                if self.appState.orderedLines.count == 0 && appState.linesLoading {
                    ProgressView()
                } else {
                    list
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
