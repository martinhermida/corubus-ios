import SwiftUI

struct LineNumber: View {
    var line: Line

    var body: some View {
        ZStack {
            Color(hex: line.color)
            Text(line.code)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
        }
        .frame(width: 40, height: 40, alignment: .center)
        .cornerRadius(7.5)
    }
}
