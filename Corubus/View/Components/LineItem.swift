import SwiftUI

struct LineItem: View {
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
        }
    }
}
