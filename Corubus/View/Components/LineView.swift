import SwiftUI

struct LineView: View {
    @EnvironmentObject var appState: AppState
    var line: Line
    
    var body: some View {
        NavigationLink(destination: LineDetails(line: line)) {
            HStack {
                LineNumber(line: line)
                
                Spacer().frame(width: 15, height: 15, alignment: .center)

                VStack(alignment: .leading) {
                    Text(line.lineStart).font(.subheadline)
                    Spacer().frame(width: 3, height: 3, alignment: .center)
                    Text(line.lineEnd).font(.subheadline)
                }
            }
            .contextMenu {
                if appState.favoriteLines.contains(line.id) {
                    Button(action: {
                        self.appState.favoriteLines.removeAll(where: { $0 == self.line.id })
                        self.appState.save()
                    }) {
                        Text("favorites.remove")
                        Image(systemName: "star")
                    }
                } else {
                    Button(action: {
                        self.appState.favoriteLines.insert(self.line.id, at: 0)
                        self.appState.save()
                    }) {
                        Text("favorites.add")
                        Image(systemName: "star.fill")
                    }
                }
            }
        }
    }
}
