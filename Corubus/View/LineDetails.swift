import SwiftUI

struct LineDetails: View {
    @State private var section = "journey"
    @State private var returnJourney = false
    let tabs = [NSLocalizedString("lineDetailsSection.journey", comment: ""), NSLocalizedString("lineDetailsSection.timetable", comment: "")]
    var line: Line

    var Header: some View {
        Picker(selection: self.$section, label: Text("")) {
            Text("lineDetailsSection.journey").tag("journey")
            Text("lineDetailsSection.timetable").tag("timetable")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if section == "journey" {
                LineJourney(line: line, returnJourney: returnJourney)
            } else {
                Spacer()
            }

            DirectionSelector(line: line, returnJourney: self.$returnJourney)
        }
        .navigationBarItems(trailing: Header)
        .navigationBarTitle("", displayMode: .inline)
    }
}
