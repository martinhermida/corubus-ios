import SwiftUI

struct ActivateLocation: View {
    var requestAuthorization: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            Text("stops.nearbyPlaceholder")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.horizontal, 15)

            Button(action: requestAuthorization) {
                Text("enableLocation")
                    .font(Font.body.smallCaps())
                    .foregroundColor(Color.blue)
                    .padding(EdgeInsets(top: 1.5, leading: 10, bottom: 4, trailing: 10))
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.blue, lineWidth: 1))
            }
        }
    }
}

struct ActivateLocation_Previews: PreviewProvider {
    static var previews: some View {
        ActivateLocation() {}
    }
}
