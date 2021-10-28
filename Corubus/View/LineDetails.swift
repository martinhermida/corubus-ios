import SwiftUI

struct LineDetails: View {
    @EnvironmentObject var appState: AppState
    @State private var section = "journey"
    @State private var returnJourney = false
    @State private var busesData: [Set<Int>] = [[], []]
    @State private var timetableLoading = false
    @State private var timetable = [[String: [String]]](repeating: [:], count: 2)
    @State private var timer: Timer?
    let tabs = [NSLocalizedString("lineDetailsSection.journey", comment: ""), NSLocalizedString("lineDetailsSection.timetable", comment: "")]
    var line: Line
    
    func fetchData() {
        timer = line.pollBuses() { busesData = $0 }
        
        timetableLoading = true
        line.getTimetable() {
            timetable = $0
            timetableLoading = false
        }
    }

    func Header() -> some View {
        Picker(selection: self.$section, label: Text("")) {
            Text("lineDetailsSection.journey").tag("journey")
            Text("lineDetailsSection.timetable").tag("timetable")
            Text("lineDetailsSection.map").tag("map")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    func FavoriteToggle() -> some View {
        Group {
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
    
    var body: some View {
        Group {
            switch section {
            case "journey":
                LineJourney(line: line, returnJourney: returnJourney, stopsWithBuses: busesData[returnJourney ? 1 : 0])
            case "timetable":
                LineTimetable(timetable: timetable[returnJourney ? 1 : 0], timetableLoading: timetableLoading)
            case "map":
                LineMap(returnJourney: returnJourney, line: line)
            default:
                EmptyView()
            }
        }
        .listStyle(PlainListStyle())
        .safeAreaInset(edge: .bottom) {
            DirectionSelector(line: line, returnJourney: self.$returnJourney)
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: Header)
            ToolbarItem(placement: .primaryAction, content: FavoriteToggle)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchData)
        .onDisappear(perform: {
            self.timer?.invalidate()
        })
    }
}
