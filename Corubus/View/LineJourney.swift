import SwiftUI

struct LineJourney: View {
    static private let graphWidth = CGFloat(70)
    @EnvironmentObject var appState: AppState
    var line: Line
    var returnJourney: Bool
    var stopsWithBuses: Set<Int>

    func renderStopItem(stopId: Int, isFirst: Bool, isLast: Bool, index: Int) -> some View {
        let stop = appState.stops[stopId]!

        return HStack {
            JourneyGraph(line: line, isFirst: isFirst, isLast: isLast, index: index, isBusInStop: stopsWithBuses.contains(stopId))
                .animation(.default)

            VStack(alignment: .leading, spacing: 8) {
                Text(stop.name)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                Connections(stop: stop, linesETAs: nil)
                    .padding(.bottom, 4)
            }
            .padding(.trailing)
        }
        .padding(.vertical, 4)
    }

    var body: some View {
        let stops = returnJourney ? line.returnJourneyStopIds : line.outwardsJourneyStopIds

        return (
            ScrollView {
                ForEach(Array(stops.enumerated()), id: \.element) { index, element in
                    VStack {
                        self.renderStopItem(stopId: element, isFirst: index == 0, isLast: index == stops.count - 1, index: index)
                        
                        if index != stops.count - 1 {
                            Divider()
                                .padding(.leading, 55)
                        }
                    }
                    .padding(.leading, 10)
                }
            }
        )
    }
}
