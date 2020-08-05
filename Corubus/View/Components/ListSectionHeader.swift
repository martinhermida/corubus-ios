import SwiftUI

struct ListSectionHeader: View {
    var text: String

    var body: some View {
        Text(NSLocalizedString(text, comment: ""))
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
    }
}
