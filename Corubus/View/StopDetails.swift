import SwiftUI
import MapKit

struct StopDetails: View {
    let stop: Stop
    @State var linesETAs: [Int: [String]]?
    @State private var timer: Timer?
    
    init(stop: Stop, linesETAs: [Int: [String]]?) {
        self.stop = stop
        self.linesETAs = linesETAs
    }
    
    func pollLinesETAs() {
        self.timer = self.stop.pollLinesETAs { linesETAs in
            self.linesETAs = linesETAs
        }
    }
    
    func openMap() {
        let mapItem = MKMapItem(
            placemark: MKPlacemark(
                coordinate: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            )
        )
        mapItem.name = stop.name
        mapItem.openInMaps()
    }
    
    var body: some View {
        List {
            Section(header:
                Text(stop.name)
                    .font(Font.title.bold())
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                    .padding(.top, 5)
                    
            ) {
                EmptyView()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Section(header: ListSectionHeader(text: "stop.ETAsTitle")) {
                Connections(stop: stop, expanded: true, linesETAs: linesETAs)
                    .padding(.vertical, 7)
            }
            .textCase(.none)

            MapView(stop: stop)
                .frame(height: 200, alignment: .center)
                .padding(EdgeInsets(top: -10, leading: -20, bottom: -10, trailing: -20))
                .onTapGesture(perform: openMap)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(String(stop.id), displayMode: .inline)
        .onAppear {
            self.pollLinesETAs()
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }
}
