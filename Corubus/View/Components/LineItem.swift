import SwiftUI

struct LineItem: View {
    var line: Line
    
    var body: some View {
        NavigationLink(destination: LineDetails(line: line)) {
            HStack {
                ZStack {
                    Color(hex: line.color)
                    Text(line.code)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                }
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(5)
                
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
