import SwiftUI

struct JourneyGraph: View {
    @State var rect = CGRect()
    var line: Line
    var isFirst: Bool
    var isLast: Bool
    var index: Int
    var isBusInStop: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: line.color))
                .frame(width: 4)
                .cornerRadius(2)
                .padding(EdgeInsets(
                    top: isFirst ? rect.height / 2 : -14,
                    leading: 0,
                    bottom: isLast ? rect.height / 2 : -14,
                    trailing: 0
                ))
                .animation(.none)

            if isBusInStop {
                Circle()
                    .overlay(Circle().stroke(Color(hex: line.color), lineWidth: 4))
                    .foregroundColor(.white)
                    .frame(width: 23, height: 23, alignment: .center)
                    .padding(.leading, 0)
                    .transition(.scale)
            }

        }
        .frame(width: 47)
        .background(GeometryGetter(rect: self.$rect))
    }
}
