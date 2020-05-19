import SwiftUI

struct LineDetails: View {
    @State private var selectedSection = "journey"
    var line: Line

    var Header: some View {
        Picker(selection: self.$selectedSection, label: Text("")) {
            Text("lineDetailsSection.journey").tag("journey")
            Text("lineDetailsSection.timetable").tag("timetable")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarTitle(line.code)
    }
}
