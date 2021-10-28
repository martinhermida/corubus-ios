import SwiftUI

struct TimetableHour: View {
    let hourKey: String
    let hours: [String]
    
    var body: some View {
        HStack {
            Text(hourKey)
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 30)

            Spacer().frame(width: 15)
            
            ForEach(0 ..< hours.count, id: \.self) { i in
                Text(hours[i])
                    .font(.subheadline)
                    .frame(width: 45, alignment: .leading)
            }
        }
        .padding(.vertical, 13)
    }
}

struct LineTimetable: View {
    var timetable: [String: [String]]
    var timetableLoading: Bool

    var list: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(self.timetable).sorted(by: { Int($0.0)! < Int($1.0)! }), id: \.self.0) { hourKey, hours in
                    VStack(alignment: .leading, spacing: 0) {
                        TimetableHour(hourKey: hourKey, hours: hours)
                        Divider()
                            .padding(.leading, 45)
                    }
                    .padding(.leading, 15)
                }
            }
        }
    }
    
    var loading: some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    var body: some View {
        if timetableLoading {
            loading
        } else {
            list
        }
    }
}
