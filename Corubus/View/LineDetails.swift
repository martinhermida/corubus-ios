import SwiftUI

struct LineDetails: View {
    @EnvironmentObject var appState: AppState
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
            Text("lineDetailsSection.map").tag("map")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch section {
            case "journey":
                LineJourney(line: line, returnJourney: returnJourney, stopsWithBuses: busesData[returnJourney ? 1 : 0])
            case "timetable":
                LineTimetable(timetable: timetable[returnJourney ? 1 : 0])
            case "map":
                LineMap(returnJourney: returnJourney)
                    .environmentObject(line)
            default:
                EmptyView()
            }

            DirectionSelector(line: line, returnJourney: self.$returnJourney)
        }
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Header
            }
            ToolbarItem(placement: .primaryAction) {
                if appState.favoriteLines.contains(line.id) {
                    Button(action: {
                        self.appState.favoriteLines.removeAll(where: { $0 == self.line.id })
                        self.appState.save()
                    }) {
                        Image(systemName: "star.fill")
                    }
                    .accessibility(hint: Text("favorites.remove"))
                } else {
                    Button(action: {
                        self.appState.favoriteLines.insert(self.line.id, at: 0)
                        self.appState.save()
                    }) {
                        Image(systemName: "star")
                    }
                    .accessibility(hint: Text("favorites.remove"))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
