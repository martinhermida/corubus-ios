import SwiftUI

struct JourneyGraph: View {
    @State var rect = CGRect()
    var line: Line
    var isFirst: Bool
    var isLast: Bool
    var index: Int

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(hex: line.color))
                .frame(width: 3)
                .cornerRadius(1.5)
                .padding(EdgeInsets(
                    top: isFirst ? rect.height / 2 : -12,
                    leading: 0,
                    bottom: isLast ? rect.height / 2 : -12,
                    trailing: 0
                ))

        }
        .frame(width: 47)
        //.background(GeometryGetter(rect: self.$rect))
    }
}
