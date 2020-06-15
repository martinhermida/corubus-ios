import SwiftUI

struct ListSectionHeader: View {
    var text: String

    var body: some View {
        Text(NSLocalizedString(text, comment: "").uppercased())
            .font(.footnote)
            .fontWeight(.bold)
            .padding(.vertical, 10)
    }
}
