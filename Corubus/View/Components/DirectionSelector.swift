import SwiftUI

struct DirectionSelector: View {
    var line: Line
    @Binding var returnJourney: Bool

    func changeDirection() {
        self.returnJourney = !self.returnJourney
    }

    var body: some View {
        ZStack {
            Blur(style: .systemChromeMaterial)
                .edgesIgnoringSafeArea(.horizontal)
            VStack {
                Divider()
                    .edgesIgnoringSafeArea(.horizontal)

                Spacer()

                HStack {
                    LineNumber(line: line)

                    Spacer().frame(width: 15)

                    VStack(alignment: .leading) {
                        Text(returnJourney ? self.line.lineEnd : self.line.lineStart).font(.subheadline)
                        Spacer().frame(width: 3, height: 3, alignment: .center)
                        Text(returnJourney ? self.line.lineStart : self.line.lineEnd).font(.subheadline)
                    }

                    Spacer()

                    Button(action: changeDirection) {
                        Image(systemName: "arrow.2.circlepath").font(.system(size: 25))
                    }
                    .frame(width: 70, height: 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                Spacer()
            }
        }
        .frame(height: 60)
    }
}
