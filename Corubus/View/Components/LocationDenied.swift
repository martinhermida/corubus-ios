import SwiftUI

struct LocationDenied: View {
    var body: some View {
        Group {
            Text("stops.nearbyPlaceholder")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.horizontal, 15)
            Spacer().frame(height: 10)
            Text("stops.nearbySettings")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.horizontal, 15)
        }
    }
}

struct LocationDenied_Previews: PreviewProvider {
    static var previews: some View {
        LocationDenied()
    }
}
