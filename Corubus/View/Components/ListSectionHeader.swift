import SwiftUI

struct ListSectionHeader: View {
    var text: String

    var body: some View {
        Text(NSLocalizedString(text, comment: ""))
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
    }
}

struct ListSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        ListSectionHeader(text: "Hello, World!")
    }
}
