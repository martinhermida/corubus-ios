import SwiftUI

struct LineTimetable: View {
    var timetable: [String: [String]]

    var body: some View {
        List(Array(self.timetable).sorted(by: { Int($0.0)! < Int($1.0)! }), id: \.self.0) { hourKey, hours in
            Text(hourKey)
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 40)

            Spacer().frame(width: 15)

            HStack {
                ForEach(0 ..< hours.count, id: \.self) { i in
                    Text(hours[i])
                        .font(.subheadline)
                        .frame(width: 45, alignment: .leading)
                }
            }
        }
    }
}
