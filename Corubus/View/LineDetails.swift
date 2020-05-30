import SwiftUI

struct LineDetails: View {
    @State private var section = "journey"
    @State private var returnJourney = false
    @State private var busesData: [Set<Int>] = [[], []]
    @State private var timetable = [[String: [String]]](repeating: [:], count: 2)
    @State private var timer: Timer?
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
                LineJourney(line: line, returnJourney: returnJourney, stopsWithBuses: busesData[returnJourney ? 1 : 0])
            } else {
                LineTimetable(timetable: timetable[returnJourney ? 1 : 0])
            }

            DirectionSelector(line: line, returnJourney: self.$returnJourney)
        }
        .navigationBarItems(trailing: Header)
        .navigationBarTitle("", displayMode: .inline)
        .onAppear(perform: {
            self.timer = self.line.pollBuses() { stopsWithBuses in
                self.busesData = stopsWithBuses
            }
            self.line.getTimetable() { timetable in
                self.timetable = timetable
            }
        })
        .onDisappear(perform: {
            self.timer?.invalidate()
        })
    }
}
